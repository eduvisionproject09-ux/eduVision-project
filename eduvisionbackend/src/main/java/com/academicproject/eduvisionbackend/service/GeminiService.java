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

    private final String API_URL = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent?key=";

    private final RestTemplate restTemplate = new RestTemplate();
    private final ObjectMapper objectMapper = new ObjectMapper();

    public AiResponse getStructuredResponse(String prompt, String style, String language) {
        String url = API_URL + apiKey;

        String styleInstruction = buildStyleInstruction(style);
        String languageInstruction = (language != null && !language.isEmpty() && !language.equalsIgnoreCase("English"))
            ? "The response must be written entirely in " + language + ". " 
            : "";

        String systemPrompt = "You are an AI academic assistant for students. " +
                styleInstruction + languageInstruction +
                "Respond ONLY with a valid JSON object. Do not include markdown formatting like ```json or any other text.";

        Map<String, Object> requestBody = new HashMap<>();
        Map<String, Object> content = new HashMap<>();
        Map<String, String> part = new HashMap<>();
        part.put("text", systemPrompt + "\n\nQuery: " + prompt);
        content.put("parts", List.of(part));
        requestBody.put("contents", List.of(content));

        try {
            String responseStr = restTemplate.postForObject(url, requestBody, String.class);
            JsonNode root = objectMapper.readTree(responseStr);

            JsonNode candidates = root.path("candidates");
            if (candidates.isMissingNode() || !candidates.isArray() || candidates.isEmpty()) {
                JsonNode promptFeedback = root.path("promptFeedback");
                String blockReason = promptFeedback.path("blockReason").asText("Unknown");
                System.err.println("Gemini API blocked or empty response. Reason: " + blockReason);
                return AiResponse.builder()
                        .topic(prompt)
                        .content("I'm sorry, I couldn't process that request. (" + blockReason + ")")
                        .build();
            }

            JsonNode firstCandidate = candidates.get(0);
            JsonNode finishReason = firstCandidate.path("finishReason");
            if (!finishReason.isMissingNode() && !"STOP".equals(finishReason.asText())) {
                System.err.println("Gemini API finish reason: " + finishReason.asText());
            }

            String textResponse = firstCandidate
                    .path("content").path("parts").get(0).path("text").asText("");

            if (textResponse.isEmpty()) {
                return AiResponse.builder()
                        .topic(prompt)
                        .content("I received an empty response. Please try rephrasing your question.")
                        .build();
            }

            int start = textResponse.indexOf("{");
            int end = textResponse.lastIndexOf("}");
            if (start != -1 && end != -1 && end > start) {
                textResponse = textResponse.substring(start, end + 1);
            }

            try {
                return objectMapper.readValue(textResponse, AiResponse.class);
            } catch (Exception jsonEx) {
                System.err.println("JSON parse error, falling back to plain text: " + jsonEx.getMessage());
                String cleaned = textResponse.replaceAll("[{}\"]", "").trim();
                return AiResponse.builder()
                        .topic(prompt)
                        .content(cleaned.length() > 20 ? cleaned : textResponse)
                        .build();
            }
        } catch (Exception e) {
            System.err.println("Error calling Gemini API: " + e.getMessage());
            String errorMsg = e.getMessage();
            if (errorMsg != null && errorMsg.contains("401")) {
                return AiResponse.builder()
                        .topic("API Error")
                        .content("AI service authentication failed. Please check the API key configuration.")
                        .build();
            } else if (errorMsg != null && errorMsg.contains("429")) {
                return AiResponse.builder()
                        .topic("Rate Limit")
                        .content("Too many requests. Please wait a moment and try again.")
                        .build();
            }
            return AiResponse.builder()
                    .topic(prompt)
                    .content("Sorry, I encountered an error. Please try again in a moment.")
                    .build();
        }
    }

    private String buildStyleInstruction(String style) {
        if (style == null || style.isEmpty()) style = "Academic";

        return switch (style.toLowerCase()) {
            case "short answer" ->
                "Provide a very concise, direct answer. " +
                "Return JSON with exactly: \"topic\" (brief title) and \"content\" (2-3 sentence concise answer). ";
            case "exam standard" ->
                "Provide a detailed, exam-ready answer. " +
                "Return JSON with exactly: \"topic\", \"content\" (full exam-quality explanation), " +
                "\"examStandardDescription\" (key points to remember for exams). ";
            case "academic" ->
                "Provide a formal academic explanation. " +
                "Return JSON with exactly: \"topic\", \"content\" (comprehensive academic explanation), " +
                "\"academicDefinition\" (formal definition), " +
                "\"simpleDefinition\" (simplified explanation for beginners), " +
                "\"examStandardDescription\" (exam-focused summary). ";
            case "technical" ->
                "Provide a technical, detailed explanation with precise terminology. " +
                "Return JSON with exactly: \"topic\" and \"content\" (technical explanation with specifications, " +
                "mechanisms, and precise terminology). ";
            case "simple word" ->
                "Explain in the simplest possible words. Use analogies and everyday language. " +
                "Return JSON with exactly: \"topic\" and \"content\" (very simple explanation using basic vocabulary). ";
            case "creative" ->
                "Provide a creative, engaging, and thought-provoking response. Use examples, stories, or analogies. " +
                "Return JSON with exactly: \"topic\" and \"content\" (creative explanation). ";
            case "brainstorming" ->
                "Generate creative ideas, possibilities, and open-ended suggestions. " +
                "Return JSON with exactly: \"topic\" and \"content\" (brainstormed ideas in bullet points or paragraphs). ";
            case "chat" ->
                "Have a friendly, helpful conversation with the student. Respond naturally and conversationally. " +
                "Return JSON with exactly: \"topic\" (short subject) and \"content\" (conversational response). ";
            default ->
                "Provide a balanced, clear explanation suitable for students. " +
                "Return JSON with exactly: \"topic\", \"content\" (main explanation), " +
                "\"academicDefinition\" (formal definition), " +
                "\"simpleDefinition\" (simplified version), " +
                "\"examStandardDescription\" (exam-focused summary). ";
        };
    }
}
