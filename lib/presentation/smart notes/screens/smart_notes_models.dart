class NoteNode {
  final String name;
  final bool isFolder;
  final List<NoteNode> children;
  bool isExpanded;

  NoteNode({
    required this.name,
    this.isFolder = false,
    this.children = const [],
    this.isExpanded = false,
  });
}
