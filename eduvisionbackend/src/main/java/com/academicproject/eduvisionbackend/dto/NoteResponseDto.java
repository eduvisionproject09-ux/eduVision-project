package com.academicproject.eduvisionbackend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import java.time.LocalDateTime;
import java.util.List;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class NoteResponseDto {
    private Long id;
    private String content;
    private String subject;
    private String topic;
    @JsonProperty("bookmarked")
    private boolean bookmarked;

    @JsonProperty("isFolder")
    private boolean isFolder;

    private Long parentId;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<ResourceResponseDto> resources;
}
