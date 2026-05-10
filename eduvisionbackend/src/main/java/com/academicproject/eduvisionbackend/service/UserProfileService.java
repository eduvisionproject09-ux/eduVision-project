package com.academicproject.eduvisionbackend.service;

import com.academicproject.eduvisionbackend.dto.ProfileDto;
import com.academicproject.eduvisionbackend.entity.*;
import com.academicproject.eduvisionbackend.repository.UserProfileRepository;
import com.academicproject.eduvisionbackend.repository.UserRepository;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;
import java.util.stream.Collectors;

@Slf4j
@Service
@RequiredArgsConstructor
public class UserProfileService {

    private final UserProfileRepository userProfileRepository;
    private final UserRepository userRepository;

    @Value("${upload.path:uploads/}")
    private String uploadPath;

    @Transactional
    public ProfileDto getProfile(String username) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        UserProfile profile = userProfileRepository.findByUser(user)
                .orElseGet(() -> createEmptyProfile(user));

        return mapToDto(profile);
    }

    @Transactional
    public ProfileDto updateProfile(String username, ProfileDto profileDto) {
        User user = userRepository.findByUsername(username)
                .orElseThrow(() -> new RuntimeException("User not found"));
        
        UserProfile profile = userProfileRepository.findByUser(user)
                .orElseGet(() -> createEmptyProfile(user));

        profile.setFullName(profileDto.getFullName());
        profile.setStudentId(profileDto.getStudentId());
        profile.setDepartmentName(profileDto.getDepartmentName());
        profile.setAcademicYear(profileDto.getAcademicYear());
        profile.setContactInformation(profileDto.getContactInformation());
        profile.setProfileImageUrl(profileDto.getProfileImageUrl());
        
        log.info("ED_PROFILE: [UserProfileService] - Updating profile for user: {}. New Image URL: {}", username, profileDto.getProfileImageUrl());
        
        // We do not map the nested collections here, we will have separate endpoints for them
        // or we can map them if we want to replace the whole profile at once.
        // For simplicity, let's allow updating the whole profile at once.
        
        updateCollections(profile, profileDto);
        
        userProfileRepository.save(profile);
        return mapToDto(profile);
    }

    @Transactional
    public String uploadProfileImage(String username, MultipartFile file) {
        if (file.isEmpty()) {
            throw new RuntimeException("Failed to store empty file.");
        }

        try {
            User user = userRepository.findByUsername(username)
                    .orElseThrow(() -> new RuntimeException("User not found"));
            UserProfile profile = userProfileRepository.findByUser(user)
                    .orElseGet(() -> createEmptyProfile(user));

            Path uploadDir = Paths.get(uploadPath);
            if (!Files.exists(uploadDir)) {
                Files.createDirectories(uploadDir);
            }

            String filename = UUID.randomUUID().toString() + "_" + file.getOriginalFilename();
            Path destinationFile = uploadDir.resolve(Paths.get(filename)).normalize().toAbsolutePath();

            Files.copy(file.getInputStream(), destinationFile);

            String fileUrl = "/api/profile/images/" + filename;
            profile.setProfileImageUrl(fileUrl);
            userProfileRepository.save(profile);

            log.info("ED_PROFILE: [UserProfileService] - Uploaded image for user: {}. URL: {}", username, fileUrl);
            return fileUrl;
        } catch (IOException e) {
            log.error("ED_PROFILE: [UserProfileService] - Failed to store file for user: {}", username, e);
            throw new RuntimeException("Failed to store file.", e);
        }
    }

    private UserProfile createEmptyProfile(User user) {
        UserProfile profile = new UserProfile();
        profile.setUser(user);
        return userProfileRepository.save(profile);
    }

    private void updateCollections(UserProfile profile, ProfileDto dto) {
        if (dto.getAcademicResults() != null) {
            profile.getAcademicResults().clear();
            profile.getAcademicResults().addAll(
                dto.getAcademicResults().stream().map(resultDto -> {
                    AcademicResult res = new AcademicResult();
                    res.setLevel(resultDto.getLevel());
                    res.setTerm(resultDto.getTerm());
                    res.setGpa(resultDto.getGpa());
                    res.setUserProfile(profile);
                    return res;
                }).collect(Collectors.toList())
            );
        }

        if (dto.getAchievements() != null) {
            profile.getAchievements().clear();
            profile.getAchievements().addAll(
                dto.getAchievements().stream().map(achDto -> {
                    Achievement ach = new Achievement();
                    ach.setTitle(achDto.getTitle());
                    ach.setDescription(achDto.getDescription());
                    ach.setUserProfile(profile);
                    return ach;
                }).collect(Collectors.toList())
            );
        }

        if (dto.getExtracurricularActivities() != null) {
            profile.getExtracurricularActivities().clear();
            profile.getExtracurricularActivities().addAll(
                dto.getExtracurricularActivities().stream().map(exDto -> {
                    ExtracurricularActivity ex = new ExtracurricularActivity();
                    ex.setActivityName(exDto.getActivityName());
                    ex.setRole(exDto.getRole());
                    ex.setUserProfile(profile);
                    return ex;
                }).collect(Collectors.toList())
            );
        }

        if (dto.getScheduleItems() != null) {
            profile.getScheduleItems().clear();
            profile.getScheduleItems().addAll(
                dto.getScheduleItems().stream().map(schDto -> {
                    ScheduleItem sch = new ScheduleItem();
                    sch.setCourseName(schDto.getCourseName());
                    sch.setTime(schDto.getTime());
                    sch.setLocation(schDto.getLocation());
                    sch.setUserProfile(profile);
                    return sch;
                }).collect(Collectors.toList())
            );
        }
    }

    private ProfileDto mapToDto(UserProfile profile) {
        return ProfileDto.builder()
                .fullName(profile.getFullName())
                .studentId(profile.getStudentId())
                .departmentName(profile.getDepartmentName())
                .academicYear(profile.getAcademicYear())
                .contactInformation(profile.getContactInformation())
                .profileImageUrl(profile.getProfileImageUrl())
                .academicResults(profile.getAcademicResults().stream()
                        .map(r -> new ProfileDto.AcademicResultDto(r.getId(), r.getLevel(), r.getTerm(), r.getGpa()))
                        .collect(Collectors.toList()))
                .achievements(profile.getAchievements().stream()
                        .map(a -> new ProfileDto.AchievementDto(a.getId(), a.getTitle(), a.getDescription()))
                        .collect(Collectors.toList()))
                .extracurricularActivities(profile.getExtracurricularActivities().stream()
                        .map(e -> new ProfileDto.ExtracurricularDto(e.getId(), e.getActivityName(), e.getRole()))
                        .collect(Collectors.toList()))
                .scheduleItems(profile.getScheduleItems().stream()
                        .map(s -> new ProfileDto.ScheduleItemDto(s.getId(), s.getCourseName(), s.getTime(), s.getLocation()))
                        .collect(Collectors.toList()))
                .build();
    }
}
