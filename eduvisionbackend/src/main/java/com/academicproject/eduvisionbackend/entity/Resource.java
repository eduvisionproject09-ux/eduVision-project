package com.academicproject.eduvisionbackend.entity;

import java.time.LocalDateTime;

import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "resources")
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class Resource {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Long id;

    @Column(nullable = false)
    private String title;

    // YouTube URL / File Path / CDN URL
    @Column(nullable = false, columnDefinition = "TEXT")
    private String resourceUrl;

    @Enumerated(EnumType.STRING)
    @Column(nullable = false)
    private ResourceType type;

    private String description;

    private LocalDateTime createdAt;

    private LocalDateTime updatedAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "note_id", nullable = false)
    private Note note;

    @PrePersist
    protected void onCreate() {
        createdAt = LocalDateTime.now();
        updatedAt = LocalDateTime.now();
    }

    @PreUpdate
    protected void onUpdate() {
        updatedAt = LocalDateTime.now();
    }

    public enum ResourceType {
        YOUTUBE,
        PDF,
        IMAGE,
        VIDEO,
        FILE,
        LINK
    }
}