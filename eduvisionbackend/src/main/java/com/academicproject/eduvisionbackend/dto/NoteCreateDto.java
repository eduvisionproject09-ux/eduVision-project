package com.academicproject.eduvisionbackend.dto;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NoteCreateDto {
    private String content;
    private String subject;
    private String topic;
}
