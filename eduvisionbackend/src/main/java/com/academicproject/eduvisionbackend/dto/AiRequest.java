package com.academicproject.eduvisionbackend.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class AiRequest {
    private String prompt;
    private String style;
    private String language;
}
