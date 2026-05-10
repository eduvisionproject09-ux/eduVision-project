class AiResponse {
  final String topic;
  final String academicDefinition;
  final String simpleDefinition;
  final String examStandardDescription;

  AiResponse({
    required this.topic,
    required this.academicDefinition,
    required this.simpleDefinition,
    required this.examStandardDescription,
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      topic: json['topic'] ?? '',
      academicDefinition: json['academicDefinition'] ?? '',
      simpleDefinition: json['simpleDefinition'] ?? '',
      examStandardDescription: json['examStandardDescription'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'academicDefinition': academicDefinition,
      'simpleDefinition': simpleDefinition,
      'examStandardDescription': examStandardDescription,
    };
  }
}
