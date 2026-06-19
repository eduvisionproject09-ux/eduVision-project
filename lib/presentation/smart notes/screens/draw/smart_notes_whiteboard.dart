import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../../theme/app_constants.dart';

class WhiteboardItem {
  final String id;
  Offset position;
  final String type; // 'sticky_note' or 'clip'
  String content;
  Color color;

  WhiteboardItem({
    required this.id,
    required this.position,
    required this.type,
    this.content = '',
    this.color = Colors.amber,
  });
}

class SmartNotesWhiteboard extends StatefulWidget {
  const SmartNotesWhiteboard({super.key});

  @override
  State<SmartNotesWhiteboard> createState() => _SmartNotesWhiteboardState();
}

class _SmartNotesWhiteboardState extends State<SmartNotesWhiteboard> {
  final List<WhiteboardItem> _items = [];
  final _uuid = const Uuid();

  void _addStickyNote() {
    setState(() {
      _items.add(WhiteboardItem(
        id: _uuid.v4(),
        position: const Offset(100, 100),
        type: 'sticky_note',
        content: 'New Sticky Note\nDouble tap to edit',
        color: AppColors.yellow200,
      ));
    });
  }

  void _addNoteClip() {
    setState(() {
      _items.add(WhiteboardItem(
        id: _uuid.v4(),
        position: const Offset(150, 150),
        type: 'clip',
        content: 'Sample Note Clip:\n"Photosynthesis is the process..."',
        color: AppColors.blue100,
      ));
    });
  }

  void _editStickyNote(WhiteboardItem item) {
    TextEditingController controller = TextEditingController(text: item.content);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Edit Sticky Note'),
        content: TextField(
          controller: controller,
          maxLines: 5,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              setState(() {
                item.content = controller.text;
              });
              Navigator.pop(ctx);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _bringToFront(WhiteboardItem item) {
    setState(() {
      _items.remove(item);
      _items.add(item);
    });
  }

  void _changeColor(WhiteboardItem item) {
    showDialog(
      context: context,
      builder: (ctx) => SimpleDialog(
        title: const Text('Change Background Color'),
        children: [
          _colorOption(item, AppColors.yellow200, 'Yellow', ctx),
          _colorOption(item, AppColors.green200, 'Green', ctx),
          _colorOption(item, AppColors.blue200, 'Blue', ctx),
          _colorOption(item, AppColors.pink50, 'Pink', ctx),
          _colorOption(item, AppColors.purple200, 'Purple', ctx),
        ],
      ),
    );
  }

  SimpleDialogOption _colorOption(WhiteboardItem item, Color color, String name, BuildContext ctx) {
    return SimpleDialogOption(
      onPressed: () {
        setState(() => item.color = color);
        Navigator.pop(ctx);
      },
      child: Row(
        children: [
          Container(width: 24, height: 24, decoration: BoxDecoration(color: color, border: Border.all(color: Colors.black12))),
          const SizedBox(width: 12),
          Text(name),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildToolbar(),
        Expanded(
          child: Container(
            color: SmartNotesTheme.bgSecondary,
            child: Stack(
              children: [
                ..._items.map((item) => Positioned(
                      left: item.position.dx,
                      top: item.position.dy,
                      child: GestureDetector(
                        onPanUpdate: (details) {
                          setState(() {
                            item.position += details.delta;
                          });
                        },
                        onPanStart: (_) => _bringToFront(item),
                        onDoubleTap: () {
                          if (item.type == 'sticky_note') _editStickyNote(item);
                        },
                        child: _buildItem(item),
                      ),
                    )),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: SmartNotesTheme.bgMain,
        border: Border(bottom: BorderSide(color: SmartNotesTheme.border)),
      ),
      child: Row(
        children: [
          ElevatedButton.icon(
            onPressed: _addStickyNote,
            icon: const Icon(Icons.sticky_note_2, size: 18),
            label: const Text('Add Sticky Note'),
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.yellow400,
              foregroundColor: Colors.black87,
              elevation: 0,
            ),
          ),
          const SizedBox(width: 12),
          OutlinedButton.icon(
            onPressed: _addNoteClip,
            icon: const Icon(Icons.attach_file, size: 18),
            label: const Text('Clip Note Portion'),
            style: OutlinedButton.styleFrom(
              foregroundColor: SmartNotesTheme.textMain,
            ),
          ),
          const Spacer(),
          const Text('Drag to move • Double-tap to edit', style: SmartNotesTheme.caption),
        ],
      ),
    );
  }

  Widget _buildItem(WhiteboardItem item) {
    if (item.type == 'sticky_note') {
      return Container(
        width: 200,
        height: 200,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: item.color,
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(2, 4))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                GestureDetector(
                  onTap: () => _changeColor(item),
                  child: const Icon(Icons.color_lens, size: 16, color: Colors.black54),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => setState(() => _items.remove(item)),
                  child: const Icon(Icons.close, size: 16, color: Colors.black54),
                ),
              ],
            ),
            Expanded(
              child: Center(
                child: Text(
                  item.content,
                  style: const TextStyle(fontSize: 16, color: Colors.black87, fontFamily: 'Kalam'),
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          ],
        ),
      );
    } else {
      // Clip
      return Container(
        width: 250,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border.all(color: AppColors.blue200, width: 2),
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(color: Colors.black.withOpacity(0.05), blurRadius: 4, offset: const Offset(0, 2))
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                const Icon(Icons.push_pin, size: 16, color: AppColors.blue500),
                const SizedBox(width: 8),
                const Text('Clipped Note', style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12, color: AppColors.blue500)),
                const Spacer(),
                GestureDetector(
                  onTap: () => setState(() => _items.remove(item)),
                  child: const Icon(Icons.close, size: 16, color: Colors.black54),
                ),
              ],
            ),
            const Divider(),
            Text(
              item.content,
              style: const TextStyle(fontSize: 14, color: Colors.black87),
            ),
          ],
        ),
      );
    }
  }
}
