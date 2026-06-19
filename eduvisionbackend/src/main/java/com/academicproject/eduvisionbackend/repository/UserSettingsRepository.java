package com.academicproject.eduvisionbackend.repository;

import com.academicproject.eduvisionbackend.entity.User;
import com.academicproject.eduvisionbackend.entity.UserSettings;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.stereotype.Repository;

import java.util.Optional;

@Repository
public interface UserSettingsRepository extends JpaRepository<UserSettings, Long> {
    Optional<UserSettings> findByUser(User user);
}
