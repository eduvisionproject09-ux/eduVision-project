import 'package:flutter/material.dart';
import 'package:flutter_drawing_board/flutter_drawing_board.dart';
import 'package:flutter_drawing_board/paint_contents.dart';
import '../../../theme/app_constants.dart';

class SmartNotesDrawingBoard extends StatefulWidget {
  const SmartNotesDrawingBoard({super.key});

  @override
  State<SmartNotesDrawingBoard> createState() => _SmartNotesDrawingBoardState();
}

class _SmartNotesDrawingBoardState extends State<SmartNotesDrawingBoard> {
  final DrawingController _drawingController = DrawingController();
  String _currentTool = 'Pen';

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _drawingController.setPaintContent(SimpleLine());
    });
  }

  @override
  void dispose() {
    _drawingController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildCustomToolbar(),
        Expanded(
          child: Container(
            color: Colors.white,
            child: DrawingBoard(
              controller: _drawingController,
              boardPanEnabled: false,
              boardScaleEnabled: false,
              background: Container(
                width: double.infinity,
                height: double.infinity,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCustomToolbar() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: SmartNotesTheme.bgSecondary,
        border: Border(bottom: BorderSide(color: SmartNotesTheme.border)),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            _buildToolBtn(
              icon: Icons.draw,
              tooltip: 'Pen',
              isSelected: _currentTool == 'Pen',
              onTap: () {
                _drawingController.setPaintContent(SimpleLine());
                setState(() => _currentTool = 'Pen');
              },
            ),
            const SizedBox(width: 8),
            _buildToolBtn(
              icon: Icons.auto_fix_normal,
              tooltip: 'Eraser',
              isSelected: _currentTool == 'Eraser',
              onTap: () {
                _drawingController.setPaintContent(Eraser());
                setState(() => _currentTool = 'Eraser');
              },
            ),
            const SizedBox(width: 16),
            Container(width: 1, height: 20, color: SmartNotesTheme.border),
            const SizedBox(width: 16),
            _buildToolBtn(
              icon: Icons.crop_square,
              tooltip: 'Rectangle',
              isSelected: _currentTool == 'Rectangle',
              onTap: () {
                _drawingController.setPaintContent(Rectangle());
                setState(() => _currentTool = 'Rectangle');
              },
            ),
            const SizedBox(width: 8),
            _buildToolBtn(
              icon: Icons.circle_outlined,
              tooltip: 'Circle',
              isSelected: _currentTool == 'Circle',
              onTap: () {
                _drawingController.setPaintContent(Circle());
                setState(() => _currentTool = 'Circle');
              },
            ),
            const SizedBox(width: 8),
            _buildToolBtn(
              icon: Icons.horizontal_rule,
              tooltip: 'Line',
              isSelected: _currentTool == 'Line',
              onTap: () {
                _drawingController.setPaintContent(StraightLine());
                setState(() => _currentTool = 'Line');
              },
            ),
            const SizedBox(width: 16),
            Container(width: 1, height: 20, color: SmartNotesTheme.border),
            const SizedBox(width: 16),
            _buildColorBtn(Colors.black),
            _buildColorBtn(Colors.red),
            _buildColorBtn(Colors.blue),
            _buildColorBtn(Colors.green),
            const SizedBox(width: 16),
            Container(width: 1, height: 20, color: SmartNotesTheme.border),
            const SizedBox(width: 16),
            const Text('Size:', style: TextStyle(color: SmartNotesTheme.textMuted, fontSize: 13)),
            Slider(
              value: _drawingController.drawConfig.value.strokeWidth,
              min: 1.0,
              max: 20.0,
              activeColor: SmartNotesTheme.accentBlue,
              onChanged: (val) {
                _drawingController.setStyle(strokeWidth: val);
                setState(() {});
              },
            ),
            const SizedBox(width: 16),
            IconButton(
              icon: const Icon(Icons.undo, color: SmartNotesTheme.iconColor, size: 20),
              onPressed: () => _drawingController.undo(),
              tooltip: 'Undo',
            ),
            IconButton(
              icon: const Icon(Icons.redo, color: SmartNotesTheme.iconColor, size: 20),
              onPressed: () => _drawingController.redo(),
              tooltip: 'Redo',
            ),
            IconButton(
              icon: const Icon(Icons.clear, color: Colors.redAccent, size: 20),
              onPressed: () => _drawingController.clear(),
              tooltip: 'Clear All',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildToolBtn({required IconData icon, required String tooltip, required bool isSelected, required VoidCallback onTap}) {
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: isSelected ? SmartNotesTheme.accent : Colors.transparent,
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, color: isSelected ? SmartNotesTheme.iconDark : SmartNotesTheme.iconColor, size: 20),
        ),
      ),
    );
  }

  Widget _buildColorBtn(Color color) {
    bool isSelected = _drawingController.drawConfig.value.color == color;
    return GestureDetector(
      onTap: () {
        _drawingController.setStyle(color: color);
        setState(() {});
      },
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        width: 24,
        height: 24,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected ? Border.all(color: SmartNotesTheme.accentBlue, width: 2) : Border.all(color: Colors.transparent),
          boxShadow: [
            if (isSelected) BoxShadow(color: color.withOpacity(0.4), blurRadius: 4, spreadRadius: 1)
          ],
        ),
      ),
    );
  }
}
