import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';

class SmartNotesEditorArea extends StatelessWidget {
  final int currentTab;
  final bool isEditMode;
  final Function(int) onTabChanged;
  final Function(bool) onEditModeChanged;

  const SmartNotesEditorArea({
    super.key,
    required this.currentTab,
    required this.isEditMode,
    required this.onTabChanged,
    required this.onEditModeChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SmartNotesTheme.bgMain,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: SmartNotesTheme.border))),
            child: Row(
              children: [
                const Expanded(
                  child: Text('Note 1', style: TextStyle(color: SmartNotesTheme.textMuted, fontSize: 14)),
                ),
                if (isEditMode) ...[
                  _buildTabBtn('Text', Icons.text_fields, 0),
                  const SizedBox(width: 8),
                  _buildTabBtn('Rich', Icons.format_paint, 1),
                  const SizedBox(width: 8),
                  _buildTabBtn('Draw', Icons.draw_outlined, 2),
                  const SizedBox(width: 8),
                  _buildTabBtn('AI Assistant', Icons.smart_toy_outlined, 3),
                  const SizedBox(width: 8),
                  _buildActionBtn('Save', Icons.save_outlined, () => onEditModeChanged(false)),
                ] else ...[
                  _buildActionBtn('Edit', Icons.edit_outlined, () => onEditModeChanged(true)),
                ]
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Text('Folder: ', style: TextStyle(color: SmartNotesTheme.textMuted, fontSize: 13)),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(color: SmartNotesTheme.bgSecondary, borderRadius: BorderRadius.circular(SmartNotesTheme.radiusSmall), border: Border.all(color: SmartNotesTheme.border)),
                      child: Row(
                        children: [
                          Container(width: 8, height: 8, decoration: const BoxDecoration(color: SmartNotesTheme.accentBlue, shape: BoxShape.circle)),
                          const SizedBox(width: 8),
                          const Text('Notes', style: SmartNotesTheme.bodySmall),
                          if (isEditMode) ...[
                            const SizedBox(width: 20),
                            const Icon(Icons.keyboard_arrow_down, color: SmartNotesTheme.iconColor, size: 16),
                          ]
                        ],
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.local_offer_outlined, color: SmartNotesTheme.iconColor, size: 16),
                    const SizedBox(width: 8),
                    _buildRemovableTag('test', isEditMode),
                    const SizedBox(width: 8),
                    _buildRemovableTag('notes', isEditMode),
                    if (isEditMode) ...[
                      const SizedBox(width: 8),
                      const Text('Add tag...', style: TextStyle(color: SmartNotesTheme.textMuted, fontSize: 13)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(color: SmartNotesTheme.accent, borderRadius: BorderRadius.circular(SmartNotesTheme.radiusSmall)),
                        child: const Text('Add', style: TextStyle(color: SmartNotesTheme.textDark, fontSize: 13, fontWeight: FontWeight.bold)),
                      )
                    ]
                  ],
                ),
                const SizedBox(height: 16),
                const Row(
                  children: [
                    Icon(Icons.calendar_today, color: SmartNotesTheme.iconColor, size: 14),
                    SizedBox(width: 6),
                    Text('Created: 03/10/2025', style: SmartNotesTheme.caption),
                    SizedBox(width: 16),
                    Icon(Icons.update, color: SmartNotesTheme.iconColor, size: 14),
                    SizedBox(width: 6),
                    Text('Updated: 05/10/2025', style: SmartNotesTheme.caption),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: SmartNotesTheme.border, height: 1),
          Expanded(
            child: Container(
              margin: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: (isEditMode && currentTab == 2) ? Colors.white : SmartNotesTheme.bgSecondary,
                borderRadius: BorderRadius.circular(SmartNotesTheme.radiusMedium),
                border: Border.all(color: SmartNotesTheme.border),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (isEditMode) ...[
                    if (currentTab == 1 || currentTab == 3) _buildRichToolbar(),
                    if (currentTab == 2) _buildDrawToolbar(),
                  ],
                  Expanded(
                    child: (isEditMode && currentTab == 2)
                        ? Container(color: Colors.white) // Canvas
                        : Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: isEditMode
                                ? const TextField(
                                    maxLines: null,
                                    style: SmartNotesTheme.body,
                                    decoration: InputDecoration(
                                      hintText: 'Start writing your note...',
                                      hintStyle: TextStyle(color: SmartNotesTheme.textMuted),
                                      border: InputBorder.none,
                                    ),
                                  )
                                : const SingleChildScrollView(
                                    child: Text(
                                      "This is a read-only preview of the note.\n\nIn a real app, this would be a rendered Markdown or Rich Text widget based on the saved content.",
                                      style: TextStyle(
                                        color: SmartNotesTheme.textMain,
                                        fontSize: 15,
                                        height: 1.6,
                                      ),
                                    ),
                                  ),
                          ),
                  ),
                ],
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildRichToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: SmartNotesTheme.bgSecondary,
        border: Border(bottom: BorderSide(color: SmartNotesTheme.border)),
      ),
      child: const Row(
        children: [
          Icon(Icons.format_bold, color: SmartNotesTheme.iconActive, size: 18),
          SizedBox(width: 16),
          Icon(Icons.format_italic, color: SmartNotesTheme.iconActive, size: 18),
          SizedBox(width: 16),
          Icon(Icons.format_underline, color: SmartNotesTheme.iconActive, size: 18),
          SizedBox(width: 24),
          Icon(Icons.format_list_bulleted, color: SmartNotesTheme.iconActive, size: 18),
          SizedBox(width: 16),
          Icon(Icons.format_list_numbered, color: SmartNotesTheme.iconActive, size: 18),
          SizedBox(width: 24),
          Icon(Icons.format_align_left, color: SmartNotesTheme.iconActive, size: 18),
          SizedBox(width: 16),
          Icon(Icons.format_align_center, color: SmartNotesTheme.iconActive, size: 18),
          SizedBox(width: 16),
          Icon(Icons.format_align_right, color: SmartNotesTheme.iconActive, size: 18),
          SizedBox(width: 24),
          Icon(Icons.color_lens_outlined, color: SmartNotesTheme.iconActive, size: 18),
          SizedBox(width: 16),
          Icon(Icons.format_quote, color: SmartNotesTheme.iconActive, size: 18),
        ],
      ),
    );
  }

  Widget _buildDrawToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: SmartNotesTheme.bgSecondary,
        border: Border(bottom: BorderSide(color: SmartNotesTheme.border)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(6),
            decoration: BoxDecoration(color: SmartNotesTheme.accent, borderRadius: BorderRadius.circular(4)),
            child: const Icon(Icons.draw, color: SmartNotesTheme.iconDark, size: 18),
          ),
          const SizedBox(width: 16),
          const Icon(Icons.auto_fix_normal, color: SmartNotesTheme.iconColor, size: 18), // Eraser
          const SizedBox(width: 16),
          const Icon(Icons.crop_square, color: SmartNotesTheme.iconColor, size: 18),
          const SizedBox(width: 16),
          const Icon(Icons.circle_outlined, color: SmartNotesTheme.iconColor, size: 18),
          const SizedBox(width: 24),
          const Icon(Icons.color_lens, color: SmartNotesTheme.iconColor, size: 18),
          const SizedBox(width: 16),
          const Text('Size:', style: TextStyle(color: SmartNotesTheme.textMuted, fontSize: 13)),
          const SizedBox(width: 8),
          Container(width: 40, height: 4, decoration: BoxDecoration(color: SmartNotesTheme.textMuted, borderRadius: BorderRadius.circular(2))),
          const SizedBox(width: 8),
          const Text('2', style: TextStyle(color: SmartNotesTheme.textMuted, fontSize: 13)),
          const Spacer(),
          const Icon(Icons.undo, color: SmartNotesTheme.iconColor, size: 18),
          const SizedBox(width: 16),
          const Icon(Icons.redo, color: SmartNotesTheme.iconColor, size: 18),
        ],
      ),
    );
  }

  Widget _buildTabBtn(String title, IconData icon, int index) {
    bool isActive = currentTab == index;
    return GestureDetector(
      onTap: () => onTabChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? SmartNotesTheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(SmartNotesTheme.radiusSmall),
          border: Border.all(color: isActive ? Colors.transparent : SmartNotesTheme.border),
        ),
        child: Row(
          children: [
            Icon(icon, color: isActive ? SmartNotesTheme.iconDark : SmartNotesTheme.iconColor, size: 14),
            const SizedBox(width: 6),
            Text(title, style: TextStyle(color: isActive ? SmartNotesTheme.textDark : SmartNotesTheme.textMuted, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildActionBtn(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: SmartNotesTheme.bgTertiary,
          borderRadius: BorderRadius.circular(SmartNotesTheme.radiusSmall),
          border: Border.all(color: const Color(0xFF333333)),
        ),
        child: Row(
          children: [
            Icon(icon, color: SmartNotesTheme.iconActive, size: 14),
            const SizedBox(width: 6),
            Text(title, style: const TextStyle(color: SmartNotesTheme.textMain, fontSize: 13, fontWeight: FontWeight.w500)),
          ],
        ),
      ),
    );
  }

  Widget _buildRemovableTag(String text, bool isEditMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(color: SmartNotesTheme.bgTertiary, borderRadius: BorderRadius.circular(SmartNotesTheme.radiusLarge)),
      child: Row(
        children: [
          Text(text, style: SmartNotesTheme.caption.copyWith(color: SmartNotesTheme.textMain)),
          if (isEditMode) ...[
            const SizedBox(width: 6),
            const Icon(Icons.close, color: SmartNotesTheme.iconColor, size: 12),
          ]
        ],
      ),
    );
  }
}
