package com.academicproject.eduvisionbackend.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import com.academicproject.eduvisionbackend.dto.AuthResponse;
import com.academicproject.eduvisionbackend.dto.LoginRequest;
import com.academicproject.eduvisionbackend.dto.SignupRequest;
import com.academicproject.eduvisionbackend.service.AuthService;

@RestController
@RequestMapping("/api/auth")
public class AuthController {
    @Autowired
    private AuthService authService;

    @PostMapping("/signup")
    public ResponseEntity<AuthResponse> registerUser(@RequestBody SignupRequest signupRequest) {
        return ResponseEntity.ok(authService.register(signupRequest));
    }

    @PostMapping("/login")
    public ResponseEntity<AuthResponse> loginUser(@RequestBody LoginRequest loginRequest) {
        return ResponseEntity.ok(authService.login(loginRequest));
    }
}
