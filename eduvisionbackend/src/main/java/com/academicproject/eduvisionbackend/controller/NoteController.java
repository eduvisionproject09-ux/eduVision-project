package com.academicproject.eduvisionbackend.controller;

import com.academicproject.eduvisionbackend.dto.NoteCreateDto;
import com.academicproject.eduvisionbackend.dto.NoteResponseDto;
import com.academicproject.eduvisionbackend.service.NoteService;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/api/notes")
public class NoteController {

    @Autowired
    private NoteService noteService;

    @PostMapping
    public ResponseEntity<NoteResponseDto> createNote(@RequestBody NoteCreateDto dto) {
        return ResponseEntity.ok(noteService.createNote(dto));
    }

    @GetMapping
    public ResponseEntity<Page<NoteResponseDto>> getAllNotes(Pageable pageable) {
        return ResponseEntity.ok(noteService.getAllNotes(pageable));
    }

    @GetMapping("/all")
    public ResponseEntity<List<NoteResponseDto>> getAllNotesList() {
        return ResponseEntity.ok(noteService.getAllNotesList());
    }

    @GetMapping("/{id}")
    public ResponseEntity<NoteResponseDto> getNoteById(@PathVariable Long id) {
        return ResponseEntity.ok(noteService.getNoteById(id));
    }

    @PutMapping("/{id}")
    public ResponseEntity<NoteResponseDto> updateNote(@PathVariable Long id, @RequestBody NoteCreateDto dto) {
        return ResponseEntity.ok(noteService.updateNote(id, dto));
    }

    @DeleteMapping("/{id}")
    public ResponseEntity<Void> deleteNote(@PathVariable Long id) {
        noteService.deleteNote(id);
        return ResponseEntity.noContent().build();
    }

    @PatchMapping("/{id}/bookmark")
    public ResponseEntity<NoteResponseDto> toggleBookmark(@PathVariable Long id) {
        return ResponseEntity.ok(noteService.toggleBookmark(id));
    }
}
