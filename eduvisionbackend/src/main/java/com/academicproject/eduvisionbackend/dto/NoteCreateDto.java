package com.academicproject.eduvisionbackend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
public class NoteCreateDto {
    private String content;
    private String subject;
    private String topic;
    @JsonProperty("isFolder")
    private boolean isFolder;
    private Long parentId;
}
