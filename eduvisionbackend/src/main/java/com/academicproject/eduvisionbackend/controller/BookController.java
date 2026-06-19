package com.academicproject.eduvisionbackend.controller;

import com.academicproject.eduvisionbackend.dto.BookCreateDto;
import com.academicproject.eduvisionbackend.dto.BookResponseDto;
import com.academicproject.eduvisionbackend.entity.Book;
import com.academicproject.eduvisionbackend.service.BookService;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.core.io.ByteArrayResource;
import org.springframework.core.io.Resource;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.client.RestTemplate;
import org.springframework.web.bind.annotation.*;
import org.springframework.http.HttpEntity;
import org.springframework.http.HttpMethod;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/api/books")
public class BookController {

    private static final Logger logger = LoggerFactory.getLogger(BookController.class);

    @Autowired
    private BookService bookService;

    @Value("${supabase.url}")
    private String supabaseUrl;

    @Value("${supabase.key}")
    private String supabaseKey;

    @Value("${supabase.bucket}")
    private String supabaseBucket;

    private final RestTemplate restTemplate = new RestTemplate();

    // =========================================
    // Upload a new book (file + metadata)
    // =========================================

    @PostMapping("/upload")
    public ResponseEntity<BookResponseDto> uploadBook(
            @RequestParam("file") MultipartFile file,
            @RequestParam("title") String title,
            @RequestParam(value = "author", required = false) String author,
            @RequestParam(value = "description", required = false) String description,
            @RequestParam(value = "isbn", required = false) String isbn,
            @RequestParam(value = "language", required = false) String language,
            @RequestParam(value = "category", required = false) String category,
            @RequestParam(value = "numberOfPages", required = false) Integer numberOfPages) throws IOException {

        return ResponseEntity.ok(bookService.uploadBook(
                file, title, author, description, isbn, language, category, numberOfPages));
    }

    // =========================================
    // Get all books (paginated)
    // =========================================

    @GetMapping
    public ResponseEntity<Page<BookResponseDto>> getAllBooks(Pageable pageable) {
        return ResponseEntity.ok(bookService.getAllBooks(pageable));
    }

    // =========================================
    // Get all books (full list)
    // =========================================

    @GetMapping("/all")
    public ResponseEntity<List<BookResponseDto>> getAllBooksList() {
        return ResponseEntity.ok(bookService.getAllBooksList());
    }

    // =========================================
    // Get book by ID
    // =========================================

    @GetMapping("/{id}")
    public ResponseEntity<BookResponseDto> getBookById(@PathVariable Long id) {
        return ResponseEntity.ok(bookService.getBookById(id));
    }

    // =========================================
    // Serve the actual book file for download/reading
    // =========================================

    @GetMapping("/files/{id}")
    public ResponseEntity<Resource> getBookFile(
            @PathVariable Long id,
            @RequestParam(required = false, defaultValue = "false") boolean download) throws IOException {
        logger.info("[book download] Request received for book ID: {}, download param: {}", id, download);
        try {
            Book book = bookService.getBookEntityById(id);
            logger.info("[book download] Found book record in DB: '{}' by author '{}'. DB File storage path: '{}'", 
                    book.getTitle(), book.getAuthor(), book.getFilePath());

            String sanitizedFilePath = book.getFilePath().replace("\\", "/");
            logger.info("[book download] Sanitized file path: '{}'", sanitizedFilePath);

            byte[] fileBytes = null;
            String contentType = null;

            // 1. Try reading the file locally first (e.g. for legacy records matching the local uploads dir)
            Path localPath = Paths.get(sanitizedFilePath);
            logger.info("[book download] Checking local filesystem path: '{}'", localPath.toAbsolutePath());
            
            if (Files.exists(localPath) && !Files.isDirectory(localPath)) {
                logger.info("[book download] File found locally! Attempting to stream from disk: '{}'", localPath.toAbsolutePath());
                try {
                    fileBytes = Files.readAllBytes(localPath);
                    contentType = Files.probeContentType(localPath);
                    logger.info("[book download] Successfully read {} bytes from local file. Content-Type: {}", 
                            fileBytes.length, contentType);
                } catch (Exception e) {
                    logger.error("[book download] Failed to read file from local filesystem: {}", e.getMessage(), e);
                }
            } else {
                logger.info("[book download] File does not exist locally or is a directory: '{}'", localPath.toAbsolutePath());
            }

            // 2. If not found locally, fetch it from Supabase Storage
            if (fileBytes == null) {
                String downloadUrl = supabaseUrl + "/storage/v1/object/" + supabaseBucket + "/" + sanitizedFilePath;
                logger.info("[book download] Fetching from Supabase Storage URL: {}", downloadUrl);

                HttpHeaders headers = new HttpHeaders();
                headers.set("Authorization", "Bearer " + supabaseKey);
                headers.set("apiKey", supabaseKey);
                
                HttpEntity<Void> entity = new HttpEntity<>(headers);
                
                try {
                    ResponseEntity<byte[]> response = restTemplate.exchange(downloadUrl, HttpMethod.GET, entity, byte[].class);
                    fileBytes = response.getBody();
                    if (fileBytes != null) {
                        contentType = response.getHeaders().getFirst(HttpHeaders.CONTENT_TYPE);
                        logger.info("[book download] File successfully retrieved from Supabase Storage. Size: {} bytes, Content-Type: {}", 
                                fileBytes.length, contentType);
                    } else {
                        logger.warn("[book download] Received empty body (null bytes) from Supabase Storage");
                    }
                } catch (Exception e) {
                    logger.error("[book download] Error downloading from Supabase Storage: {}", e.getMessage());
                }
            }

            // 3. Serve the file if bytes were retrieved
            if (fileBytes == null) {
                logger.error("[book download] Failed to resolve file bytes from either local storage or Supabase. Returning 404.");
                return ResponseEntity.notFound().build();
            }

            ByteArrayResource resource = new ByteArrayResource(fileBytes);

            if (contentType == null) {
                contentType = "application/pdf";
                logger.info("[book download] Content-Type was null, defaulted to application/pdf");
            }

            String dispositionType = download ? "attachment" : "inline";
            logger.info("[book download] Returning file. Content-Disposition: {}, filename: '{}', Content-Type: {}, Size: {} bytes", 
                    dispositionType, book.getFileName(), contentType, fileBytes.length);

            return ResponseEntity.ok()
                    .contentType(MediaType.parseMediaType(contentType))
                    .header(HttpHeaders.CONTENT_DISPOSITION, dispositionType + "; filename=\"" + book.getFileName() + "\"")
                    .contentLength(fileBytes.length)
                    .body(resource);
        } catch (Exception e) {
            logger.error("[book download] Error serving file for book ID: {}. Exception: ", id, e);
            throw e;
        }
    }

    // =========================================
    // Update book metadata
    // =========================================

    @PutMapping("/{id}")
    public ResponseEntity<BookResponseDto> updateBook(
            @PathVariable Long id,
            @RequestBody BookCreateDto dto) {
        return ResponseEntity.ok(bookService.updateBook(id, dto));
    }

    // =========================================
    // Delete book (+ file on disk)
    // =========================================

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteBook(@PathVariable Long id) {
        bookService.deleteBook(id);
        return ResponseEntity.noContent().build();
    }

    // =========================================
    // Toggle favorite
    // =========================================

    @PatchMapping("/{id}/favorite")
    public ResponseEntity<BookResponseDto> toggleFavorite(@PathVariable Long id) {
        return ResponseEntity.ok(bookService.toggleFavorite(id));
    }

    // =========================================
    // Search books (multi-field)
    // =========================================

    @GetMapping("/search")
    public ResponseEntity<List<BookResponseDto>> searchBooks(
            @RequestParam(required = false) String query,
            @RequestParam(required = false) String category,
            @RequestParam(required = false) String author,
            @RequestParam(required = false) String language) {
        return ResponseEntity.ok(bookService.searchBooks(query, category, author, language));
    }

    // =========================================
    // Book count
    // =========================================

    @GetMapping("/count")
    public ResponseEntity<Map<String, Long>> getBookCount() {
        return ResponseEntity.ok(Map.of("count", bookService.getBookCount()));
    }

    // =========================================
    // Distinct filter values (for sidebar dropdowns)
    // =========================================

    @GetMapping("/filters/categories")
    public ResponseEntity<List<String>> getCategories() {
        return ResponseEntity.ok(bookService.getDistinctCategories());
    }

    @GetMapping("/filters/authors")
    public ResponseEntity<List<String>> getAuthors() {
        return ResponseEntity.ok(bookService.getDistinctAuthors());
    }

    @GetMapping("/filters/languages")
    public ResponseEntity<List<String>> getLanguages() {
        return ResponseEntity.ok(bookService.getDistinctLanguages());
    }
}
