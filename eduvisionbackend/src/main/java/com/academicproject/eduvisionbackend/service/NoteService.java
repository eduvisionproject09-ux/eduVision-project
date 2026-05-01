package com.academicproject.eduvisionbackend.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

import com.academicproject.eduvisionbackend.dto.NoteCreateDto;
import com.academicproject.eduvisionbackend.dto.NoteResponseDto;
import com.academicproject.eduvisionbackend.entity.Note;
import com.academicproject.eduvisionbackend.entity.User;
import com.academicproject.eduvisionbackend.repository.NoteRepository;
import com.academicproject.eduvisionbackend.repository.UserRepository;

@Service
public class NoteService {

    @Autowired
    private NoteRepository noteRepository;

    @Autowired
    private UserRepository userRepository;

    private User getCurrentUser() {
        UserDetails userDetails = (UserDetails) SecurityContextHolder.getContext().getAuthentication().getPrincipal();
        return userRepository.findByUsername(userDetails.getUsername()).orElseThrow();
    }

    public NoteResponseDto createNote(NoteCreateDto dto) {
        User user = getCurrentUser();
        Note note = Note.builder()
                .content(dto.getContent())
                .subject(dto.getSubject())
                .topic(dto.getTopic())
                .user(user)
                .build();
        Note saved = noteRepository.save(note);
        return mapToDto(saved);
    }

    public Page<NoteResponseDto> getAllNotes(Pageable pageable) {
        User user = getCurrentUser();
        return noteRepository.findByUser(user, pageable).map(this::mapToDto);
    }

    public NoteResponseDto getNoteById(Long id) {
        Note note = noteRepository.findById(id).orElseThrow();
        // Check if note belongs to user
        if (!note.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
        return mapToDto(note);
    }

    public NoteResponseDto updateNote(Long id, NoteCreateDto dto) {
        Note note = noteRepository.findById(id).orElseThrow();
        if (!note.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
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

    public NoteResponseDto toggleBookmark(Long id) {
        Note note = noteRepository.findById(id).orElseThrow();
        if (!note.getUser().getId().equals(getCurrentUser().getId())) {
            throw new RuntimeException("Unauthorized");
        }
        note.setBookmarked(!note.isBookmarked());
        return mapToDto(noteRepository.save(note));
    }

    private NoteResponseDto mapToDto(Note note) {
        return NoteResponseDto.builder()
                .id(note.getId())
                .content(note.getContent())
                .subject(note.getSubject())
                .topic(note.getTopic())
                .bookmarked(note.isBookmarked())
                .createdAt(note.getCreatedAt())
                .updatedAt(note.getUpdatedAt())
                .build();
    }
}
