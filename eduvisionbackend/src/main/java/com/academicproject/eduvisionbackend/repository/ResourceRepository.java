package com.academicproject.eduvisionbackend.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;

import com.academicproject.eduvisionbackend.entity.Note;
import com.academicproject.eduvisionbackend.entity.Resource;
import com.academicproject.eduvisionbackend.entity.Resource.ResourceType;

public interface ResourceRepository extends JpaRepository<Resource, Long> {

    // Get all resources of a note
    List<Resource> findByNote(Note note);

    // Paginated resources of a note
    Page<Resource> findByNote(Note note, Pageable pageable);

    // Get resources by type
    List<Resource> findByNoteAndType(Note note, ResourceType type);

    // Paginated resources by type
    Page<Resource> findByNoteAndType(Note note, ResourceType type, Pageable pageable);

    // Search by title
    List<Resource> findByTitleContainingIgnoreCase(String keyword);

    // Search inside a note
    Page<Resource> findByNoteAndTitleContainingIgnoreCase(
            Note note,
            String keyword,
            Pageable pageable);

}