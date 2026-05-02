package com.academicproject.eduvisionbackend.controller;

import java.io.IOException;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import com.academicproject.eduvisionbackend.dto.ResourceResponseDto;
import com.academicproject.eduvisionbackend.entity.Resource;
import com.academicproject.eduvisionbackend.service.ResourceService;

@RestController
@RequestMapping("/api/resources")
public class ResourceController {

    @Autowired
    private ResourceService resourceService;

    @PostMapping("/link")
    public ResponseEntity<ResourceResponseDto> addLink(
            @RequestParam String title,
            @RequestParam(required = false) String description,
            @RequestParam String url,
            @RequestParam Resource.ResourceType type,
            @RequestParam Long noteId) {
        return ResponseEntity.ok(resourceService.addLink(title, description, url, type, noteId));
    }

    @PostMapping("/upload")
    public ResponseEntity<ResourceResponseDto> uploadFile(
            @RequestParam String title,
            @RequestParam(required = false) String description,
            @RequestParam MultipartFile file,
            @RequestParam Resource.ResourceType type,
            @RequestParam Long noteId) throws IOException {
        return ResponseEntity.ok(resourceService.uploadFile(title, description, file, type, noteId));
    }

    @GetMapping("/note/{noteId}")
    public ResponseEntity<List<ResourceResponseDto>> getResourcesByNote(@PathVariable Long noteId) {
        return ResponseEntity.ok(resourceService.getResourcesByNote(noteId));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteResource(@PathVariable Long id) {
        resourceService.deleteResource(id);
        return ResponseEntity.noContent().build();
    }
}
