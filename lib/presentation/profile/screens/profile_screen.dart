import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import '../../theme/app_constants.dart';
import '../models/profile_models.dart';
import '../provider/profile_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileState = ref.watch(profileProvider);

    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            AppColors.gradientStart,
            AppColors.gradientMiddle,
            AppColors.gradientEnd,
          ],
        ),
      ),
      child: profileState.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (err, stack) => Center(child: Text('Error: $err')),
        data: (profile) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 896),
                child: Stack(
                  children: [
                    // Main content
                    Container(
                      margin: const EdgeInsets.only(left: 32),
                      decoration: BoxDecoration(
                        color: AppColors.white,
                        borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(AppRadius.lg),
                          bottomRight: Radius.circular(AppRadius.lg),
                        ),
                      ),
                      child: Stack(
                        children: [
                          // Content
                          Padding(
                            padding: const EdgeInsets.all(AppSpacing.xxl),
                            child: Column(
                              children: [
                                // Profile Header
                                _buildProfileHeader(context, ref, profile),
                                const SizedBox(height: AppSpacing.xl),
                                Container(height: 1, color: AppColors.blue200),
                                const SizedBox(height: AppSpacing.xl),
                                // Contact Info
                                _buildContactInfo(context, ref, profile),
                                const SizedBox(height: AppSpacing.xl),
                                // Academic Progress (Results)
                                _buildAcademicResults(context, ref, profile),
                                const SizedBox(height: AppSpacing.xl),
                                // Achievements
                                _buildAchievements(context, ref, profile),
                                const SizedBox(height: AppSpacing.xl),
                                // Activities
                                _buildExtracurriculars(context, ref, profile),
                                const SizedBox(height: AppSpacing.xl),
                                // Schedule
                                _buildSchedule(context, ref, profile),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfileHeader(
    BuildContext context,
    WidgetRef ref,
    ProfileDto profile,
  ) {
    String name = profile.fullName ?? 'Set your name';
    String studentId = profile.studentId ?? 'Set your Student ID';
    String dept = profile.departmentName ?? 'Department';
    String year = profile.academicYear ?? 'Year';
    String rawImageUrl = profile.profileImageUrl ?? '';
    String finalImageUrl = rawImageUrl.isEmpty
        ? 'https://ui-avatars.com/api/?name=${profile.fullName ?? "User"}&background=818CF8&color=fff&size=128'
        : (rawImageUrl.startsWith('http')
              ? rawImageUrl
              : 'http://localhost:8080$rawImageUrl');

    return Stack(
      alignment: Alignment.center,
      children: [
        Column(
          children: [
            GestureDetector(
              onTap: () async {
                final ImagePicker picker = ImagePicker();
                final XFile? image = await picker.pickImage(
                  source: ImageSource.gallery,
                );
                if (image != null) {
                  final bytes = await image.readAsBytes();
                  ref
                      .read(profileProvider.notifier)
                      .uploadProfileImage(bytes, image.name);
                }
              },
              child: Stack(
                children: [
                  Container(
                    width: 128,
                    height: 128,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.white, width: 4),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                      image: DecorationImage(
                        image: NetworkImage(finalImageUrl),
                        fit: BoxFit.cover,
                        onError: (exception, stackTrace) {
                          debugPrint('Error loading profile image: $exception');
                        },
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.blue600,
                        shape: BoxShape.circle,
                        border: Border.all(color: AppColors.white, width: 4),
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 16,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  name,
                  style: AppTextStyles.studentTitle.copyWith(
                    color: AppColors.blue900,
                  ),
                  textAlign: TextAlign.center,
                ),
                IconButton(
                  icon: const Icon(
                    Icons.edit,
                    size: 20,
                    color: AppColors.gray500,
                  ),
                  onPressed: () =>
                      _showEditBasicInfoDialog(context, ref, profile),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.school, size: 16, color: AppColors.indigo600),
                const SizedBox(width: AppSpacing.sm),
                Text(
                  studentId,
                  style: const TextStyle(
                    color: AppColors.indigo600,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.sm,
              runSpacing: AppSpacing.sm,
              alignment: WrapAlignment.center,
              children: [
                _buildBadge(dept, AppColors.blue100, AppColors.blue800),
                _buildBadge(year, AppColors.blue100, AppColors.blue800),
              ],
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildContactInfo(
    BuildContext context,
    WidgetRef ref,
    ProfileDto profile,
  ) {
    return _buildInfoCard(
      title: 'Contact Information',
      icon: Icons.contact_mail,
      gradientColors: const [AppColors.blue50, AppColors.indigo50],
      borderColor: AppColors.blue200,
      titleColor: AppColors.blue900,
      onEdit: () => _showEditBasicInfoDialog(context, ref, profile),
      child: _buildInfoRow(
        Icons.info_outline,
        profile.contactInformation ?? 'Add contact info',
      ),
    );
  }

  Widget _buildAcademicResults(
    BuildContext context,
    WidgetRef ref,
    ProfileDto profile,
  ) {
    return _buildInfoCard(
      title: 'Academic Results',
      icon: Icons.menu_book,
      gradientColors: const [AppColors.green50, AppColors.emerald50],
      borderColor: AppColors.green200,
      titleColor: AppColors.green900,
      onEdit: () => _showAddAcademicResultDialog(context, ref, profile),
      child: Column(
        children: profile.academicResults.isEmpty
            ? [const Text('No academic results added.')]
            : profile.academicResults.map((result) {
                return Padding(
                  padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Level : ${result.level} - Term : ${result.term}',
                        style: AppTextStyles.bodyMedium.copyWith(
                          color: AppColors.green800,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: AppSpacing.sm,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: AppColors.green400),
                          borderRadius: BorderRadius.circular(AppRadius.sm),
                        ),
                        child: Text(
                          result.gpa ?? 'N/A',
                          style: AppTextStyles.small.copyWith(
                            color: AppColors.green700,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }).toList(),
      ),
    );
  }

  Widget _buildAchievements(
    BuildContext context,
    WidgetRef ref,
    ProfileDto profile,
  ) {
    return _buildInfoCard(
      title: 'Achievements',
      icon: Icons.emoji_events,
      gradientColors: const [Color(0xFFFFFBEB), Color(0xFFFFF7ED)],
      borderColor: const Color(0xFFFDE68A),
      titleColor: const Color(0xFF92400E),
      onEdit: () => _showAddAchievementDialog(context, ref, profile),
      child: profile.achievements.isEmpty
          ? _buildEmptyState(
              'No achievements yet',
              'Add your awards, honours, and certifications.',
            )
          : Column(
              children: profile.achievements.asMap().entries.map((entry) {
                final i = entry.key;
                final ach = entry.value;
                return _buildAchievementRow(
                  ach.title ?? '',
                  ach.description ?? '',
                  i,
                );
              }).toList(),
            ),
    );
  }

  Widget _buildExtracurriculars(
    BuildContext context,
    WidgetRef ref,
    ProfileDto profile,
  ) {
    return _buildInfoCard(
      title: 'Extracurricular Activities',
      icon: Icons.star,
      gradientColors: const [Color(0xFFF5F3FF), Color(0xFFFDF2F8)],
      borderColor: const Color(0xFFDDD6FE),
      titleColor: const Color(0xFF5B21B6),
      onEdit: () => _showAddExtracurricularDialog(context, ref, profile),
      child: profile.extracurricularActivities.isEmpty
          ? _buildEmptyState(
              'No activities yet',
              'Add clubs, sports, volunteering, or other activities.',
            )
          : Column(
              children: profile.extracurricularActivities.map((act) {
                return _buildActivityRow(
                  act.activityName ?? 'Untitled',
                  act.role ?? 'Member',
                );
              }).toList(),
            ),
    );
  }

  Widget _buildSchedule(
    BuildContext context,
    WidgetRef ref,
    ProfileDto profile,
  ) {
    return _buildInfoCard(
      title: "Today's Schedule",
      icon: Icons.access_time,
      gradientColors: const [Color(0xFFEFF6FF), Color(0xFFEEF2FF)],
      borderColor: const Color(0xFFBFDBFE),
      titleColor: const Color(0xFF1E3A5F),
      onEdit: () => _showAddScheduleDialog(context, ref, profile),
      child: profile.scheduleItems.isEmpty
          ? _buildEmptyState(
              'No schedule yet',
              'Add your classes, lab sessions, and appointments.',
            )
          : Column(
              children: profile.scheduleItems.map((sch) {
                return _buildScheduleItemRow(
                  sch.time ?? '',
                  sch.courseName ?? '',
                );
              }).toList(),
            ),
    );
  }

  // Helper UI Builders
  Widget _buildBadge(String text, Color bgColor, Color textColor) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.xs,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.full),
      ),
      child: Text(
        text,
        style: AppTextStyles.small.copyWith(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildInfoCard({
    required String title,
    required IconData icon,
    required List<Color> gradientColors,
    required Color borderColor,
    required Color titleColor,
    required Widget child,
    VoidCallback? onEdit,
  }) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        gradient: LinearGradient(colors: gradientColors),
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Icon(icon, size: 20, color: titleColor),
                  const SizedBox(width: AppSpacing.sm),
                  Text(
                    title,
                    style: AppTextStyles.subsectionHeading.copyWith(
                      color: titleColor,
                    ),
                  ),
                ],
              ),
              if (onEdit != null)
                IconButton(
                  icon: Icon(Icons.edit, size: 20, color: titleColor),
                  onPressed: onEdit,
                ),
            ],
          ),
          const SizedBox(height: AppSpacing.sm),
          child,
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.blue600),
        const SizedBox(width: AppSpacing.sm),
        Expanded(child: Text(text, style: AppTextStyles.small)),
      ],
    );
  }

  Widget _buildEmptyState(String title, String subtitle) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
      child: Row(
        children: [
          Icon(Icons.add_circle_outline, color: AppColors.gray400, size: 28),
          const SizedBox(width: AppSpacing.md),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: AppTextStyles.bodyMedium.copyWith(
                  color: AppColors.gray500,
                  fontWeight: FontWeight.w600,
                ),
              ),
              Text(
                subtitle,
                style: AppTextStyles.small.copyWith(color: AppColors.gray400),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildAchievementRow(String title, String desc, int index) {
    final colors = [
      const Color(0xFFDC2626),
      const Color(0xFFD97706),
      const Color(0xFF059669),
      AppColors.indigo600,
      const Color(0xFF7C3AED),
    ];
    final color = colors[index % colors.length];
    final medals = ['🥇', '🥈', '🥉', '🏅', '⭐'];
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color.withOpacity(0.08),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: Center(
              child: Text(
                medals[index % medals.length],
                style: const TextStyle(fontSize: 20),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gray900,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                if (desc.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    desc,
                    style: AppTextStyles.small.copyWith(
                      color: AppColors.gray500,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Text(
              'Achievement',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: color,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(String activityName, String role) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 12,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: const Color(0xFFDDD6FE)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.person_pin_outlined,
              color: Color(0xFF7C3AED),
              size: 16,
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  activityName,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.gray900,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                Text(
                  role,
                  style: AppTextStyles.small.copyWith(color: AppColors.gray500),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
            decoration: BoxDecoration(
              color: const Color(0xFFEDE9FE),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Text(
              'Activity',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF7C3AED),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItemRow(String time, String subject) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: 10,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFFEFF6FF),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              time,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                color: Color(0xFF1D4ED8),
                fontFamily: 'monospace',
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Text(
              subject,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.gray800,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Icon(Icons.chevron_right, color: AppColors.gray400, size: 18),
        ],
      ),
    );
  }

  // Dialogs
  void _showEditBasicInfoDialog(
    BuildContext context,
    WidgetRef ref,
    ProfileDto profile,
  ) {
    final nameCtrl = TextEditingController(text: profile.fullName);
    final idCtrl = TextEditingController(text: profile.studentId);
    final deptCtrl = TextEditingController(text: profile.departmentName);
    final yearCtrl = TextEditingController(text: profile.academicYear);
    final contactCtrl = TextEditingController(text: profile.contactInformation);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Edit Profile'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(labelText: 'Full Name'),
              ),
              TextField(
                controller: idCtrl,
                decoration: const InputDecoration(labelText: 'Student ID'),
              ),
              TextField(
                controller: deptCtrl,
                decoration: const InputDecoration(labelText: 'Department'),
              ),
              TextField(
                controller: yearCtrl,
                decoration: const InputDecoration(labelText: 'Year'),
              ),
              TextField(
                controller: contactCtrl,
                decoration: const InputDecoration(labelText: 'Contact Info'),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final newProfile = profile.copyWith(
                fullName: nameCtrl.text,
                studentId: idCtrl.text,
                departmentName: deptCtrl.text,
                academicYear: yearCtrl.text,
                contactInformation: contactCtrl.text,
              );
              ref.read(profileProvider.notifier).updateProfile(newProfile);
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddAcademicResultDialog(
    BuildContext context,
    WidgetRef ref,
    ProfileDto profile,
  ) {
    final levelCtrl = TextEditingController();
    final termCtrl = TextEditingController();
    final gpaCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Academic Result'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: levelCtrl,
              decoration: const InputDecoration(labelText: 'Level (e.g. 1)'),
            ),
            TextField(
              controller: termCtrl,
              decoration: const InputDecoration(labelText: 'Term (e.g. 1)'),
            ),
            TextField(
              controller: gpaCtrl,
              decoration: const InputDecoration(
                labelText: 'GPA (e.g. 3.61/4.00)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final results =
                  List<AcademicResultDto>.from(profile.academicResults)..add(
                    AcademicResultDto(
                      level: levelCtrl.text,
                      term: termCtrl.text,
                      gpa: gpaCtrl.text,
                    ),
                  );
              ref
                  .read(profileProvider.notifier)
                  .updateProfile(profile.copyWith(academicResults: results));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddAchievementDialog(
    BuildContext context,
    WidgetRef ref,
    ProfileDto profile,
  ) {
    final titleCtrl = TextEditingController();
    final descCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Achievement'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleCtrl,
              decoration: const InputDecoration(labelText: 'Title'),
            ),
            TextField(
              controller: descCtrl,
              decoration: const InputDecoration(labelText: 'Description/Date'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final ach = List<AchievementDto>.from(profile.achievements)
                ..add(
                  AchievementDto(
                    title: titleCtrl.text,
                    description: descCtrl.text,
                  ),
                );
              ref
                  .read(profileProvider.notifier)
                  .updateProfile(profile.copyWith(achievements: ach));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddExtracurricularDialog(
    BuildContext context,
    WidgetRef ref,
    ProfileDto profile,
  ) {
    final nameCtrl = TextEditingController();
    final roleCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Extracurricular'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: nameCtrl,
              decoration: const InputDecoration(labelText: 'Activity Name'),
            ),
            TextField(
              controller: roleCtrl,
              decoration: const InputDecoration(labelText: 'Role'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final acts =
                  List<ExtracurricularDto>.from(
                    profile.extracurricularActivities,
                  )..add(
                    ExtracurricularDto(
                      activityName: nameCtrl.text,
                      role: roleCtrl.text,
                    ),
                  );
              ref
                  .read(profileProvider.notifier)
                  .updateProfile(
                    profile.copyWith(extracurricularActivities: acts),
                  );
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }

  void _showAddScheduleDialog(
    BuildContext context,
    WidgetRef ref,
    ProfileDto profile,
  ) {
    final courseCtrl = TextEditingController();
    final timeCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Add Schedule Item'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: courseCtrl,
              decoration: const InputDecoration(labelText: 'Course/Event Name'),
            ),
            TextField(
              controller: timeCtrl,
              decoration: const InputDecoration(
                labelText: 'Time (e.g. 10:00 - 11:30)',
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              final schedules =
                  List<ScheduleItemDto>.from(profile.scheduleItems)..add(
                    ScheduleItemDto(
                      courseName: courseCtrl.text,
                      time: timeCtrl.text,
                    ),
                  );
              ref
                  .read(profileProvider.notifier)
                  .updateProfile(profile.copyWith(scheduleItems: schedules));
              Navigator.pop(context);
            },
            child: const Text('Save'),
          ),
        ],
      ),
    );
  }
}
