package com.academicproject.eduvisionbackend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.stream.Collectors;

import com.academicproject.eduvisionbackend.dto.NoteCreateDto;
import com.academicproject.eduvisionbackend.dto.NoteResponseDto;
import com.academicproject.eduvisionbackend.dto.ResourceResponseDto;
import com.academicproject.eduvisionbackend.entity.Note;
import com.academicproject.eduvisionbackend.entity.Resource;
import com.academicproject.eduvisionbackend.entity.User;
import com.academicproject.eduvisionbackend.repository.NoteRepository;
import com.academicproject.eduvisionbackend.repository.UserRepository;

@Service
public class NoteService {

    @Autowired
    private NoteRepository noteRepository;

    @Autowired
    private UserRepository userRepository;

    @Autowired
    private ResourceService resourceService;

    private User getCurrentUser() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return userRepository.findByUsername(userDetails.getUsername()).orElseThrow();
    }

    @Transactional
    public NoteResponseDto createNote(NoteCreateDto dto) {
        User user = getCurrentUser();
        Note note = Note.builder()                 
                .content(dto.getContent())
                .subject(dto.getSubject())
                .topic(dto.getTopic())
                .isFolder(dto.isFolder())
                .parentId(dto.getParentId())
                .user(user)
                .build();
        Note saved = noteRepository.save(note);
        return mapToDto(saved);
    }

    @Transactional(readOnly = true)
    public List<NoteResponseDto> getAllNotesList() {
        User user = getCurrentUser();
        return noteRepository.findByUser(user).stream()
                .map(this::mapToDto)
                .collect(Collectors.toList());
    }

    @Transactional(readOnly = true)
    public Page<NoteResponseDto> getAllNotes(Pageable pageable) {
        User user = getCurrentUser();
        return noteRepository.findByUser(user, pageable).map(this::mapToDto);
    }

    @Transactional(readOnly = true)
    public NoteResponseDto getNoteById(Long id) {
        Note note = noteRepository.findById(id).orElseThrow();
        // Check if note belongs to user
        if (!note.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
        return mapToDto(note);
    }

    @Transactional
    public NoteResponseDto updateNote(Long id, NoteCreateDto dto) {
        Note note = noteRepository.findById(id).orElseThrow();
        if (!note.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
        // Only update mutable fields (content, subject, topic)
        note.setContent(dto.getContent());
        note.setSubject(dto.getSubject());
        note.setTopic(dto.getTopic());
        
        return mapToDto(noteRepository.save(note));
    }

    public void deleteNote(Long id) {
        Note note = noteRepository.findById(id).orElseThrow();
        if (!note.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
        noteRepository.delete(note);
    }

    @Transactional
    public NoteResponseDto toggleBookmark(Long id) {
        Note note = noteRepository.findById(id).orElseThrow();
        if (!note.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
        note.setBookmarked(!note.isBookmarked());
        return mapToDto(noteRepository.save(note));
    }

    public NoteResponseDto mapToDto(Note note) {
        List<ResourceResponseDto> resourceDtos = null;
        if (note.getResources() != null) {
            resourceDtos = note.getResources().stream()
                    .map(resource -> resourceService.mapToDto(resource))
                    .collect(Collectors.toList());
        }

        return NoteResponseDto.builder()
                .id(note.getId())
                .content(note.getContent())
                .subject(note.getSubject())
                .topic(note.getTopic())
                .bookmarked(note.isBookmarked())
                .isFolder(note.isFolder())
                .parentId(note.getParentId())
                .createdAt(note.getCreatedAt())
                .updatedAt(note.getUpdatedAt())
                .resources(resourceDtos)
                .build();
    }
}
