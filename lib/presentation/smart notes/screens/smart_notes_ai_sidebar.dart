import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../domain/ai_response.dart';
import '../../theme/app_constants.dart';
import '../ai/provider/ai_provider.dart';
import '../provider/notes_provider.dart';

class SmartNotesAiSidebar extends ConsumerStatefulWidget {
  final VoidCallback? onClose;

  const SmartNotesAiSidebar({super.key, this.onClose});

  @override
  ConsumerState<SmartNotesAiSidebar> createState() => _SmartNotesAiSidebarState();
}

class _SmartNotesAiSidebarState extends ConsumerState<SmartNotesAiSidebar> {
  final TextEditingController _inputController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final List<_ChatMessage> _messages = [];

  @override
  void dispose() {
    _inputController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  final List<String> _styles = [
    'Academic',
    'Technical',
    'Short Answer',
    'Exam Standard',
    'Simple Word',
    'Creative',
    'Brainstorming'
  ];

  final List<String> _languages = [
    'English',
    'Bengali',
    'Spanish',
    'French',
    'German',
    'Hindi'
  ];

  Widget _buildModeBar() {
    final aiState = ref.watch(aiProvider);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: SmartNotesTheme.bgSecondary.withOpacity(0.5),
        border: const Border(bottom: BorderSide(color: SmartNotesTheme.border)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('Response Customization', style: TextStyle(
            color: SmartNotesTheme.textMuted,
            fontSize: 10,
            fontWeight: FontWeight.bold,
            letterSpacing: 1.1,
          )),
          const SizedBox(height: 8),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildDropdown(
                  icon: Icons.auto_awesome_outlined,
                  label: 'STYLE',
                  value: aiState.selectedStyle,
                  items: _styles,
                  onChanged: (val) => ref.read(aiProvider.notifier).setStyle(val!),
                ),
                const SizedBox(width: 8),
                _buildDropdown(
                  icon: Icons.translate,
                  label: 'LANG',
                  value: aiState.selectedLanguage,
                  items: _languages,
                  onChanged: (val) => ref.read(aiProvider.notifier).setLanguage(val!),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDropdown({
    required IconData icon,
    required String label,
    required String value,
    required List<String> items,
    required void Function(String?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
      decoration: BoxDecoration(
        color: SmartNotesTheme.bgMain,
        borderRadius: BorderRadius.circular(SmartNotesTheme.radiusMedium),
        border: Border.all(color: SmartNotesTheme.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 12, color: SmartNotesTheme.accentBlue),
          const SizedBox(width: 6),
          Text(
            "$label:",
            style: const TextStyle(
              color: SmartNotesTheme.textMuted,
              fontSize: 9,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(width: 4),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: value,
              
              isDense: true,
              icon: const Icon(Icons.keyboard_arrow_down, size: 14),
              style: const TextStyle(
                color: SmartNotesTheme.textMain,
                fontSize: 11,
                fontWeight: FontWeight.w600,
                fontFamily: 'Inter',
              ),
              dropdownColor: SmartNotesTheme.bgMain,
              items: items.map((String item) {
                return DropdownMenuItem<String>(
                  value: item,
                  child: Text(item),
                );
              }).toList(),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }

  void _sendMessage(String text) {
    if (text.trim().isEmpty) return;
    final aiState = ref.read(aiProvider);
    final currentStyle = aiState.selectedStyle;
    setState(() {
      _messages.add(_ChatMessage(text, isUser: true, style: currentStyle));
    });
    _inputController.clear();
    ref.read(aiProvider.notifier).askAi(text);
  }

  void _onSuggestionTap(String text) {
    _sendMessage(text);
  }

  @override
  Widget build(BuildContext context) {
    final aiState = ref.watch(aiProvider);

    ref.listen<AiState>(aiProvider, (prev, next) {
      if (next.response != null && next.response != prev?.response) {
        final displayText = next.response!.content.isNotEmpty
            ? next.response!.content
            : next.response!.academicDefinition;
        setState(() {
          _messages.add(_ChatMessage(
            displayText,
            isUser: false,
            style: next.selectedStyle,
            response: next.response,
          ));
        });
        Future.microtask(() {
          if (_scrollController.hasClients) {
            _scrollController.animateTo(
              _scrollController.position.maxScrollExtent,
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeOut,
            );
          }
        });
      }
      if (next.error != null && next.error != prev?.error) {
        setState(() {
          _messages.add(_ChatMessage(
            "Error: ${next.error}",
            isUser: false,
            isError: true,
          ));
        });
      }
    });

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
                GestureDetector(
                  onTap: widget.onClose,
                  child: const Icon(Icons.close, color: SmartNotesTheme.iconColor, size: 18),
                ),
              ],
            ),
          ),
          _buildModeBar(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Quick Actions:', style: SmartNotesTheme.bodySmall),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(child: _buildActionBtn('Organize Content', Icons.format_list_bulleted, () {
                      final activeNote = ref.read(activeNoteIdProvider);
                      _sendMessage(activeNote != null
                          ? 'Help me organize the content of this note'
                          : 'Help me organize my study content better');
                    })),
                    const SizedBox(width: 8),
                    Expanded(child: _buildActionBtn('Create Schedule', Icons.calendar_today, () {
                      _sendMessage('Create a daily study schedule for me');
                    })),
                  ],
                ),
                const SizedBox(height: 8),
                Row(
                  children: [
                    Expanded(child: _buildActionBtn('Plan Event', Icons.gps_fixed, () {
                      _sendMessage('Help me plan an academic event');
                    })),
                    const SizedBox(width: 8),
                    Expanded(child: _buildActionBtn('Implementation Ideas', Icons.lightbulb_outline, () {
                      _sendMessage('Give me implementation ideas for my project');
                    })),
                  ],
                ),
              ],
            ),
          ),
          const Divider(color: SmartNotesTheme.border, height: 1),
          Expanded(
            child: _messages.isEmpty
                ? ListView(
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
                      _buildSuggestion('Help me organize this note better', () => _onSuggestionTap('Help me organize this note better')),
                      _buildSuggestion('Create a daily schedule', () => _onSuggestionTap('Create a daily schedule')),
                      _buildSuggestion('Plan an event', () => _onSuggestionTap('Plan an event')),
                      _buildSuggestion('Brainstorm implementation ideas', () => _onSuggestionTap('Brainstorm implementation ideas')),
                    ],
                  )
                : ListView.builder(
                    controller: _scrollController,
                    padding: const EdgeInsets.all(16),
                    itemCount: _messages.length + (aiState.isLoading ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == _messages.length && aiState.isLoading) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12, left: 34),
                          child: Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: const BoxDecoration(color: SmartNotesTheme.accent, shape: BoxShape.circle),
                                child: const Icon(Icons.smart_toy, color: SmartNotesTheme.iconDark, size: 14),
                              ),
                              const SizedBox(width: 12),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                decoration: BoxDecoration(
                                  color: SmartNotesTheme.bgSecondary,
                                  borderRadius: BorderRadius.circular(SmartNotesTheme.radiusLarge),
                                  border: Border.all(color: SmartNotesTheme.border),
                                ),
                                child: const SizedBox(
                                  width: 16, height: 16,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                      final msg = _messages[index];
                      if (msg.isUser) {
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Container(
                              constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.6),
                              padding: const EdgeInsets.all(14),
                              decoration: BoxDecoration(
                                color: SmartNotesTheme.accentBlue.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(SmartNotesTheme.radiusLarge),
                              ),
                              child: Text(
                                msg.text,
                                style: const TextStyle(color: SmartNotesTheme.textMain, fontSize: 13),
                              ),
                            ),
                          ),
                        );
                      } else {
                        Color bubbleColor = msg.isError
                            ? const Color(0xFFFEE2E2)
                            : SmartNotesTheme.bgSecondary;
                        return Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(4),
                                decoration: BoxDecoration(
                                  color: msg.isError ? SmartNotesTheme.bgSecondary : SmartNotesTheme.accent,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(
                                  msg.isError ? Icons.error_outline : Icons.smart_toy,
                                  color: msg.isError ? Colors.red : SmartNotesTheme.iconDark,
                                  size: 14,
                                ),
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Container(
                                  padding: const EdgeInsets.all(14),
                                  decoration: BoxDecoration(
                                    color: bubbleColor,
                                    borderRadius: BorderRadius.circular(SmartNotesTheme.radiusLarge),
                                    border: msg.isError
                                        ? Border.all(color: Colors.red.shade200)
                                        : Border.all(color: SmartNotesTheme.border),
                                  ),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      if (msg.response != null) ...[
                                        Text(
                                          msg.response!.topic,
                                          style: const TextStyle(
                                            color: SmartNotesTheme.accentBlue,
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 8),
                                        Text(
                                          msg.text,
                                          style: const TextStyle(
                                            color: SmartNotesTheme.textMain,
                                            fontSize: 13,
                                            height: 1.5,
                                          ),
                                        ),
                                        if (msg.response!.academicDefinition.isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          _buildSection('Academic Definition', msg.response!.academicDefinition),
                                        ],
                                        if (msg.response!.simpleDefinition.isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          _buildSection('Simple Definition', msg.response!.simpleDefinition),
                                        ],
                                        if (msg.response!.examStandardDescription.isNotEmpty) ...[
                                          const SizedBox(height: 6),
                                          _buildSection('Exam Standard', msg.response!.examStandardDescription),
                                        ],
                                        if (msg.style != null)
                                          Padding(
                                            padding: const EdgeInsets.only(top: 8),
                                            child: Container(
                                              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                              decoration: BoxDecoration(
                                                color: SmartNotesTheme.accentBlue.withOpacity(0.1),
                                                borderRadius: BorderRadius.circular(4),
                                              ),
                                              child: Text(
                                                msg.style!,
                                                style: const TextStyle(
                                                  color: SmartNotesTheme.accentBlue,
                                                  fontSize: 9,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.5,
                                                ),
                                              ),
                                            ),
                                          ),
                                      ] else
                                        Text(
                                          msg.text,
                                          style: TextStyle(
                                            color: msg.isError ? Colors.red.shade800 : SmartNotesTheme.textMain,
                                            fontSize: 13,
                                            height: 1.4,
                                          ),
                                        ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      }
                    },
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
                    child: TextField(
                      controller: _inputController,
                      style: SmartNotesTheme.body,
                      decoration: const InputDecoration(
                        hintText: 'Ask me anything...',
                        hintStyle: TextStyle(color: SmartNotesTheme.textMuted),
                        border: InputBorder.none,
                      ),
                      onSubmitted: (val) => _sendMessage(val),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: () => _sendMessage(_inputController.text),
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: aiState.isLoading ? Colors.grey[400] : SmartNotesTheme.accentBlue,
                      borderRadius: BorderRadius.circular(SmartNotesTheme.radiusMedium),
                    ),
                    child: aiState.isLoading
                        ? const SizedBox(
                            width: 18, height: 18,
                            child: CircularProgressIndicator(strokeWidth: 2, color: SmartNotesTheme.iconDark),
                          )
                        : const Icon(Icons.send, color: Colors.white, size: 18),
                  ),
                ),
              ],
            ),
          )
        ],
      ),
    );
  }

  Widget _buildSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(
            color: SmartNotesTheme.textMuted,
            fontSize: 11,
            fontWeight: FontWeight.bold,
            letterSpacing: 0.5,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          content,
          style: const TextStyle(color: SmartNotesTheme.textMain, fontSize: 13, height: 1.4),
        ),
      ],
    );
  }

  Widget _buildActionBtn(String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        decoration: BoxDecoration(color: SmartNotesTheme.bgSecondary, borderRadius: BorderRadius.circular(SmartNotesTheme.radiusMedium), border: Border.all(color: SmartNotesTheme.border)),
        child: Column(
          children: [
            Icon(icon, color: SmartNotesTheme.iconActive, size: 18),
            const SizedBox(height: 8),
            Text(title, textAlign: TextAlign.center, style: SmartNotesTheme.tiny.copyWith(color: SmartNotesTheme.textMain)),
          ],
        ),
      ),
    );
  }

  Widget _buildSuggestion(String text, VoidCallback onTap) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12, left: 34),
      child: GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            const Icon(Icons.auto_awesome, color: SmartNotesTheme.iconActive, size: 14),
            const SizedBox(width: 8),
            Expanded(child: Text(text, style: SmartNotesTheme.bodySmall)),
          ],
        ),
      ),
    );
  }
}

class _ChatMessage {
  final String text;
  final bool isUser;
  final bool isError;
  final String? style;
  final AiResponse? response;

  _ChatMessage(this.text, {required this.isUser, this.style, this.response, this.isError = false});
}
