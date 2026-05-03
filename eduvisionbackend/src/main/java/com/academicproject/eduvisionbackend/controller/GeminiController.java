package com.academicproject.eduvisionbackend.controller;

import com.academicproject.eduvisionbackend.dto.AiRequest;
import com.academicproject.eduvisionbackend.dto.AiResponse;
import com.academicproject.eduvisionbackend.service.GeminiService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/ai")
@RequiredArgsConstructor
@CrossOrigin(origins = "*")
public class GeminiController {

    private final GeminiService geminiService;

    @PostMapping("/ask")
    public ResponseEntity<AiResponse> askAi(@RequestBody AiRequest request) {
        return ResponseEntity.ok(geminiService.getStructuredResponse(request.getPrompt()));
    }
}
