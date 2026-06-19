package com.academicproject.eduvisionbackend.entity;

import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "books")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor
@Builder
public class Book {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    @Column
    private String author;

    @Column(columnDefinition = "TEXT")
    private String description;

    @Column
    private String isbn;

    @Column
    private String language;

    @Column
    private String category;

    @Column
    private Integer numberOfPages;

    // Physical file storage path on server
    @Column(nullable = false, columnDefinition = "TEXT")
    private String filePath;

    @Column
    private Long fileSize;

    @Column
    private String fileName;

    @Column(name = "is_favorite", nullable = false)
    @Builder.Default
    private boolean isFavorite = false;

    @Column
    @Builder.Default
    private Integer rating = 0;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "user_id")
    private User user;

    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }
}
