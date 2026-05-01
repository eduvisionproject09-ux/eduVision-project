package com.academicproject.eduvisionbackend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.academicproject.eduvisionbackend.dto.AuthResponse;
import com.academicproject.eduvisionbackend.dto.LoginRequest;
import com.academicproject.eduvisionbackend.dto.SignupRequest;
import com.academicproject.eduvisionbackend.entity.User;
import com.academicproject.eduvisionbackend.repository.UserRepository;
import com.academicproject.eduvisionbackend.security.JwtUtils;

@Service
public class AuthService {

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Autowired
    private AuthenticationManager authenticationManager;

    @Autowired
    private JwtUtils jwtUtils;

    public AuthResponse register(SignupRequest signupRequest) {
        if (userRepository.existsByUsername(signupRequest.getUsername())) {
            throw new RuntimeException("Error: Username is already taken!");
        }

        if (userRepository.existsByEmail(signupRequest.getEmail())) {
            throw new RuntimeException("Error: Email is already in use!");
        }

        User user = User.builder()
                .username(signupRequest.getUsername())
                .email(signupRequest.getEmail())
                .password(passwordEncoder.encode(signupRequest.getPassword()))
                .role("ROLE_USER")
                .build();

        userRepository.save(user);

        // Auto login after signup
        return login(new LoginRequest(signupRequest.getUsername(), signupRequest.getPassword()));
    }

    public AuthResponse login(LoginRequest loginRequest) {
        org.springframework.security.core.Authentication authentication = authenticationManager.authenticate(
                new UsernamePasswordAuthenticationToken(loginRequest.getUsername(), loginRequest.getPassword()));

        SecurityContextHolder.getContext().setAuthentication(authentication);
        UserDetails userDetails = (UserDetails) authentication.getPrincipal();
        String jwt = jwtUtils.generateToken(userDetails);

        User user = userRepository.findByUsername(userDetails.getUsername()).get();

        return AuthResponse.builder()
                .token(jwt)
                .username(user.getUsername())
                .email(user.getEmail())
                .build();
    }
}
