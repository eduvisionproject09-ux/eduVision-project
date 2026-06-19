import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../theme/app_constants.dart';
import '../provider/settings_provider.dart';

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settingsAsync = ref.watch(settingsProvider);

    return Container(
      color: AppColors.gray50,
      child: settingsAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error loading settings: $e')),
        data: (settings) => _SettingsContent(settings: settings),
      ),
    );
  }
}

class _SettingsContent extends ConsumerWidget {
  final dynamic settings;

  const _SettingsContent({required this.settings});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notifier = ref.read(settingsProvider.notifier);
    final isDark = settings.theme == 'dark';
    final isEnglish = settings.language == 'en';

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppSpacing.lg),
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page Header
              const SizedBox(height: AppSpacing.lg),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: AppColors.indigo600,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(Icons.settings, color: Colors.white, size: 22),
                  ),
                  const SizedBox(width: AppSpacing.md),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Settings',
                        style: AppTextStyles.sectionHeading.copyWith(
                          color: AppColors.gray900,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        'Manage your preferences',
                        style: AppTextStyles.small.copyWith(color: AppColors.gray500),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: AppSpacing.xl),

              // Appearance Section
              _buildSectionLabel('Appearance'),
              _buildCard([
                _buildSwitchTile(
                  icon: isDark ? Icons.dark_mode : Icons.light_mode,
                  iconColor: isDark ? const Color(0xFF7C3AED) : const Color(0xFFD97706),
                  title: 'Dark Mode',
                  subtitle: isDark ? 'Currently using dark theme' : 'Currently using light theme',
                  value: isDark,
                  onChanged: (val) => notifier.updateTheme(val ? 'dark' : 'light'),
                ),
              ]),

              const SizedBox(height: AppSpacing.lg),

              // Language Section
              _buildSectionLabel('Language & Region'),
              _buildCard([
                _buildLanguageTile(
                  isEnglish: isEnglish,
                  onChanged: (val) => notifier.updateLanguage(val ? 'en' : 'bn'),
                ),
              ]),

              const SizedBox(height: AppSpacing.lg),

              // Notifications Section
              _buildSectionLabel('Notifications'),
              _buildCard([
                _buildSwitchTile(
                  icon: Icons.email_outlined,
                  iconColor: AppColors.blue600,
                  title: 'Email Notifications',
                  subtitle: 'Receive updates and alerts via email',
                  value: settings.emailNotifications,
                  onChanged: (val) => notifier.toggleEmailNotifications(val),
                  hasDivider: true,
                ),
                _buildSwitchTile(
                  icon: Icons.notifications_outlined,
                  iconColor: const Color(0xFF059669),
                  title: 'Push Notifications',
                  subtitle: 'In-app alerts and reminders',
                  value: settings.pushNotifications,
                  onChanged: (val) => notifier.togglePushNotifications(val),
                ),
              ]),

              const SizedBox(height: AppSpacing.lg),

              // Account Section
              _buildSectionLabel('Account'),
              _buildCard([
                _buildNavTile(
                  icon: Icons.lock_outline,
                  iconColor: AppColors.gray600,
                  title: 'Change Password',
                  subtitle: 'Update your account password',
                  hasDivider: true,
                  onTap: () => _showChangePasswordDialog(context),
                ),
                _buildNavTile(
                  icon: Icons.person_outline,
                  iconColor: AppColors.gray600,
                  title: 'Edit Profile',
                  subtitle: 'Update your personal information',
                  hasDivider: true,
                  onTap: () => context.go('/profile'),
                ),
                _buildNavTile(
                  icon: Icons.logout,
                  iconColor: AppColors.red600,
                  title: 'Log Out',
                  subtitle: 'Sign out of your EduVision account',
                  titleColor: AppColors.red600,
                  onTap: () => _confirmLogout(context),
                ),
              ]),

              const SizedBox(height: AppSpacing.lg),

              // About Section
              _buildSectionLabel('About'),
              _buildCard([
                _buildNavTile(
                  icon: Icons.info_outline,
                  iconColor: AppColors.indigo600,
                  title: 'About EduVision',
                  subtitle: 'Learn more about this application',
                  hasDivider: true,
                  onTap: () => _showAboutDialog(context),
                ),
                _buildNavTile(
                  icon: Icons.shield_outlined,
                  iconColor: AppColors.indigo600,
                  title: 'Privacy Policy',
                  subtitle: 'Read our data handling practices',
                  hasDivider: true,
                  onTap: () => _showPrivacyDialog(context),
                ),
                _buildNavTile(
                  icon: Icons.article_outlined,
                  iconColor: AppColors.indigo600,
                  title: 'Terms of Service',
                  subtitle: 'Review your usage agreement',
                  onTap: () => _showTermsDialog(context),
                ),
              ]),

              const SizedBox(height: AppSpacing.lg),

              // Version info
              Center(
                child: Column(
                  children: [
                    Text(
                      'EduVision',
                      style: AppTextStyles.bodyMedium.copyWith(
                        color: AppColors.gray400,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      'Version 1.0.0  •  Academic Project 2026',
                      style: AppTextStyles.small.copyWith(color: AppColors.gray400),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: AppSpacing.xl),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm, left: 4),
      child: Text(
        label.toUpperCase(),
        style: const TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: AppColors.gray500,
          letterSpacing: 1.2,
        ),
      ),
    );
  }

  Widget _buildCard(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.gray200),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(children: children),
    );
  }

  Widget _buildSwitchTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
    bool hasDivider = false,
  }) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: iconColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppRadius.md),
                ),
                child: Icon(icon, color: iconColor, size: 20),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(title, style: AppTextStyles.bodyMedium.copyWith(color: AppColors.gray900, fontWeight: FontWeight.w600)),
                    Text(subtitle, style: AppTextStyles.small.copyWith(color: AppColors.gray500)),
                  ],
                ),
              ),
              Switch(
                value: value,
                onChanged: onChanged,
                activeColor: AppColors.indigo600,
              ),
            ],
          ),
        ),
        if (hasDivider)
          const Padding(
            padding: EdgeInsets.only(left: 68),
            child: Divider(height: 1, color: AppColors.gray100),
          ),
      ],
    );
  }

  Widget _buildLanguageTile({
    required bool isEnglish,
    required ValueChanged<bool> onChanged,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Container(
            width: 38,
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.blue600.withOpacity(0.1),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.language, color: AppColors.blue600, size: 20),
          ),
          const SizedBox(width: 14),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('Language', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.gray900)),
                Text('Select your preferred language', style: TextStyle(fontSize: 12, color: AppColors.gray500)),
              ],
            ),
          ),
          Row(
            children: [
              _langChip('EN', isEnglish, () => onChanged(true)),
              const SizedBox(width: 8),
              _langChip('বাং', !isEnglish, () => onChanged(false)),
            ],
          ),
        ],
      ),
    );
  }

  Widget _langChip(String label, bool active, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: active ? AppColors.indigo600 : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: active ? AppColors.indigo600 : AppColors.gray200),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: active ? Colors.white : AppColors.gray600,
            fontWeight: FontWeight.w600,
            fontSize: 13,
          ),
        ),
      ),
    );
  }

  Widget _buildNavTile({
    required IconData icon,
    required Color iconColor,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
    bool hasDivider = false,
    Color? titleColor,
  }) {
    return Column(
      children: [
        InkWell(
          onTap: onTap,
          borderRadius: hasDivider ? BorderRadius.zero : BorderRadius.circular(AppRadius.lg),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: [
                Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: iconColor.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: Icon(icon, color: iconColor, size: 20),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(title, style: AppTextStyles.bodyMedium.copyWith(color: titleColor ?? AppColors.gray900, fontWeight: FontWeight.w600)),
                      Text(subtitle, style: AppTextStyles.small.copyWith(color: AppColors.gray500)),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right, color: AppColors.gray400, size: 20),
              ],
            ),
          ),
        ),
        if (hasDivider)
          const Padding(
            padding: EdgeInsets.only(left: 68),
            child: Divider(height: 1, color: AppColors.gray100),
          ),
      ],
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.red50, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.logout, color: AppColors.red600, size: 20),
            ),
            const SizedBox(width: 12),
            const Text('Log Out', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Text(
          'Are you sure you want to log out of your EduVision account?',
          style: TextStyle(color: AppColors.gray600),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Cancel', style: TextStyle(color: AppColors.gray500)),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.red600,
              foregroundColor: Colors.white,
              minimumSize: const Size(80, 40),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            ),
            onPressed: () async {
              Navigator.pop(ctx);
              const FlutterSecureStorage().delete(key: 'jwt');
              if (context.mounted) context.go('/login');
            },
            child: const Text('Log Out'),
          ),
        ],
      ),
    );
  }

  void _showChangePasswordDialog(BuildContext context) {
    final currentCtrl = TextEditingController();
    final newCtrl = TextEditingController();
    final confirmCtrl = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Text('Change Password', style: TextStyle(fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: currentCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Current Password', prefixIcon: Icon(Icons.lock_outline)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: newCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'New Password', prefixIcon: Icon(Icons.lock_reset)),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: confirmCtrl,
              obscureText: true,
              decoration: const InputDecoration(labelText: 'Confirm New Password', prefixIcon: Icon(Icons.check_circle_outline)),
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancel')),
          ElevatedButton(
            onPressed: () {
              // TODO: Wire to backend password change endpoint
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Password change coming soon!'), backgroundColor: AppColors.indigo600),
              );
            },
            child: const Text('Update'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(color: AppColors.indigo50, borderRadius: BorderRadius.circular(8)),
              child: const Icon(Icons.menu_book, color: AppColors.indigo600, size: 22),
            ),
            const SizedBox(width: 12),
            const Text('About EduVision', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
        content: const Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'EduVision is a comprehensive academic management platform designed to empower students with smart note-taking, progress tracking, and AI-powered learning tools.',
              style: TextStyle(color: AppColors.gray600, height: 1.5),
            ),
            SizedBox(height: 16),
            Text('Version: 1.0.0', style: TextStyle(fontWeight: FontWeight.w600, color: AppColors.gray700)),
            Text('Platform: Flutter (Web)', style: TextStyle(color: AppColors.gray500, fontSize: 13)),
            Text('Backend: Spring Boot 3.2', style: TextStyle(color: AppColors.gray500, fontSize: 13)),
            Text('Database: PostgreSQL (Supabase)', style: TextStyle(color: AppColors.gray500, fontSize: 13)),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Text('Privacy Policy', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const SingleChildScrollView(
          child: Text(
            'EduVision collects and processes only the data necessary to provide its academic services. Your notes, profile information, and academic records are stored securely and are never shared with third parties without your explicit consent.\n\nAll data is encrypted in transit (TLS) and at rest. You may request deletion of your data at any time by contacting support.',
            style: TextStyle(color: AppColors.gray600, height: 1.6),
          ),
        ),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }

  void _showTermsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.lg)),
        title: const Text('Terms of Service', style: TextStyle(fontWeight: FontWeight.bold)),
        content: const SingleChildScrollView(
          child: Text(
            'By using EduVision, you agree to use it solely for legitimate academic purposes. Misuse of AI tools, sharing of another student\'s data, or any form of academic misconduct is strictly prohibited.\n\nThe platform is provided as an academic project and comes without warranty of any kind. Usage is at your own discretion.',
            style: TextStyle(color: AppColors.gray600, height: 1.6),
          ),
        ),
        actions: [
          ElevatedButton(onPressed: () => Navigator.pop(ctx), child: const Text('Close')),
        ],
      ),
    );
  }
}
