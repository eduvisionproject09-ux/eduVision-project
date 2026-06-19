package com.academicproject.eduvisionbackend.dto;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookResponseDto {
    private Long id;
    private String title;
    private String author;
    private String description;
    private String isbn;
    private String language;
    private String category;
    private Integer numberOfPages;
    private Long fileSize;
    private String fileName;

    @JsonProperty("isFavorite")
    private boolean isFavorite;

    private Integer rating;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
