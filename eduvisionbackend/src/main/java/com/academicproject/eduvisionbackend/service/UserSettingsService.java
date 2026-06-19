package com.academicproject.eduvisionbackend.service;

import com.academicproject.eduvisionbackend.dto.UserSettingsDto;
import com.academicproject.eduvisionbackend.entity.User;
import com.academicproject.eduvisionbackend.entity.UserSettings;
import com.academicproject.eduvisionbackend.repository.UserSettingsRepository;
import com.academicproject.eduvisionbackend.repository.UserRepository;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserSettingsService {

    private final UserSettingsRepository userSettingsRepository;
    private final UserRepository userRepository;

    @Transactional
    public UserSettingsDto getSettings(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        UserSettings settings = userSettingsRepository.findByUser(user)
                .orElseGet(() -> createDefaultSettings(user));

        return mapToDto(settings);
    }

    @Transactional
    public UserSettingsDto updateSettings(String username, UserSettingsDto dto) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));

        UserSettings settings = userSettingsRepository.findByUser(user)
                .orElseGet(() -> createDefaultSettings(user));

        if (dto.getTheme() != null) {
            settings.setTheme(dto.getTheme());
        }
        if (dto.getLanguage() != null) {
            settings.setLanguage(dto.getLanguage());
        }
        settings.setEmailNotifications(dto.isEmailNotifications());
        settings.setPushNotifications(dto.isPushNotifications());

        UserSettings saved = userSettingsRepository.save(settings);
        log.info("UserSettings updated for user: {}. Theme: {}, Lang: {}", username, saved.getTheme(), saved.getLanguage());
        return mapToDto(saved);
    }

    private UserSettings createDefaultSettings(User user) {
        UserSettings settings = UserSettings.builder()
                .user(user)
                .theme("light")
                .language("en")
                .emailNotifications(true)
                .pushNotifications(true)
                .build();
        return userSettingsRepository.save(settings);
    }

    private UserSettingsDto mapToDto(UserSettings settings) {
        return UserSettingsDto.builder()
                .theme(settings.getTheme())
                .language(settings.getLanguage())
                .emailNotifications(settings.isEmailNotifications())
                .pushNotifications(settings.isPushNotifications())
                .build();
    }
}
