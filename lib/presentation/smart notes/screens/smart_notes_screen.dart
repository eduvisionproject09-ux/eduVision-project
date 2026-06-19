import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';
import 'smart_notes_left_sidebar.dart';
import 'smart_notes_editor_area.dart';
import 'smart_notes_ai_sidebar.dart';

class SmartNotes extends StatefulWidget {
  const SmartNotes({super.key});

  @override
  State<SmartNotes> createState() => _SmartNotesState();
}

class _SmartNotesState extends State<SmartNotes> {
  int currentTab = 0;
  bool isEditMode = true;
  bool isExplorerVisible = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: SmartNotesTheme.bgMain,
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (isExplorerVisible) ...[
            const SizedBox(
              width: SmartNotesTheme.leftSidebarWidth,
              child: SmartNotesLeftSidebar(),
            ),
            Container(width: 1, color: SmartNotesTheme.border),
          ],
          Expanded(
            child: SmartNotesEditorArea(
              currentTab: currentTab,
              isEditMode: isEditMode,
              onTabChanged: (index) {
                setState(() {
                  currentTab = index;
                });
              },
              onEditModeChanged: (mode) {
                setState(() {
                  isEditMode = mode;
                });
              },
              onToggleExplorer: () {
                setState(() {
                  isExplorerVisible = !isExplorerVisible;
                });
              },
            ),
          ),
          if (currentTab == 3) ...[
            Container(width: 1, color: SmartNotesTheme.border),
            SizedBox(
              width: SmartNotesTheme.aiSidebarWidth,
              child: SmartNotesAiSidebar(
                onClose: () => setState(() => currentTab = 0),
              ),
            ),
          ],
        ],
      ),
    );
  }
}
