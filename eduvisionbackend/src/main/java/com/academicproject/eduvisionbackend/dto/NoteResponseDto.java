package com.academicproject.eduvisionbackend.dto;

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
    private boolean bookmarked;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
    private List<ResourceResponseDto> resources;
}
