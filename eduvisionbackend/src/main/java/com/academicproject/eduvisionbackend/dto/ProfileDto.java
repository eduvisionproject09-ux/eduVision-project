package com.academicproject.eduvisionbackend.dto;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.List;

@Data
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ProfileDto {
    private String fullName;
    private String studentId;
    private String departmentName;
    private String academicYear;
    private String contactInformation;
    private String profileImageUrl;

    private List<AcademicResultDto> academicResults;
    private List<AchievementDto> achievements;
    private List<ExtracurricularDto> extracurricularActivities;
    private List<ScheduleItemDto> scheduleItems;

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AcademicResultDto {
        private Long id;
        private String level;
        private String term;
        private String gpa;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class AchievementDto {
        private Long id;
        private String title;
        private String description;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ExtracurricularDto {
        private Long id;
        private String activityName;
        private String role;
    }

    @Data
    @NoArgsConstructor
    @AllArgsConstructor
    public static class ScheduleItemDto {
        private Long id;
        private String courseName;
        private String time;
        private String location;
    }
}
