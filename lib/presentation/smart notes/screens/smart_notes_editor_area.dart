import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/note.dart';
import '../../theme/app_constants.dart';
import '../provider/notes_provider.dart';
import 'draw/smart_notes_drawing_board.dart';
import 'draw/smart_notes_whiteboard.dart';

class SmartNotesEditorArea extends ConsumerStatefulWidget {
  final int currentTab;
  final bool isEditMode;
  final Function(int) onTabChanged;
  final Function(bool) onEditModeChanged;
  final VoidCallback onToggleExplorer;

  const SmartNotesEditorArea({
    super.key,
    required this.currentTab,
    required this.isEditMode,
    required this.onTabChanged,
    required this.onEditModeChanged,
    required this.onToggleExplorer,
  });

  @override
  ConsumerState<SmartNotesEditorArea> createState() => _SmartNotesEditorAreaState();
}

class _SmartNotesEditorAreaState extends ConsumerState<SmartNotesEditorArea> {
  late TextEditingController _contentController;
  late QuillController _quillController;
  late FocusNode _quillFocusNode;
  int? _loadedNoteId;
  bool _isRichText = false;
  bool _isCanvasMode = true;
  bool _isMetadataVisible = true;

  @override
  void initState() {
    super.initState();
    _contentController = TextEditingController();
    _quillController = QuillController.basic();
    _quillFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _contentController.dispose();
    _quillController.dispose();
    _quillFocusNode.dispose();
    super.dispose();
  }

  void _initQuillFromPlainText(String text) {
    final doc = Document()..insert(0, text);
    _quillController = QuillController(
      document: doc,
      selection: const TextSelection.collapsed(offset: 0),
    );
  }

  String _getQuillPlainText() {
    return _quillController.document.toPlainText();
  }

  void _syncContentToCurrentTab() {
    if (!widget.isEditMode) return;
    if (widget.currentTab == 0) {
      if (_isRichText) {
        _contentController.text = _getQuillPlainText();
        _isRichText = false;
      }
    } else if (widget.currentTab == 1) {
      if (!_isRichText) {
        _initQuillFromPlainText(_contentController.text);
        _isRichText = true;
        setState(() {});
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final activeNoteId = ref.watch(activeNoteIdProvider);
    final notesState = ref.watch(notesProvider);

    final Note? activeNote = activeNoteId != null
        ? notesState.maybeWhen(
            data: (notes) {
              try {
                return notes.firstWhere((n) => n.id == activeNoteId);
              } catch (_) {}
              return null;
            },
            orElse: () => null,
          )
        : null;

    if (activeNote != null && _loadedNoteId != activeNote.id) {
      _loadedNoteId = activeNote.id;
      final savedContent = activeNote.content;
      Future.microtask(() {
        if (mounted) {
          _contentController.text = savedContent;
          _initQuillFromPlainText(savedContent);
        }
      });
    } else if (activeNote == null && _loadedNoteId != null) {
      _loadedNoteId = null;
      Future.microtask(() {
        if (mounted) {
          _contentController.clear();
          _initQuillFromPlainText('');
        }
      });
    }

    _syncContentToCurrentTab();

    return Container(
      color: SmartNotesTheme.bgMain,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
            decoration: const BoxDecoration(
              border: Border(bottom: BorderSide(color: SmartNotesTheme.border)),
            ),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.view_sidebar_outlined, color: SmartNotesTheme.iconColor),
                  onPressed: widget.onToggleExplorer,
                  tooltip: 'Toggle Explorer Sidebar',
                ),
                IconButton(
                  icon: Icon(_isMetadataVisible ? Icons.expand_less : Icons.expand_more, color: SmartNotesTheme.iconColor),
                  onPressed: () => setState(() => _isMetadataVisible = !_isMetadataVisible),
                  tooltip: 'Toggle Metadata',
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    activeNote != null ? activeNote.topic : 'Select or Create a Note',
                    style: const TextStyle(
                      color: SmartNotesTheme.textMain,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                if (activeNote != null) ...[
                  if (widget.isEditMode) ...[
                    _buildTabBtn('Text', Icons.text_fields, 0),
                    const SizedBox(width: 8),
                    _buildTabBtn('Rich', Icons.format_paint, 1),
                    const SizedBox(width: 8),
                    _buildTabBtn('Draw', Icons.draw_outlined, 2),
                    const SizedBox(width: 8),
                    _buildTabBtn('AI Assistant', Icons.smart_toy_outlined, 3),
                    const SizedBox(width: 8),
                    _buildActionBtn('Save', Icons.save_outlined, () async {
                      final content = widget.currentTab == 1
                          ? _getQuillPlainText()
                          : _contentController.text;
                      await ref.read(notesProvider.notifier).updateNote(
                        activeNote.id,
                        content,
                        activeNote.subject.isEmpty ? 'Notes' : activeNote.subject,
                        activeNote.topic,
                      );
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Note saved successfully!'),
                            backgroundColor: SmartNotesTheme.accentBlue,
                          ),
                        );
                      }
                      widget.onEditModeChanged(false);
                    }),
                  ] else ...[
                    _buildActionBtn('Edit', Icons.edit_outlined, () => widget.onEditModeChanged(true)),
                  ]
                ]
              ],
            ),
          ),

          if (_isMetadataVisible)
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
                      decoration: BoxDecoration(
                        color: SmartNotesTheme.bgSecondary,
                        borderRadius: BorderRadius.circular(SmartNotesTheme.radiusSmall),
                        border: Border.all(color: SmartNotesTheme.border),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 8,
                            height: 8,
                            decoration: const BoxDecoration(
                              color: SmartNotesTheme.accentBlue,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Text(
                            activeNote != null && activeNote.subject.isNotEmpty
                                ? activeNote.subject
                                : 'Notes',
                            style: SmartNotesTheme.bodySmall,
                          ),
                          if (widget.isEditMode) ...[
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
                    _buildRemovableTag(
                      activeNote != null && activeNote.subject.isNotEmpty ? activeNote.subject : 'notes',
                      widget.isEditMode,
                    ),
                    if (widget.isEditMode) ...[
                      const SizedBox(width: 8),
                      const Text('Add tag...', style: TextStyle(color: SmartNotesTheme.textMuted, fontSize: 13)),
                      const SizedBox(width: 12),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                        decoration: BoxDecoration(
                          color: SmartNotesTheme.accent,
                          borderRadius: BorderRadius.circular(SmartNotesTheme.radiusSmall),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(
                            color: SmartNotesTheme.iconDark,
                            fontSize: 13,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                    ]
                  ],
                ),
                const SizedBox(height: 16),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: SmartNotesTheme.iconColor, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Created: ${activeNote != null ? activeNote.createdAt.toLocal().toString().split(' ')[0].replaceAll('-', '/') : 'N/A'}',
                      style: SmartNotesTheme.caption,
                    ),
                    const SizedBox(width: 16),
                    const Icon(Icons.update, color: SmartNotesTheme.iconColor, size: 14),
                    const SizedBox(width: 6),
                    Text(
                      'Updated: ${activeNote != null ? activeNote.updatedAt.toLocal().toString().split(' ')[0].replaceAll('-', '/') : 'N/A'}',
                      style: SmartNotesTheme.caption,
                    ),
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
                color: (widget.isEditMode && widget.currentTab == 2)
                    ? Colors.white
                    : SmartNotesTheme.bgSecondary,
                borderRadius: BorderRadius.circular(SmartNotesTheme.radiusMedium),
                border: Border.all(color: SmartNotesTheme.border),
              ),
              clipBehavior: Clip.hardEdge,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (widget.isEditMode) ...[
                    if (widget.currentTab == 1) _buildRichToolbar(),
                    if (widget.currentTab == 3) _buildRichToolbar(),
                    if (widget.currentTab == 2)
                      Container(
                        color: SmartNotesTheme.bgSecondary,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            const Text('Whiteboard', style: TextStyle(color: SmartNotesTheme.textMuted, fontSize: 13, fontWeight: FontWeight.bold)),
                            Switch(
                              value: _isCanvasMode,
                              onChanged: (val) => setState(() => _isCanvasMode = val),
                              activeColor: SmartNotesTheme.accentBlue,
                            ),
                            const Text('Drawing Canvas', style: TextStyle(color: SmartNotesTheme.textMuted, fontSize: 13, fontWeight: FontWeight.bold)),
                          ],
                        ),
                      ),
                  ],
                  Expanded(
                    child: activeNote == null
                        ? const Center(
                            child: Text(
                              'Select a note from the left explorer sidebar or create a new one to begin editing.',
                              style: TextStyle(
                                color: SmartNotesTheme.textMuted,
                                fontSize: 14,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : (widget.isEditMode && widget.currentTab == 2)
                            ? (_isCanvasMode ? const SmartNotesDrawingBoard() : const SmartNotesWhiteboard())
                            : widget.isEditMode && widget.currentTab == 1
                                ? Padding(
                                    padding: const EdgeInsets.all(16),
                                    child: QuillEditor.basic(
                                      controller: _quillController,
                                      focusNode: _quillFocusNode,
                                      config: const QuillEditorConfig(
                                        placeholder: 'Start writing your note...',
                                        padding: EdgeInsets.zero,
                                        autoFocus: false,
                                        scrollable: true,
                                        expands: true,
                                      ),
                                    ),
                                  )
                                : Padding(
                                    padding: const EdgeInsets.all(20.0),
                                    child: widget.isEditMode
                                        ? TextField(
                                            controller: _contentController,
                                            maxLines: null,
                                            style: SmartNotesTheme.body,
                                            decoration: const InputDecoration(
                                              hintText: 'Start writing your note...',
                                              hintStyle: TextStyle(
                                                color: SmartNotesTheme.textMuted,
                                              ),
                                              border: InputBorder.none,
                                            ),
                                          )
                                        : SingleChildScrollView(
                                            child: Text(
                                              activeNote.content.isNotEmpty
                                                  ? activeNote.content
                                                  : "This note has no content yet. Click Edit to add some.",
                                              style: const TextStyle(
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

  Attribute _unsetAttribute(Attribute attr) {
    return Attribute(attr.key, attr.scope, null);
  }

  void _toggleInline(Attribute attr) {
    final sel = _quillController.selection;
    if (!sel.isValid || sel.isCollapsed || sel.start == sel.end) return;
    final index = sel.start;
    final len = sel.end - index;
    final attrs = _quillController.getSelectionStyle().attributes;
    if (attrs.containsKey(attr.key)) {
      _quillController.formatText(index, len, _unsetAttribute(attr));
    } else {
      _quillController.formatText(index, len, attr);
    }
  }

  void _applyBlock(Attribute attr) {
    final sel = _quillController.selection;
    if (!sel.isValid || sel.isCollapsed || sel.start == sel.end) return;
    _quillController.formatText(sel.start, sel.end - sel.start, attr);
  }

  Widget _buildRichToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
      decoration: const BoxDecoration(
        color: SmartNotesTheme.bgSecondary,
        border: Border(bottom: BorderSide(color: SmartNotesTheme.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _quillToolbarBtn(Icons.format_bold, () => _toggleInline(Attribute.bold)),
            const SizedBox(width: 4),
            _quillToolbarBtn(Icons.format_italic, () => _toggleInline(Attribute.italic)),
            const SizedBox(width: 4),
            _quillToolbarBtn(Icons.format_underline, () => _toggleInline(Attribute.underline)),
            const SizedBox(width: 4),
            _quillToolbarBtn(Icons.format_strikethrough, () => _toggleInline(Attribute.strikeThrough)),
            const SizedBox(width: 12),
            Container(width: 1, height: 20, color: SmartNotesTheme.border),
            const SizedBox(width: 12),
            _quillToolbarBtn(Icons.format_list_bulleted, () => _toggleInline(Attribute.ul)),
            const SizedBox(width: 4),
            _quillToolbarBtn(Icons.format_list_numbered, () => _toggleInline(Attribute.ol)),
            const SizedBox(width: 12),
            Container(width: 1, height: 20, color: SmartNotesTheme.border),
            const SizedBox(width: 12),
            _quillToolbarBtn(Icons.format_align_left, () => _applyBlock(Attribute.leftAlignment)),
            const SizedBox(width: 4),
            _quillToolbarBtn(Icons.format_align_center, () => _applyBlock(Attribute.centerAlignment)),
            const SizedBox(width: 4),
            _quillToolbarBtn(Icons.format_align_right, () => _applyBlock(Attribute.rightAlignment)),
            const SizedBox(width: 12),
            Container(width: 1, height: 20, color: SmartNotesTheme.border),
            const SizedBox(width: 12),
            _quillToolbarBtn(Icons.format_quote, () => _toggleInline(Attribute.blockQuote)),
            const SizedBox(width: 4),
            _quillToolbarBtn(Icons.code, () => _toggleInline(Attribute.inlineCode)),
            const SizedBox(width: 4),
            _quillToolbarBtn(Icons.title, () => _toggleInline(Attribute.h1)),
            const SizedBox(width: 4),
            _quillToolbarBtn(Icons.text_fields, () => _toggleInline(Attribute.h2)),
            const SizedBox(width: 16),
            _quillToolbarBtn(Icons.color_lens_outlined, () {
              showDialog(
                context: context,
                builder: (ctx) => SimpleDialog(
                  title: const Text('Choose Color'),
                  children: [
                    SimpleDialogOption(
                      onPressed: () {
                        _applyBlock(Attribute('color', AttributeScope.inline, 'red'));
                        Navigator.pop(ctx);
                      },
                      child: const Row(children: [
                        Icon(Icons.circle, color: Colors.red, size: 20),
                        SizedBox(width: 8),
                        Text('Red'),
                      ]),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        _applyBlock(Attribute('color', AttributeScope.inline, 'blue'));
                        Navigator.pop(ctx);
                      },
                      child: const Row(children: [
                        Icon(Icons.circle, color: Colors.blue, size: 20),
                        SizedBox(width: 8),
                        Text('Blue'),
                      ]),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        _applyBlock(Attribute('color', AttributeScope.inline, 'green'));
                        Navigator.pop(ctx);
                      },
                      child: const Row(children: [
                        Icon(Icons.circle, color: Colors.green, size: 20),
                        SizedBox(width: 8),
                        Text('Green'),
                      ]),
                    ),
                    SimpleDialogOption(
                      onPressed: () {
                        _applyBlock(Attribute('color', AttributeScope.inline, 'purple'));
                        Navigator.pop(ctx);
                      },
                      child: const Row(children: [
                        Icon(Icons.circle, color: Colors.purple, size: 20),
                        SizedBox(width: 8),
                        Text('Purple'),
                      ]),
                    ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }

  Widget _quillToolbarBtn(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(6),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(4),
        ),
        child: Icon(icon, color: SmartNotesTheme.iconActive, size: 18),
      ),
    );
  }



  Widget _buildTabBtn(String title, IconData icon, int index) {
    bool isActive = widget.currentTab == index;
    return GestureDetector(
      onTap: () => widget.onTabChanged(index),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isActive ? SmartNotesTheme.accent : Colors.transparent,
          borderRadius: BorderRadius.circular(SmartNotesTheme.radiusSmall),
          border: Border.all(
            color: isActive ? Colors.transparent : SmartNotesTheme.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              color: isActive ? SmartNotesTheme.iconDark : SmartNotesTheme.iconColor,
              size: 14,
            ),
            const SizedBox(width: 6),
            Text(
              title,
              style: TextStyle(
                color: isActive ? SmartNotesTheme.textDark : SmartNotesTheme.textMuted,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
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
            Text(
              title,
              style: const TextStyle(
                color: SmartNotesTheme.textMain,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRemovableTag(String text, bool isEditMode) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: SmartNotesTheme.bgTertiary,
        borderRadius: BorderRadius.circular(SmartNotesTheme.radiusLarge),
      ),
      child: Row(
        children: [
          Text(
            text,
            style: SmartNotesTheme.caption.copyWith(color: SmartNotesTheme.textMain),
          ),
          if (isEditMode) ...[
            const SizedBox(width: 6),
            const Icon(Icons.close, color: SmartNotesTheme.iconColor, size: 12),
          ]
        ],
      ),
    );
  }
}
