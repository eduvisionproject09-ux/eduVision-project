class AiResponse {
  final String topic;
  final String content;
  final String academicDefinition;
  final String simpleDefinition;
  final String examStandardDescription;

  AiResponse({
    required this.topic,
    this.content = '',
    this.academicDefinition = '',
    this.simpleDefinition = '',
    this.examStandardDescription = '',
  });

  factory AiResponse.fromJson(Map<String, dynamic> json) {
    return AiResponse(
      topic: json['topic'] ?? '',
      content: json['content'] ?? '',
      academicDefinition: json['academicDefinition'] ?? '',
      simpleDefinition: json['simpleDefinition'] ?? '',
      examStandardDescription: json['examStandardDescription'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'topic': topic,
      'content': content,
      'academicDefinition': academicDefinition,
      'simpleDefinition': simpleDefinition,
      'examStandardDescription': examStandardDescription,
    };
  }
}
