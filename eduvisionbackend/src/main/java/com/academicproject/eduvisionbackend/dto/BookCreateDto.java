package com.academicproject.eduvisionbackend.dto;

import lombok.*;

@Data
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class BookCreateDto {
    private String title;
    private String author;
    private String description;
    private String isbn;
    private String language;
    private String category;
    private Integer numberOfPages;
}
