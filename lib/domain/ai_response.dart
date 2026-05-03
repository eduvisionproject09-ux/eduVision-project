class AiResponse {
  final String academicDefinition;
  final String simpleDefinition;
  final String examStandardDescription;

  AiResponse({
    required this.academicDefinition,
    required this.simpleDefinition,
    required this.examStandardDescription,
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      academicDefinition: json['academicDefinition'] ?? '',
      simpleDefinition: json['simpleDefinition'] ?? '',
      examStandardDescription: json['examStandardDescription'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'academicDefinition': academicDefinition,
      'simpleDefinition': simpleDefinition,
      'examStandardDescription': examStandardDescription,
    };
  }
}
