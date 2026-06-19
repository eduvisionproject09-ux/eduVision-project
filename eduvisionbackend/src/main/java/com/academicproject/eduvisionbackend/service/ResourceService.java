package com.academicproject.eduvisionbackend.service;

import com.academicproject.eduvisionbackend.dto.ResourceResponseDto;
import com.academicproject.eduvisionbackend.entity.Note;
import com.academicproject.eduvisionbackend.entity.Resource;
import com.academicproject.eduvisionbackend.entity.User;
import com.academicproject.eduvisionbackend.repository.NoteRepository;
import com.academicproject.eduvisionbackend.repository.ResourceRepository;
import com.academicproject.eduvisionbackend.repository.UserRepository;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.time.LocalDateTime;

import java.util.List;
import java.util.UUID;
import java.util.stream.Collectors;

@Service
public class ResourceService {

    @Autowired
    private ResourceRepository resourceRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private NoteRepository noteRepository;

    private static final String UPLOAD_DIR = "uploads/";

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
    // Upload PDF/File/Image/Video
    // =========================================

    public ResourceResponseDto uploadFile(
            String title,
            String description,
            MultipartFile file,
            Resource.ResourceType type,
            Long noteId) throws IOException {

        Note note = noteRepository.findById(noteId)
                .orElseThrow(() -> new RuntimeException("Note not found"));

        String fileName = UUID.randomUUID() + "_" + file.getOriginalFilename();

        Path uploadPath = Paths.get(UPLOAD_DIR);

        Files.createDirectories(uploadPath);

        Path filePath = uploadPath.resolve(fileName);

        Files.write(filePath, file.getBytes());

        Resource resource = Resource.builder()
                .title(title)
                .description(description)
                .resourceUrl(filePath.toString())
                .type(type)
                .note(note)
                .createdAt(LocalDateTime.now())
                .build();

        return mapToDto(resourceRepository.save(resource));
    }

    // =========================================
    // Add YouTube / External Link
    // =========================================

    public ResourceResponseDto addLink(
            String title,
            String description,
            String url,
            Resource.ResourceType type,
            Long noteId) {

        Note note = noteRepository.findById(noteId)
                .orElseThrow(() -> new RuntimeException("Note not found"));

        Resource resource = Resource.builder()
                .title(title)
                .description(description)
                .resourceUrl(url)
                .type(type)
                .note(note)
                .createdAt(LocalDateTime.now())
                .build();

        return mapToDto(resourceRepository.save(resource));
    }

    // =========================================
    // Get Resources By Note
    // =========================================

    public List<ResourceResponseDto> getResourcesByNote(Long noteId) {

        Note note = noteRepository.findById(noteId)
                .orElseThrow(() -> new RuntimeException("Note not found"));

        return resourceRepository.findByNote(note)
                .stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    // =========================================
    // Delete Resource
    // =========================================

    public void deleteResource(Long resourceId) {

        Resource resource = resourceRepository.findById(resourceId)
                .orElseThrow(() -> new RuntimeException("Resource not found"));

        // Delete uploaded local file
        if (resource.getType() != Resource.ResourceType.YOUTUBE
                &&
                resource.getType() != Resource.ResourceType.LINK) {

            try {

                Files.deleteIfExists(
                        Paths.get(resource.getResourceUrl()));

            } catch (IOException e) {

                throw new RuntimeException(
                        "Failed to delete file");
            }
        }

        resourceRepository.delete(resource);
    }

    // =========================================
    // DTO Mapper
    // =========================================

    ResourceResponseDto mapToDto(Resource resource) {

        return ResourceResponseDto.builder()
                .id(resource.getId())
                .title(resource.getTitle())
                .description(resource.getDescription())
                .resourceUrl(resource.getResourceUrl())
                .type(resource.getType())
                .noteId(resource.getNote().getId())
                .createdAt(resource.getCreatedAt())
                .build();
    }
}