package com.academicproject.eduvisionbackend.repository;

import java.time.LocalDate;
import java.util.List;

import org.springframework.data.jpa.repository.JpaRepository;

import com.academicproject.eduvisionbackend.entity.Event;
import com.academicproject.eduvisionbackend.entity.User;

public interface EventRepository extends JpaRepository<Event, Long> {
    List<Event> findByUserOrderByEventDateAsc(User user);

    List<Event> findByUserAndEventDateGreaterThanEqualOrderByEventDateAsc(User user, LocalDate date);

    List<Event> findByUserAndEventDateOrderByStartTimeAsc(User user, LocalDate date);

    List<Event> findByUserAndEventDateBeforeOrderByEventDateDesc(User user, LocalDate date);
}
