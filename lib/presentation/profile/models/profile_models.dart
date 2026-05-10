class ProfileDto {
  final String? fullName;
  final String? studentId;
  final String? departmentName;
  final String? academicYear;
  final String? contactInformation;
  final String? profileImageUrl;

  final List<AcademicResultDto> academicResults;
  final List<AchievementDto> achievements;
  final List<ExtracurricularDto> extracurricularActivities;
  final List<ScheduleItemDto> scheduleItems;

  ProfileDto({
    this.fullName,
    this.studentId,
    this.departmentName,
    this.academicYear,
    this.contactInformation,
    this.profileImageUrl,
    this.academicResults = const [],
    this.achievements = const [],
    this.extracurricularActivities = const [],
    this.scheduleItems = const [],
  });

  factory ProfileDto.fromJson(Map<String, dynamic> json) {
    return ProfileDto(
      fullName: json['fullName'],
      studentId: json['studentId'],
      departmentName: json['departmentName'],
      academicYear: json['academicYear'],
      contactInformation: json['contactInformation'],
      profileImageUrl: json['profileImageUrl'],
      academicResults: (json['academicResults'] as List<dynamic>?)
              ?.map((e) => AcademicResultDto.fromJson(e))
              .toList() ??
          [],
      achievements: (json['achievements'] as List<dynamic>?)
              ?.map((e) => AchievementDto.fromJson(e))
              .toList() ??
          [],
      extracurricularActivities: (json['extracurricularActivities'] as List<dynamic>?)
              ?.map((e) => ExtracurricularDto.fromJson(e))
              .toList() ??
          [],
      scheduleItems: (json['scheduleItems'] as List<dynamic>?)
              ?.map((e) => ScheduleItemDto.fromJson(e))
              .toList() ??
          [],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'fullName': fullName,
      'studentId': studentId,
      'departmentName': departmentName,
      'academicYear': academicYear,
      'contactInformation': contactInformation,
      'profileImageUrl': profileImageUrl,
      'academicResults': academicResults.map((e) => e.toJson()).toList(),
      'achievements': achievements.map((e) => e.toJson()).toList(),
      'extracurricularActivities': extracurricularActivities.map((e) => e.toJson()).toList(),
      'scheduleItems': scheduleItems.map((e) => e.toJson()).toList(),
    };
  }

  ProfileDto copyWith({
    String? fullName,
    String? studentId,
    String? departmentName,
    String? academicYear,
    String? contactInformation,
    String? profileImageUrl,
    List<AcademicResultDto>? academicResults,
    List<AchievementDto>? achievements,
    List<ExtracurricularDto>? extracurricularActivities,
    List<ScheduleItemDto>? scheduleItems,
  }) {
    return ProfileDto(
      fullName: fullName ?? this.fullName,
      studentId: studentId ?? this.studentId,
      departmentName: departmentName ?? this.departmentName,
      academicYear: academicYear ?? this.academicYear,
      contactInformation: contactInformation ?? this.contactInformation,
      profileImageUrl: profileImageUrl ?? this.profileImageUrl,
      academicResults: academicResults ?? this.academicResults,
      achievements: achievements ?? this.achievements,
      extracurricularActivities: extracurricularActivities ?? this.extracurricularActivities,
      scheduleItems: scheduleItems ?? this.scheduleItems,
    );
  }
}

class AcademicResultDto {
  final int? id;
  final String? level;
  final String? term;
  final String? gpa;

  AcademicResultDto({this.id, this.level, this.term, this.gpa});

  factory AcademicResultDto.fromJson(Map<String, dynamic> json) {
    return AcademicResultDto(
      id: json['id'],
      level: json['level'],
      term: json['term'],
      gpa: json['gpa'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'level': level,
      'term': term,
      'gpa': gpa,
    };
  }
}

class AchievementDto {
  final int? id;
  final String? title;
  final String? description;

  AchievementDto({this.id, this.title, this.description});

  factory AchievementDto.fromJson(Map<String, dynamic> json) {
    return AchievementDto(
      id: json['id'],
      title: json['title'],
      description: json['description'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
    };
  }
}

class ExtracurricularDto {
  final int? id;
  final String? activityName;
  final String? role;

  ExtracurricularDto({this.id, this.activityName, this.role});

  factory ExtracurricularDto.fromJson(Map<String, dynamic> json) {
    return ExtracurricularDto(
      id: json['id'],
      activityName: json['activityName'],
      role: json['role'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'activityName': activityName,
      'role': role,
    };
  }
}

class ScheduleItemDto {
  final int? id;
  final String? courseName;
  final String? time;
  final String? location;

  ScheduleItemDto({this.id, this.courseName, this.time, this.location});

  factory ScheduleItemDto.fromJson(Map<String, dynamic> json) {
    return ScheduleItemDto(
      id: json['id'],
      courseName: json['courseName'],
      time: json['time'],
      location: json['location'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'courseName': courseName,
      'time': time,
      'location': location,
    };
  }
}
