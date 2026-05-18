import 'package:academic_project/presentation/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../theme/app_constants.dart';
import '../dashboard/screens/dashboard_screen.dart';
import '../profile/screens/profile_screen.dart';
import '../friends/screens/friends_screen.dart';
import '../messages/screens/messages_screen.dart';
import '../flutter_screens/placeholder_screens.dart';
import '../smart notes/screens/smart_notes_screen.dart';
import '../auth/screen/login_page.dart';
import '../auth/screen/sign_up.dart';

// GoRouter configuration
final routerProvider2 = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
      ShellRoute(
        builder: (context, state, child) => MainLayout(child: child),
        routes: [
          GoRoute(
            path: '/dashboard',
            builder: (context, state) => const DashboardScreen(),
          ),
          GoRoute(
            path: '/smartnotes',
            builder: (context, state) => const SmartNotes(),
          ),
          GoRoute(
            path: '/profile',
            builder: (context, state) => const ProfileScreen(),
          ),
          GoRoute(
            path: '/friends',
            builder: (context, state) => const FriendsScreen(),
          ),
          GoRoute(
            path: '/messages',
            builder: (context, state) => const MessagesScreen(),
          ),
          GoRoute(
            path: '/notifications',
            builder: (context, state) => const NotificationsScreen(),
          ),
          GoRoute(
            path: '/events',
            builder: (context, state) => const EventsScreen(),
          ),
          GoRoute(
            path: '/resources',
            builder: (context, state) => const ResourcesScreen(),
          ),
          GoRoute(
            path: '/achievements',
            builder: (context, state) => const AchievementsScreen(),
          ),
        ],
      ),
    ],

    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/smartnotes';

      return null;
    },
  );
});

class MainLayout extends StatelessWidget {
  final Widget child;

  const MainLayout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth >= 1024;

        return Scaffold(
          body: Row(
            children: [
              if (isDesktop) const DesktopNavigation(),
              Expanded(child: child),
            ],
          ),
          bottomNavigationBar: isDesktop ? null : const MobileNavigation(),
        );
      },
    );
  }
}

class DesktopNavigation extends StatelessWidget {
  const DesktopNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return Container(
      width: 256,
      decoration: BoxDecoration(
        color: AppColors.white,
        border: const Border(right: BorderSide(color: AppColors.blue200)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Logo Area
          Padding(
            padding: const EdgeInsets.all(AppSpacing.xl),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.indigo600,
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                  child: const Icon(
                    Icons.menu_book,
                    color: AppColors.white,
                    size: 24,
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Text(
                  'EduVision',
                  style: AppTextStyles.sectionHeading.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppColors.gray900,
                  ),
                ),
              ],
            ),
          ),

          // Search Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.md,
                vertical: 2,
              ),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.gray200),
              ),
              child: Row(
                children: [
                  const Icon(Icons.search, color: AppColors.gray400, size: 20),
                  const SizedBox(width: AppSpacing.sm),
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: 'Search...',
                        border: InputBorder.none,
                        hintStyle: AppTextStyles.body.copyWith(
                          color: AppColors.gray400,
                        ),
                        isDense: true,
                        contentPadding: const EdgeInsets.symmetric(vertical: 8),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: AppSpacing.lg),

          // Navigation Items
          // Expanded(
          //   child: ListView(
          //     padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          //     children: [
          //       _buildNavItem(
          //         context,
          //         icon: Icons.home,
          //         label: 'Home',
          //         route: '/dashboard',
          //         isActive: currentRoute == '/dashboard' || currentRoute == '/',
          //       ),
          //       _buildNavItem(
          //         context,
          //         icon: Icons.note_alt_outlined,
          //         label: 'Smart Notes',
          //         route: '/smartnotes',
          //         isActive: currentRoute == '/smartnotes',
          //       ),
          //       _buildNavItem(
          //         context,
          //         icon: Icons.person_outline,
          //         label: 'Profile',
          //         route: '/profile',
          //         isActive: currentRoute == '/profile',
          //       ),
          //       _buildNavItem(
          //         context,
          //         icon: Icons.people_outline,
          //         label: 'Friends',
          //         route: '/friends',
          //         isActive: currentRoute == '/friends',
          //       ),
          //       _buildNavItem(
          //         context,
          //         icon: Icons.chat_bubble_outline,
          //         label: 'Messages',
          //         route: '/messages',
          //         isActive: currentRoute == '/messages',
          //         badgeCount: 3,
          //       ),
          //       _buildNavItem(
          //         context,
          //         icon: Icons.notifications_none,
          //         label: 'Notifications',
          //         route: '/notifications',
          //         isActive: currentRoute == '/notifications',
          //         badgeCount: 5,
          //       ),
          //       _buildNavItem(
          //         context,
          //         icon: Icons.calendar_today,
          //         label: 'Events',
          //         route: '/events',
          //         isActive: currentRoute == '/events',
          //       ),
          //       _buildNavItem(
          //         context,
          //         icon: Icons.folder_open,
          //         label: 'Resources',
          //         route: '/resources',
          //         isActive: currentRoute == '/resources',
          //       ),
          //       _buildNavItem(
          //         context,
          //         icon: Icons.emoji_events_outlined,
          //         label: 'Achievements',
          //         route: '/achievements',
          //         isActive: currentRoute == '/achievements',
          //       ),
          //     ],
          //   ),
          // ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
              children: [
                _buildNavItem(
                  context,
                  icon: Icons.note_alt_outlined,
                  label: 'Smart Notes',
                  route: '/smartnotes',
                  isActive: currentRoute == '/smartnotes',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.person_outline,
                  label: 'Profile',
                  route: '/profile',
                  isActive: currentRoute == '/profile',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.calendar_today,
                  label: 'Events',
                  route: '/events',
                  isActive: currentRoute == '/events',
                ),
                _buildNavItem(
                  context,
                  icon: Icons.folder_open,
                  label: 'Resources',
                  route: '/resources',
                  isActive: currentRoute == '/resources',
                ),
              ],
            ),
          ),

          // Footer
          Padding(
            padding: const EdgeInsets.all(AppSpacing.lg),
            child: _buildNavItem(
              context,
              icon: Icons.settings_outlined,
              label: 'Settings',
              route: '/settings',
              isActive: currentRoute == '/settings',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
    int? badgeCount,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.xs),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: () => context.go(route),
          borderRadius: BorderRadius.circular(AppRadius.lg),
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.md,
              vertical: AppSpacing.sm + 2,
            ),
            decoration: BoxDecoration(
              color: isActive ? AppColors.gray900 : Colors.transparent,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            child: Row(
              children: [
                Icon(
                  icon,
                  size: 20,
                  color: isActive ? AppColors.white : AppColors.gray700,
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: Text(
                    label,
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: isActive ? AppColors.white : AppColors.gray800,
                      fontWeight: isActive ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ),
                if (badgeCount != null)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 2,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.red600,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      badgeCount.toString(),
                      style: const TextStyle(
                        color: AppColors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class MobileNavigation extends StatelessWidget {
  const MobileNavigation({super.key});

  @override
  Widget build(BuildContext context) {
    final currentRoute = GoRouterState.of(context).uri.path;

    return Container(
      height: 64,
      decoration: const BoxDecoration(
        color: AppColors.white,
        border: Border(top: BorderSide(color: AppColors.blue200)),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 10,
            offset: Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _buildBottomNavItem(
            context,
            icon: Icons.dashboard,
            label: 'Dashboard',
            route: '/dashboard',
            isActive: currentRoute == '/dashboard',
          ),
          _buildBottomNavItem(
            context,
            icon: Icons.person,
            label: 'Profile',
            route: '/profile',
            isActive: currentRoute == '/profile',
          ),
          _buildBottomNavItem(
            context,
            icon: Icons.people,
            label: 'Friends',
            route: '/friends',
            isActive: currentRoute == '/friends',
          ),
          _buildBottomNavItem(
            context,
            icon: Icons.message,
            label: 'Messages',
            route: '/messages',
            isActive: currentRoute == '/messages',
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavItem(
    BuildContext context, {
    required IconData icon,
    required String label,
    required String route,
    required bool isActive,
  }) {
    return InkWell(
      onTap: () => context.go(route),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 24,
              color: isActive ? AppColors.blue600 : AppColors.gray500,
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: AppTextStyles.extraSmall.copyWith(
                color: isActive ? AppColors.blue600 : AppColors.gray500,
                fontWeight: isActive ? FontWeight.w600 : FontWeight.w400,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
