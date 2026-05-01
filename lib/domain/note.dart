class Note {
  final int id;
  final String content;
  final String subject;
  final String topic;
  final bool bookmarked;
  final DateTime createdAt;
  final DateTime updatedAt;

  Note({
    required this.id,
    required this.content,
    required this.subject,
    required this.topic,
    required this.bookmarked,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Note.fromJson(Map<String, dynamic> json) {
    return Note(
      id: json['id'],
      content: json['content'],
      subject: json['subject'],
      topic: json['topic'],
      bookmarked: json['bookmarked'],
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
    );
  }
}
