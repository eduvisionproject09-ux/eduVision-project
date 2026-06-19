package com.academicproject.eduvisionbackend.dto;

import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;

import com.academicproject.eduvisionbackend.entity.Event.EventType;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class EventResponseDto {
    private Long id;
    private String title;
    private String description;
    private LocalDate eventDate;
    private LocalTime startTime;
    private LocalTime endTime;
    private String location;
    private EventType type;
    private LocalDateTime createdAt;
    private LocalDateTime updatedAt;
}
