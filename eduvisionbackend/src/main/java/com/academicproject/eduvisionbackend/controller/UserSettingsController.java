package com.academicproject.eduvisionbackend.controller;

import com.academicproject.eduvisionbackend.dto.UserSettingsDto;
import com.academicproject.eduvisionbackend.service.UserSettingsService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.Authentication;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/settings")
@RequiredArgsConstructor
public class UserSettingsController {

    private final UserSettingsService userSettingsService;

    @GetMapping
    public ResponseEntity<UserSettingsDto> getSettings(Authentication authentication) {
        String username = authentication.getName();
        return ResponseEntity.ok(userSettingsService.getSettings(username));
    }

    @PutMapping
    public ResponseEntity<UserSettingsDto> updateSettings(Authentication authentication, @RequestBody UserSettingsDto dto) {
        String username = authentication.getName();
        return ResponseEntity.ok(userSettingsService.updateSettings(username, dto));
    }
}
