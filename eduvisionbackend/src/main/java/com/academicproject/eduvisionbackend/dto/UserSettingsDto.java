package com.academicproject.eduvisionbackend.dto;

import lombok.*;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class UserSettingsDto {
    private String theme;
    private String language;
    private boolean emailNotifications;
    private boolean pushNotifications;
}
