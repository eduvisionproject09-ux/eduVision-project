package com.academicproject.eduvisionbackend.service;

import com.academicproject.eduvisionbackend.dto.BookCreateDto;
import com.academicproject.eduvisionbackend.dto.BookResponseDto;
import com.academicproject.eduvisionbackend.entity.Book;
import com.academicproject.eduvisionbackend.entity.User;
import com.academicproject.eduvisionbackend.repository.BookRepository;
import com.academicproject.eduvisionbackend.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpMethod;
import org.springframework.http.MediaType;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class BookService {

    private static final Logger logger = LoggerFactory.getLogger(BookService.class);

    @Autowired
    private BookRepository bookRepository;

    @Autowired
    private UserRepository userRepository;

    @Value("${supabase.url}")
    private String supabaseUrl;

    @Value("${supabase.key}")
    private String supabaseKey;

    @Value("${supabase.bucket}")
    private String supabaseBucket;

    private final RestTemplate restTemplate = new RestTemplate();

    // =========================================
    // Get Current Logged In User
    // =========================================

    private User getCurrentUser() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder
                .getContext()
                .getAuthentication()
                .getPrincipal();

        return userRepository
                .findByUsername(userDetails.getUsername())
                .orElseThrow(() -> new RuntimeException("User not found"));
    }

    // =========================================
    // Upload Book (file + metadata)
    // =========================================

    @Transactional
    public BookResponseDto uploadBook(
            MultipartFile file,
            String title,
            String author,
            String description,
            String isbn,
            String language,
            String category,
            Integer numberOfPages) throws IOException {

        User user = getCurrentUser();

        // Target path inside the Supabase Storage bucket
        String uniqueFileName = UUID.randomUUID() + "_" + file.getOriginalFilename();
        String storagePath = "books/" + uniqueFileName;

        // Upload to Supabase Storage REST API
        String uploadUrl = supabaseUrl + "/storage/v1/object/" + supabaseBucket + "/" + storagePath;
        logger.info("[book download] [upload] Starting upload for book: '{}', size: {} bytes", title, file.getSize());
        logger.info("[book download] [upload] Supabase Storage upload URL: {}", uploadUrl);
        
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + supabaseKey);
        headers.set("apiKey", supabaseKey);
        
        // Resolve Content-Type
        String contentType = file.getContentType();
        if (contentType == null) {
            contentType = "application/octet-stream";
        }
        headers.setContentType(MediaType.parseMediaType(contentType));
        logger.info("[book download] [upload] Content-Type set to: {}", contentType);
        
        HttpEntity<byte[]> entity = new HttpEntity<>(file.getBytes(), headers);
        
        try {
            logger.info("[book download] [upload] Sending POST request to Supabase Storage REST API...");
            restTemplate.postForEntity(uploadUrl, entity, String.class);
            logger.info("[book download] [upload] File successfully uploaded to Supabase bucket: {}", storagePath);
        } catch (Exception e) {
            logger.error("[book download] [upload] Error uploading to Supabase Storage: {}", e.getMessage(), e);
            throw new RuntimeException("Failed to upload file to Supabase Storage: " + e.getMessage(), e);
        }

        // Build and save the Book entity (storing the Supabase storage path in filePath)
        Book book = Book.builder()
                .title(title)
                .author(author)
                .description(description)
                .isbn(isbn)
                .language(language)
                .category(category)
                .numberOfPages(numberOfPages)
                .filePath(storagePath)
                .fileSize(file.getSize())
                .fileName(file.getOriginalFilename())
                .user(user)
                .build();

        return mapToDto(bookRepository.save(book));
    }

    // =========================================
    // Get All Books (paginated)
    // =========================================

    @Transactional(readOnly = true)
    public Page<BookResponseDto> getAllBooks(Pageable pageable) {
        User user = getCurrentUser();
        return bookRepository.findByUser(user, pageable).map(this::mapToDto);
    }

    // =========================================
    // Get All Books (full list)
    // =========================================

    @Transactional(readOnly = true)
    public List<BookResponseDto> getAllBooksList() {
        User user = getCurrentUser();
        return bookRepository.findByUser(user).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    // =========================================
    // Get Book By ID
    // =========================================

    @Transactional(readOnly = true)
    public BookResponseDto getBookById(Long id) {
        Book book = bookRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Book not found"));
        if (!book.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
        return mapToDto(book);
    }

    // =========================================
    // Get Book Entity (for file serving)
    // =========================================

    @Transactional(readOnly = true)
    public Book getBookEntityById(Long id) {
        Book book = bookRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Book not found"));
        if (!book.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
        return book;
    }

    // =========================================
    // Update Book Metadata
    // =========================================

    @Transactional
    public BookResponseDto updateBook(Long id, BookCreateDto dto) {
        Book book = bookRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Book not found"));
        if (!book.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }

        book.setTitle(dto.getTitle());
        book.setAuthor(dto.getAuthor());
        book.setDescription(dto.getDescription());
        book.setIsbn(dto.getIsbn());
        book.setLanguage(dto.getLanguage());
        book.setCategory(dto.getCategory());
        book.setNumberOfPages(dto.getNumberOfPages());

        return mapToDto(bookRepository.save(book));
    }

    // =========================================
    // Delete Book (+ file on disk)
    // =========================================

    @Transactional
    public void deleteBook(Long id) {
        Book book = bookRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Book not found"));
        if (!book.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }

        // Delete from Supabase Storage REST API
        String deleteUrl = supabaseUrl + "/storage/v1/object/" + supabaseBucket + "/" + book.getFilePath();
        
        HttpHeaders headers = new HttpHeaders();
        headers.set("Authorization", "Bearer " + supabaseKey);
        headers.set("apiKey", supabaseKey);
        
        HttpEntity<Void> entity = new HttpEntity<>(headers);
        
        try {
            restTemplate.exchange(deleteUrl, HttpMethod.DELETE, entity, Void.class);
        } catch (Exception e) {
            // Log warning but continue deleting DB record so it doesn't get orphaned
            System.err.println("Warning: failed to delete file from Supabase Storage: " + e.getMessage());
        }

        bookRepository.delete(book);
    }

    // =========================================
    // Toggle Favorite
    // =========================================

    @Transactional
    public BookResponseDto toggleFavorite(Long id) {
        Book book = bookRepository.findById(id).orElseThrow(
                () -> new RuntimeException("Book not found"));
        if (!book.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
        book.setFavorite(!book.isFavorite());
        return mapToDto(bookRepository.save(book));
    }

    // =========================================
    // Search Books (multi-field)
    // =========================================

    @Transactional(readOnly = true)
    public List<BookResponseDto> searchBooks(String query, String category, String author, String language) {
        User user = getCurrentUser();
        return bookRepository.searchBooks(user, query, category, author, language)
                .stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    // =========================================
    // Book Count
    // =========================================

    @Transactional(readOnly = true)
    public long getBookCount() {
        User user = getCurrentUser();
        return bookRepository.countByUser(user);
    }

    // =========================================
    // Get Distinct Filter Values (for dropdowns)
    // =========================================

    @Transactional(readOnly = true)
    public List<String> getDistinctCategories() {
        User user = getCurrentUser();
        return bookRepository.findDistinctCategoriesByUser(user);
    }

    @Transactional(readOnly = true)
    public List<String> getDistinctAuthors() {
        User user = getCurrentUser();
        return bookRepository.findDistinctAuthorsByUser(user);
    }

    @Transactional(readOnly = true)
    public List<String> getDistinctLanguages() {
        User user = getCurrentUser();
        return bookRepository.findDistinctLanguagesByUser(user);
    }

    // =========================================
    // DTO Mapper
    // =========================================

    private BookResponseDto mapToDto(Book book) {
        return BookResponseDto.builder()
                .id(book.getId())
                .title(book.getTitle())
                .author(book.getAuthor())
                .description(book.getDescription())
                .isbn(book.getIsbn())
                .language(book.getLanguage())
                .category(book.getCategory())
                .numberOfPages(book.getNumberOfPages())
                .fileSize(book.getFileSize())
                .fileName(book.getFileName())
                .isFavorite(book.isFavorite())
                .rating(book.getRating())
                .createdAt(book.getCreatedAt())
                .updatedAt(book.getUpdatedAt())
                .build();
    }
}
