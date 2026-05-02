import 'resource.dart';

class Note {
  final int id;
  final String content;
  final String subject;
  final String topic;
  final bool bookmarked;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<Resource> resources;

  Note({
    required this.id,
    required this.content,
    required this.subject,
    required this.topic,
    required this.bookmarked,
    required this.createdAt,
    required this.updatedAt,
    this.resources = const [],
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      content: json['content'] ?? '',
      subject: json['subject'] ?? '',
      topic: json['topic'] ?? '',
      bookmarked: json['bookmarked'] ?? false,
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      resources: json['resources'] != null
          ? (json['resources'] as List).map((r) => Resource.fromJson(r)).toList()
          : [],
    );
  }
}
