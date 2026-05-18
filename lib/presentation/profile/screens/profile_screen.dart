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
      gradientColors: const [AppColors.yellow50, AppColors.orange50],
      borderColor: AppColors.yellow200,
      titleColor: AppColors.orange900,
      onEdit: () => _showAddAchievementDialog(context, ref, profile),
      child: Column(
        children: profile.achievements.isEmpty
            ? [const Text('No achievements added.')]
            : profile.achievements.map((ach) {
                return _buildAchievementRow(
                  ach.title ?? '',
                  ach.description ?? '',
                  Icons.emoji_events,
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
      gradientColors: const [AppColors.purple50, AppColors.pink50],
      borderColor: AppColors.purple200,
      titleColor: AppColors.purple900,
      onEdit: () => _showAddExtracurricularDialog(context, ref, profile),
      child: Column(
        children: profile.extracurricularActivities.isEmpty
            ? [const Text('No activities added.')]
            : profile.extracurricularActivities.map((act) {
                return _buildActivityRow(
                  'Activity Name : ${act.activityName} - Role : ${act.role}',
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
      gradientColors: const [AppColors.indigo50, AppColors.blue50],
      borderColor: AppColors.indigo200,
      titleColor: AppColors.indigo900,
      onEdit: () => _showAddScheduleDialog(context, ref, profile),
      child: Column(
        children: profile.scheduleItems.isEmpty
            ? [const Text('No schedule added.')]
            : profile.scheduleItems.map((sch) {
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

  Widget _buildAchievementRow(String title, String desc, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.md),
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.yellow200),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(AppSpacing.sm),
            decoration: const BoxDecoration(
              color: AppColors.yellow100,
              shape: BoxShape.circle,
            ),
            child: Icon(icon, size: 16, color: AppColors.yellow600),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.orange800,
                  ),
                ),
                Text(
                  desc,
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.orange600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActivityRow(String text) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.purple200),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.purple400,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              text,
              style: AppTextStyles.small.copyWith(color: AppColors.purple800),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildScheduleItemRow(String time, String subject) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.sm),
      padding: const EdgeInsets.all(AppSpacing.sm),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: Border.all(color: AppColors.indigo200),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            time,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.indigo800,
            ),
          ),
          Text(
            subject,
            style: AppTextStyles.small.copyWith(color: AppColors.indigo600),
          ),
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
