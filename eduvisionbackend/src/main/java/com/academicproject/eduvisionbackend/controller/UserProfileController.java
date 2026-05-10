package com.academicproject.eduvisionbackend.controller;

import com.academicproject.eduvisionbackend.dto.ProfileDto;
import com.academicproject.eduvisionbackend.service.UserProfileService;
import lombok.RequiredArgsConstructor;
import org.springframework.core.io.Resource;
import org.springframework.core.io.UrlResource;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.net.MalformedURLException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.Collections;
import java.util.Map;

@RestController
@RequestMapping("/api/profile")
@RequiredArgsConstructor
public class UserProfileController {

    private final UserProfileService userProfileService;

    @GetMapping
    public ResponseEntity<ProfileDto> getProfile(Authentication authentication) {
        String username = authentication.getName();
        return ResponseEntity.ok(userProfileService.getProfile(username));
    }

    @PutMapping
    public ResponseEntity<ProfileDto> updateProfile(Authentication authentication, @RequestBody ProfileDto profileDto) {
        String username = authentication.getName();
        return ResponseEntity.ok(userProfileService.updateProfile(username, profileDto));
    }

    @PostMapping("/upload-image")
    public ResponseEntity<Map<String, String>> uploadProfileImage(Authentication authentication, @RequestParam("file") MultipartFile file) {
        String username = authentication.getName();
        String fileUrl = userProfileService.uploadProfileImage(username, file);
        return ResponseEntity.ok(Collections.singletonMap("fileUrl", fileUrl));
    }

    @GetMapping("/images/{filename:.+}")
    public ResponseEntity<Resource> serveFile(@PathVariable String filename) {
        try {
            Path file = Paths.get("uploads").resolve(filename);
            Resource resource = new UrlResource(file.toUri());

            if (resource.exists() || resource.isReadable()) {
                return ResponseEntity.ok()
                        .header(HttpHeaders.CONTENT_DISPOSITION, "inline; filename=\"" + resource.getFilename() + "\"")
                        .contentType(MediaType.IMAGE_JPEG) // You might want to dynamically determine the content type
                        .body(resource);
            } else {
                return ResponseEntity.notFound().build();
            }
        } catch (MalformedURLException e) {
            return ResponseEntity.badRequest().build();
        }
    }
}
