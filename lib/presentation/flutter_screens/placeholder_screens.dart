import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import '../theme/app_constants.dart';

@Preview(name: "NotificationsScreen")
Widget previewNotificationsScreen() => NotificationsScreen();

class NotificationsScreen extends StatelessWidget {
  const NotificationsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.notifications,
                size: 64,
                color: AppColors.blue600,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Notifications',
                style: AppTextStyles.studentTitle.copyWith(
                  color: AppColors.blue900,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'In Development',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EventsScreen extends StatelessWidget {
  const EventsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.event,
                size: 64,
                color: AppColors.purple600,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Events',
                style: AppTextStyles.studentTitle.copyWith(
                  color: AppColors.purple900,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'In Development',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class ResourcesScreen extends StatelessWidget {
  const ResourcesScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.folder,
                size: 64,
                color: AppColors.indigo600,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Resources',
                style: AppTextStyles.studentTitle.copyWith(
                  color: AppColors.indigo900,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'In Development',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AchievementsScreen extends StatelessWidget {
  const AchievementsScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.xl),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.emoji_events,
                size: 64,
                color: AppColors.yellow600,
              ),
              const SizedBox(height: AppSpacing.xl),
              Text(
                'Achievements',
                style: AppTextStyles.studentTitle.copyWith(
                  color: AppColors.yellow900,
                ),
              ),
              const SizedBox(height: AppSpacing.md),
              Text(
                'In Development',
                style: AppTextStyles.body.copyWith(
                  color: AppColors.gray600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
