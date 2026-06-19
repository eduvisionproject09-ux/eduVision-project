package com.academicproject.eduvisionbackend.service;

import java.time.LocalDate;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.academicproject.eduvisionbackend.dto.EventCreateDto;
import com.academicproject.eduvisionbackend.dto.EventResponseDto;
import com.academicproject.eduvisionbackend.entity.Event;
import com.academicproject.eduvisionbackend.entity.User;
import com.academicproject.eduvisionbackend.repository.EventRepository;
import com.academicproject.eduvisionbackend.repository.UserRepository;

@Service
public class EventService {

    @Autowired
    private EventRepository eventRepository;

    @Autowired
    private UserRepository userRepository;

    private User getCurrentUser() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return userRepository.findByUsername(userDetails.getUsername()).orElseThrow();
    }

    @Transactional
    public EventResponseDto createEvent(EventCreateDto dto) {
        User user = getCurrentUser();
        Event event = Event.builder()
                .title(dto.getTitle())
                .description(dto.getDescription())
                .eventDate(dto.getEventDate())
                .startTime(dto.getStartTime())
                .endTime(dto.getEndTime())
                .location(dto.getLocation())
                .type(dto.getType())
                .user(user)
                .build();
        Event saved = eventRepository.save(event);
        return mapToDto(saved);
    }

    @Transactional(readOnly = true)
    public List<EventResponseDto> getAllEvents() {
        User user = getCurrentUser();
        return eventRepository.findByUserOrderByEventDateAsc(user).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<EventResponseDto> getUpcomingEvents() {
        User user = getCurrentUser();
        return eventRepository.findByUserAndEventDateGreaterThanEqualOrderByEventDateAsc(user, LocalDate.now())
                .stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<EventResponseDto> getTodayEvents() {
        User user = getCurrentUser();
        return eventRepository.findByUserAndEventDateOrderByStartTimeAsc(user, LocalDate.now())
                .stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public List<EventResponseDto> getPastEvents() {
        User user = getCurrentUser();
        return eventRepository.findByUserAndEventDateBeforeOrderByEventDateDesc(user, LocalDate.now())
                .stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public EventResponseDto getEventById(Long id) {
        Event event = eventRepository.findById(id).orElseThrow();
        if (!event.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
        return mapToDto(event);
    }

    @Transactional
    public EventResponseDto updateEvent(Long id, EventCreateDto dto) {
        Event event = eventRepository.findById(id).orElseThrow();
        if (!event.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
        event.setTitle(dto.getTitle());
        event.setDescription(dto.getDescription());
        event.setEventDate(dto.getEventDate());
        event.setStartTime(dto.getStartTime());
        event.setEndTime(dto.getEndTime());
        event.setLocation(dto.getLocation());
        event.setType(dto.getType());
        return mapToDto(eventRepository.save(event));
    }

    @Transactional
    public void deleteEvent(Long id) {
        Event event = eventRepository.findById(id).orElseThrow();
        if (!event.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
        eventRepository.delete(event);
    }

    public EventResponseDto mapToDto(Event event) {
        return EventResponseDto.builder()
                .id(event.getId())
                .title(event.getTitle())
                .description(event.getDescription())
                .eventDate(event.getEventDate())
                .startTime(event.getStartTime())
                .endTime(event.getEndTime())
                .location(event.getLocation())
                .type(event.getType())
                .createdAt(event.getCreatedAt())
                .updatedAt(event.getUpdatedAt())
                .build();
    }
}
