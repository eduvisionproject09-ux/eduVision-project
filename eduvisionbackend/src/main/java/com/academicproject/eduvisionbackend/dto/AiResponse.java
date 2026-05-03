package com.academicproject.eduvisionbackend.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class AiResponse {
    private String academicDefinition;
    private String simpleDefinition;
    private String examStandardDescription;
}
