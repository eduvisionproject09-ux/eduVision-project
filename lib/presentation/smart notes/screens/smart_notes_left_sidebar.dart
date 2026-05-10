import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';
import 'smart_notes_models.dart';

class SmartNotesLeftSidebar extends StatefulWidget {
  const SmartNotesLeftSidebar({super.key});

  @override
  State<SmartNotesLeftSidebar> createState() => _SmartNotesLeftSidebarState();
}

class _SmartNotesLeftSidebarState extends State<SmartNotesLeftSidebar> {
  // Dummy hierarchical data
  final List<NoteNode> fileTree = [
    NoteNode(
      name: 'Math',
      isFolder: true,
      isExpanded: true,
      children: [
        NoteNode(
          name: 'Chapter 1',
          isFolder: true,
          children: [
            NoteNode(name: 'Algebra basics.note'),
            NoteNode(name: 'Equations.txt'),
          ],
        ),
        NoteNode(
          name: 'Chapter 2',
          isFolder: true,
          children: [
            NoteNode(name: 'Geometry notes.note'),
          ],
        ),
      ],
    ),
    NoteNode(
      name: 'Physics',
      isFolder: true,
      children: [
        NoteNode(name: 'Kinematics.note'),
      ],
    ),
    NoteNode(name: 'Quick Ideas.txt'),
    NoteNode(name: 'Project Draft.note'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SmartNotesTheme.bgMain,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text('Smart\nNotes', style: SmartNotesTheme.heading1),
                Row(
                  children: [
                    IconButton(icon: const Icon(Icons.note_add_outlined, color: SmartNotesTheme.iconColor, size: 18), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                    const SizedBox(width: 8),
                    IconButton(icon: const Icon(Icons.create_new_folder_outlined, color: SmartNotesTheme.iconColor, size: 18), onPressed: () {}, padding: EdgeInsets.zero, constraints: const BoxConstraints()),
                  ],
                )
              ],
            ),
          ),
          
          // Search & Filters
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
              decoration: BoxDecoration(color: SmartNotesTheme.bgSecondary, borderRadius: BorderRadius.circular(SmartNotesTheme.radiusMedium), border: Border.all(color: SmartNotesTheme.border)),
              child: const TextField(
                style: SmartNotesTheme.body,
                decoration: InputDecoration(
                  icon: Icon(Icons.search, color: SmartNotesTheme.iconColor, size: 18),
                  border: InputBorder.none,
                  hintText: 'Search notes...',
                  hintStyle: TextStyle(color: SmartNotesTheme.textMuted, fontSize: 14),
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(color: SmartNotesTheme.bgSecondary, borderRadius: BorderRadius.circular(SmartNotesTheme.radiusSmall)),
                  child: const Row(children: [Text('Advanced', style: SmartNotesTheme.bodySmall), SizedBox(width: 4), Icon(Icons.tune, color: SmartNotesTheme.iconColor, size: 16)]),
                ),
                const Icon(Icons.filter_list, color: SmartNotesTheme.iconColor, size: 16),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(color: SmartNotesTheme.border, height: 1),
          
          // Explorer Tree Title
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            color: SmartNotesTheme.bgSecondary,
            child: const Text('EXPLORER', style: TextStyle(color: SmartNotesTheme.textMuted, fontSize: 11, fontWeight: FontWeight.bold, letterSpacing: 1.2)),
          ),
          
          // File Tree
          Expanded(
            child: ListView.builder(
              itemCount: fileTree.length,
              itemBuilder: (context, index) {
                return _buildTreeNode(fileTree[index], 0);
              },
            ),
          )
        ],
      ),
    );
  }

  Widget _buildTreeNode(NoteNode node, int depth) {
    // If it's a folder, render a collapsible column
    if (node.isFolder) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          InkWell(
            onTap: () {
              setState(() {
                node.isExpanded = !node.isExpanded;
              });
            },
            child: Padding(
              padding: EdgeInsets.only(left: 16.0 + (depth * 12.0), right: 16.0, top: 6, bottom: 6),
              child: Row(
                children: [
                  Icon(
                    node.isExpanded ? Icons.keyboard_arrow_down : Icons.keyboard_arrow_right,
                    color: SmartNotesTheme.iconColor,
                    size: 16,
                  ),
                  const SizedBox(width: 4),
                  const Icon(Icons.folder, color: SmartNotesTheme.accentBlue, size: 16),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      node.name,
                      style: const TextStyle(color: SmartNotesTheme.textMain, fontSize: 13, fontWeight: FontWeight.w500),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (node.isExpanded)
            ...node.children.map((child) => _buildTreeNode(child, depth + 1)),
        ],
      );
    }

    // If it's a file
    IconData fileIcon = Icons.insert_drive_file;
    Color iconColor = SmartNotesTheme.iconColor;
    if (node.name.endsWith('.note')) {
      fileIcon = Icons.description;
      iconColor = const Color(0xFFE2B93B); // Yellowish for .note
    } else if (node.name.endsWith('.txt')) {
      fileIcon = Icons.subject;
      iconColor = const Color(0xFF519ABA); // Light blue for .txt
    }

    return InkWell(
      onTap: () {
        // Handle file open logic here
      },
      child: Padding(
        padding: EdgeInsets.only(left: 16.0 + (depth * 12.0) + 20.0, right: 16.0, top: 4, bottom: 4),
        child: Row(
          children: [
            Icon(fileIcon, color: iconColor, size: 16),
            const SizedBox(width: 8),
            Expanded(
              child: Text(
                node.name,
                style: const TextStyle(color: SmartNotesTheme.textMuted, fontSize: 13),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
