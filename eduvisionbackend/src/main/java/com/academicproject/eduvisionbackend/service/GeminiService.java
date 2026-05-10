package com.academicproject.eduvisionbackend.service;

import com.academicproject.eduvisionbackend.dto.AiResponse;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class GeminiService {

    @Value("${gemini.api.key}")
    private String apiKey;

    private final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-1.5-flash:generateContent?key=";

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public AiResponse getStructuredResponse(String prompt) {
        String url = API_URL + apiKey;

        String systemPrompt = "You are an AI academic assistant for students. " +
                "For any concept provided, you must return a JSON object with exactly four fields: " +
                "\"topic\" (the name of the concept), " +
                "\"academicDefinition\" (a formal, high-level academic definition), " +
                "\"simpleDefinition\" (a definition in very simple terms for easy understanding), " +
                "\"examStandardDescription\" (a detailed explanation suitable for writing in an exam). " +
                "Respond ONLY with the JSON object. Do not include markdown formatting like ```json or any other text.";

        Map<String, Object> requestBody = new HashMap<>();
        Map<String, Object> content = new HashMap<>();
        Map<String, String> part = new HashMap<>();
        part.put("text", systemPrompt + "\n\nConcept: " + prompt);
        content.put("parts", List.of(part));
        requestBody.put("contents", List.of(content));

        try {
            String responseStr = restTemplate.postForObject(url, requestBody, String.class);
            JsonNode root = objectMapper.readTree(responseStr);
            String textResponse = root.path("candidates").get(0).path("content").path("parts").get(0).path("text").asText();
            
            // Robust cleanup to extract JSON even if Gemini adds conversational text
            int start = textResponse.indexOf("{");
            int end = textResponse.lastIndexOf("}");
            if (start != -1 && end != -1 && end > start) {
                textResponse = textResponse.substring(start, end + 1);
            }
            
            return objectMapper.readValue(textResponse, AiResponse.class);
        } catch (Exception e) {
            System.err.println("Error calling Gemini API: " + e.getMessage());
            return AiResponse.builder()
                    .topic(prompt)
                    .academicDefinition("Error retrieving definition.")
                    .simpleDefinition("Something went wrong with the AI service.")
                    .examStandardDescription("Details: " + e.getMessage())
                    .build();
        }
    }
}
