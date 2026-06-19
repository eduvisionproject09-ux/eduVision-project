package com.academicproject.eduvisionbackend.repository;

import java.util.List;

import org.springframework.data.domain.Page;
import org.springframework.data.domain.Pageable;
import org.springframework.data.jpa.repository.JpaRepository;
import com.academicproject.eduvisionbackend.entity.Note;
import com.academicproject.eduvisionbackend.entity.User;

public interface NoteRepository extends JpaRepository<Note, Long> {
    Page<Note> findByUser(User user, Pageable pageable);

    List<Note> findByUser(User user);

    Page<Note> findByUserAndSubjectContainingIgnoreCaseOrTopicContainingIgnoreCase(User user, String subject,
            String topic, Pageable pageable);

    List<Note> findByUserAndBookmarkedTrue(User user);
}