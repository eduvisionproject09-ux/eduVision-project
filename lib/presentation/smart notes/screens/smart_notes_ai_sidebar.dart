import 'package:flutter/material.dart';
import '../../theme/app_constants.dart';

class SmartNotesAiSidebar extends StatelessWidget {
  const SmartNotesAiSidebar({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: SmartNotesTheme.bgMain,
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(border: Border(bottom: BorderSide(color: SmartNotesTheme.border))),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(color: SmartNotesTheme.accent, shape: BoxShape.circle),
                  child: const Icon(Icons.smart_toy, color: SmartNotesTheme.iconDark, size: 18),
                ),
                const SizedBox(width: 12),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('AI Assistant', style: SmartNotesTheme.heading2),
                      Text('Smart productivity helper', style: SmartNotesTheme.caption),
                    ],
                  ),
                ),
                const Icon(Icons.close, color: SmartNotesTheme.iconColor, size: 18),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quick Actions:', style: SmartNotesTheme.bodySmall),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildActionBtn('Organize Content', Icons.format_list_bulleted)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildActionBtn('Create Schedule', Icons.calendar_today)),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildActionBtn('Plan Event', Icons.gps_fixed)),
                    const SizedBox(width: 8),
                    Expanded(child: _buildActionBtn('Implementation Ideas', Icons.lightbulb_outline)),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: SmartNotesTheme.border, height: 1),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: const EdgeInsets.all(4),
                      decoration: const BoxDecoration(color: SmartNotesTheme.accent, shape: BoxShape.circle),
                      child: const Icon(Icons.smart_toy, color: SmartNotesTheme.iconDark, size: 14),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(color: SmartNotesTheme.bgSecondary, borderRadius: BorderRadius.circular(SmartNotesTheme.radiusLarge), border: Border.all(color: SmartNotesTheme.border)),
                        child: const Text(
                          "Hi! I'm your AI assistant. I can help you organize your thoughts, create schedules, plan events, or suggest ways to implement your ideas. What would you like to work on?",
                          style: TextStyle(color: SmartNotesTheme.textMain, height: 1.4, fontSize: 13),
                        ),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 16),
                _buildSuggestion('Help me organize this note better'),
                _buildSuggestion('Create a daily schedule'),
                _buildSuggestion('Plan an event'),
                _buildSuggestion('Brainstorm implementation ideas'),
                const SizedBox(height: 12),
                const Align(
                  alignment: Alignment.centerRight,
                  child: Text('02:21:52', style: SmartNotesTheme.tiny),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: const BoxDecoration(border: Border(top: BorderSide(color: SmartNotesTheme.border))),
            child: Row(
              children: [
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 2),
                    decoration: BoxDecoration(color: SmartNotesTheme.bgSecondary, borderRadius: BorderRadius.circular(SmartNotesTheme.radiusMedium), border: Border.all(color: SmartNotesTheme.border)),
                    child: const TextField(
                      style: SmartNotesTheme.body,
                      decoration: InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: TextStyle(color: SmartNotesTheme.textMuted),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey[400], borderRadius: BorderRadius.circular(SmartNotesTheme.radiusMedium)),
                  child: const Icon(Icons.send, color: SmartNotesTheme.iconDark, size: 18),
                )
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildActionBtn(String title, IconData icon) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(color: SmartNotesTheme.bgSecondary, borderRadius: BorderRadius.circular(SmartNotesTheme.radiusMedium), border: Border.all(color: SmartNotesTheme.border)),
      child: Column(
        children: [
          Icon(icon, color: SmartNotesTheme.iconActive, size: 18),
          const SizedBox(height: 8),
          Text(title, textAlign: TextAlign.center, style: SmartNotesTheme.tiny.copyWith(color: SmartNotesTheme.textMain)),
        ],
      ),
    );
  }

  Widget _buildSuggestion(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 34),
      child: Row(
        children: [
          const Icon(Icons.auto_awesome, color: SmartNotesTheme.iconActive, size: 14),
          const SizedBox(width: 8),
          Expanded(child: Text(text, style: SmartNotesTheme.bodySmall)),
        ],
      ),
    );
  }
}
