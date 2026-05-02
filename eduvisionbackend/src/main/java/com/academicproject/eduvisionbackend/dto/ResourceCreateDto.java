package com.academicproject.eduvisionbackend.dto;

import com.academicproject.eduvisionbackend.entity.Resource.ResourceType;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class ResourceCreateDto {

    private String title;

    private String resourceUrl;

    private ResourceType type;

    private String description;

    private Long noteId;
}