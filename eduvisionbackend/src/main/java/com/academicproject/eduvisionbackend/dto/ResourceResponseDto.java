package com.academicproject.eduvisionbackend.dto;

import java.time.LocalDateTime;
import com.academicproject.eduvisionbackend.entity.Resource.ResourceType;
import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ResourceResponseDto {

    private Long id;

    private String title;

    private String resourceUrl;

    private ResourceType type;

    private String description;

    private LocalDateTime createdAt;

    private Long noteId;
}
