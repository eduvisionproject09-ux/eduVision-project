import 'package:academic_project/domain/note.dart';
import 'package:academic_project/domain/resource.dart';
import 'package:academic_project/presentation/notes/provider/notes_provider.dart';
import 'package:academic_project/data/resource_remote_data_source.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';

class NoteDetailPage extends ConsumerStatefulWidget {
  final Note note;

  const NoteDetailPage({super.key, required this.note});

  @override
  ConsumerState<NoteDetailPage> createState() => _NoteDetailPageState();
}

class _NoteDetailPageState extends ConsumerState<NoteDetailPage> {
  final ResourceRemoteDataSource _resourceSource = ResourceRemoteDataSource();

  late TextEditingController _contentController;
  late TextEditingController _subjectController;
  late TextEditingController _topicController;
  bool _isEditing = false;
  bool _isLoading = false;

  late Note _currentNote;

  @override
  void initState() {
    super.initState();
    _currentNote = widget.note;
    _contentController = TextEditingController(text: _currentNote.content);
    _subjectController = TextEditingController(text: _currentNote.subject);
    _topicController = TextEditingController(text: _currentNote.topic);
  }

  @override
  void dispose() {
    _contentController.dispose();
    _subjectController.dispose();
    _topicController.dispose();
    super.dispose();
  }

  Future<void> _saveNote() async {
    setState(() => _isLoading = true);
    await ref
        .read(notesProvider.notifier)
        .updateNote(
          _currentNote.id,
          _contentController.text,
          _subjectController.text,
          _topicController.text,
        );
    // After update, we need to refresh the local state.
    // The provider already fetches notes, we can just find it again.
    final updatedNotes = ref.read(notesProvider).value;
    if (updatedNotes != null) {
      final updated = updatedNotes.firstWhere(
        (n) => n.id == _currentNote.id,
        orElse: () => _currentNote,
      );
      setState(() {
        _currentNote = updated;
        _isEditing = false;
      });
    }
    setState(() => _isLoading = false);
  }

  Future<void> _refreshNote() async {
    await ref.read(notesProvider.notifier).fetchNotes();
    final updatedNotes = ref.read(notesProvider).value;
    if (updatedNotes != null) {
      setState(() {
        _currentNote = updatedNotes.firstWhere(
          (n) => n.id == _currentNote.id,
          orElse: () => _currentNote,
        );
      });
    }
  }

  void _showAddResourceDialog() {
    showDialog(
      context: context,
      builder: (context) => AddResourceDialog(
        noteId: _currentNote.id,
        dataSource: _resourceSource,
        onSuccess: _refreshNote,
      ),
    );
  }

  Future<void> _deleteResource(int resourceId) async {
    try {
      await _resourceSource.deleteResource(resourceId);
      await _refreshNote();
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Resource deleted')));
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error deleting resource: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final isDesktop = size.width > 900;

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A0A), // Deep dark background
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white70),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          _currentNote.topic.isEmpty ? 'Note Details' : _currentNote.topic,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          if (!_isEditing)
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.white70),
              onPressed: () => setState(() => _isEditing = true),
            )
          else
            IconButton(
              icon: _isLoading
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.save, color: Colors.greenAccent),
              onPressed: _isLoading ? null : _saveNote,
            ),
        ],
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          Widget content = isDesktop
              ? Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(flex: 3, child: _buildNoteSection()),
                    const VerticalDivider(width: 1, color: Colors.white10),
                    Expanded(flex: 2, child: _buildResourcesSection()),
                  ],
                )
              : ListView(
                  children: [
                    _buildNoteSection(),
                    const Divider(height: 1, color: Colors.white10),
                    _buildResourcesSection(),
                  ],
                );

          return Padding(padding: const EdgeInsets.all(16.0), child: content);
        },
      ),
      floatingActionButton:
          FloatingActionButton.extended(
            onPressed: _showAddResourceDialog,
            backgroundColor: Colors.indigoAccent,
            icon: const Icon(Icons.add),
            label: const Text("Add Resource"),
          ).animate().slideY(
            begin: 1,
            end: 0,
            duration: 400.ms,
            curve: Curves.easeOut,
          ),
    );
  }

  Widget _buildNoteSection() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Subject",
            style: GoogleFonts.inter(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _isEditing
              ? TextField(
                  controller: _subjectController,
                  style: GoogleFonts.inter(color: Colors.white, fontSize: 18),
                  decoration: _inputDecoration("Enter subject"),
                )
              : Text(
                  _currentNote.subject.isEmpty
                      ? "No subject"
                      : _currentNote.subject,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                ),
          const SizedBox(height: 24),
          Text(
            "Topic",
            style: GoogleFonts.inter(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          _isEditing
              ? TextField(
                  controller: _topicController,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: _inputDecoration("Enter topic"),
                )
              : Text(
                  _currentNote.topic.isEmpty ? "No topic" : _currentNote.topic,
                  style: GoogleFonts.inter(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
          const SizedBox(height: 32),
          Text(
            "Content",
            style: GoogleFonts.inter(
              color: Colors.white54,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _isEditing
              ? TextField(
                  controller: _contentController,
                  maxLines: null,
                  style: GoogleFonts.inter(
                    color: Colors.white70,
                    fontSize: 16,
                    height: 1.6,
                  ),
                  decoration: _inputDecoration("Write your note here...")
                      .copyWith(
                        fillColor: Colors.white.withOpacity(0.05),
                        filled: true,
                      ),
                )
              : Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.03),
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: Colors.white10),
                  ),
                  child: Text(
                    _currentNote.content.isEmpty
                        ? "Start writing..."
                        : _currentNote.content,
                    style: GoogleFonts.inter(
                      color: Colors.white70,
                      fontSize: 16,
                      height: 1.6,
                    ),
                  ),
                ),
        ],
      ),
    ).animate().fadeIn(duration: 500.ms);
  }

  Widget _buildResourcesSection() {
    return Container(
      color: Colors.transparent,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.folder_open, color: Colors.indigoAccent),
              const SizedBox(width: 8),
              Text(
                "Study Resources",
                style: GoogleFonts.outfit(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: Colors.indigoAccent.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  "${_currentNote.resources.length}",
                  style: GoogleFonts.inter(
                    color: Colors.indigoAccent,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          if (_currentNote.resources.isEmpty)
            Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 40),
                child: Column(
                  children: [
                    Icon(Icons.inbox, color: Colors.white24, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      "No resources yet.",
                      style: GoogleFonts.inter(color: Colors.white54),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "Add links, PDFs, or videos to enrich your notes.",
                      textAlign: TextAlign.center,
                      style: GoogleFonts.inter(
                        color: Colors.white38,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            )
          else
            Expanded(
              child: ListView.builder(
                itemCount: _currentNote.resources.length,
                itemBuilder: (context, index) {
                  final res = _currentNote.resources[index];
                  return _buildResourceCard(res);
                },
              ),
            ),
        ],
      ),
    ).animate().slideX(begin: 0.1, duration: 400.ms).fadeIn();
  }

  Widget _buildResourceCard(Resource res) {
    IconData icon;
    Color iconColor;

    switch (res.type) {
      case ResourceType.YOUTUBE:
      case ResourceType.VIDEO:
        icon = Icons.play_circle_fill;
        iconColor = Colors.redAccent;
        break;
      case ResourceType.PDF:
      case ResourceType.FILE:
        icon = Icons.picture_as_pdf;
        iconColor = Colors.orangeAccent;
        break;
      case ResourceType.IMAGE:
        icon = Icons.image;
        iconColor = Colors.purpleAccent;
        break;
      default:
        icon = Icons.link;
        iconColor = Colors.lightBlueAccent;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white10),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: iconColor.withOpacity(0.2),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: iconColor, size: 28),
        ),
        title: Text(
          res.title,
          style: GoogleFonts.inter(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 16,
          ),
        ),
        subtitle: res.description != null && res.description!.isNotEmpty
            ? Text(
                res.description!,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: GoogleFonts.inter(color: Colors.white54, fontSize: 12),
              )
            : null,
        trailing: PopupMenuButton<String>(
          icon: const Icon(Icons.more_vert, color: Colors.white70),
          color: const Color(0xFF1E1E1E),
          itemBuilder: (context) => [
            const PopupMenuItem(
              value: 'open',
              child: Text(
                'Open Resource',
                style: TextStyle(color: Colors.white),
              ),
            ),
            const PopupMenuItem(
              value: 'delete',
              child: Text('Delete', style: TextStyle(color: Colors.redAccent)),
            ),
          ],
          onSelected: (value) {
            if (value == 'open') {
              _launchUrl(res.resourceUrl);
            } else if (value == 'delete') {
              _deleteResource(res.id);
            }
          },
        ),
        onTap: () => _launchUrl(res.resourceUrl),
      ),
    );
  }

  Future<void> _launchUrl(String urlString) async {
    // In a real app, you might want to differentiate between local files and web URLs.
    // Since the backend saves local paths for uploads (like "uploads/file.pdf"),
    // url_launcher might not directly open local files on web/desktop without a full server URL.
    // For now, we try to launch it directly.
    try {
      // If it's an uploaded file, we prepend the backend URL.
      final fullUrl = urlString.startsWith('http')
          ? urlString
          : 'http://localhost:8080/$urlString';
      final Uri url = Uri.parse(fullUrl);
      if (!await launchUrl(url)) {
        throw Exception('Could not launch $url');
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Could not open link: $e')));
      }
    }
  }

  InputDecoration _inputDecoration(String hint) {
    return InputDecoration(
      hintText: hint,
      hintStyle: GoogleFonts.inter(color: Colors.white24),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide.none,
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Colors.indigoAccent),
      ),
    );
  }
}

class AddResourceDialog extends StatefulWidget {
  final int noteId;
  final ResourceRemoteDataSource dataSource;
  final VoidCallback onSuccess;

  const AddResourceDialog({
    super.key,
    required this.noteId,
    required this.dataSource,
    required this.onSuccess,
  });

  @override
  State<AddResourceDialog> createState() => _AddResourceDialogState();
}

class _AddResourceDialogState extends State<AddResourceDialog> {
  bool _isLink = true;
  bool _isLoading = false;
  final _titleController = TextEditingController();
  final _descController = TextEditingController();
  final _urlController = TextEditingController();

  PlatformFile? _selectedFile;

  Future<void> _pickFile() async {
    final result = await FilePicker.pickFiles();
    if (result != null) {
      setState(() {
        _selectedFile = result.files.first;
      });
    }
  }

  Future<void> _submit() async {
    if (_titleController.text.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Title is required')));
      return;
    }

    setState(() => _isLoading = true);
    try {
      if (_isLink) {
        await widget.dataSource.addLink(
          _titleController.text,
          _descController.text,
          _urlController.text,
          _urlController.text.contains('youtube.com') ||
                  _urlController.text.contains('youtu.be')
              ? 'YOUTUBE'
              : 'LINK',
          widget.noteId,
        );
      } else {
        if (_selectedFile == null || _selectedFile!.bytes == null) {
          throw Exception("Please select a file.");
        }
        String type = 'FILE';
        final ext = _selectedFile!.extension?.toLowerCase();
        if (ext == 'pdf')
          type = 'PDF';
        else if (['png', 'jpg', 'jpeg', 'gif'].contains(ext))
          type = 'IMAGE';
        else if (['mp4', 'avi', 'mov'].contains(ext))
          type = 'VIDEO';

        await widget.dataSource.uploadFile(
          _titleController.text,
          _descController.text,
          _selectedFile!.bytes!,
          _selectedFile!.name,
          type,
          widget.noteId,
        );
      }
      widget.onSuccess();
      if (mounted) Navigator.of(context).pop();
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('Error adding resource: $e')));
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: const Color(0xFF1A1A1A),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      title: Text(
        "Add Resource",
        style: GoogleFonts.outfit(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
      content: SizedBox(
        width: 400,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ChoiceChip(
                    label: const Text('Add Link'),
                    selected: _isLink,
                    onSelected: (val) => setState(() => _isLink = true),
                    selectedColor: Colors.indigoAccent,
                    backgroundColor: Colors.white10,
                    labelStyle: TextStyle(
                      color: _isLink ? Colors.white : Colors.white54,
                    ),
                  ),
                  const SizedBox(width: 16),
                  ChoiceChip(
                    label: const Text('Upload File'),
                    selected: !_isLink,
                    onSelected: (val) => setState(() => _isLink = false),
                    selectedColor: Colors.indigoAccent,
                    backgroundColor: Colors.white10,
                    labelStyle: TextStyle(
                      color: !_isLink ? Colors.white : Colors.white54,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              TextField(
                controller: _titleController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Title',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _descController,
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  labelText: 'Description (optional)',
                  labelStyle: const TextStyle(color: Colors.white54),
                  filled: true,
                  fillColor: Colors.white.withOpacity(0.05),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              if (_isLink)
                TextField(
                  controller: _urlController,
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: 'URL (e.g. YouTube, Article)',
                    labelStyle: const TextStyle(color: Colors.white54),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                  ),
                )
              else
                InkWell(
                  onTap: _pickFile,
                  child: Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.05),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: Colors.white24,
                        style: BorderStyle.solid,
                      ),
                    ),
                    child: Column(
                      children: [
                        const Icon(
                          Icons.upload_file,
                          color: Colors.indigoAccent,
                          size: 40,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          _selectedFile != null
                              ? _selectedFile!.name
                              : 'Click to select a file',
                          style: const TextStyle(color: Colors.white70),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cancel', style: TextStyle(color: Colors.white54)),
        ),
        ElevatedButton(
          onPressed: _isLoading ? null : _submit,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.indigoAccent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: _isLoading
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Text('Save Resource'),
        ),
      ],
    );
  }
}
