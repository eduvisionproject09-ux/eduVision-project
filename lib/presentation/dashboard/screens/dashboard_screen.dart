import 'package:flutter/material.dart';
import 'package:flutter/widget_previews.dart';
import '../../theme/app_constants.dart';

@Preview(name: "DashboardScreen")
Widget previewDashboardScreen() => DashboardScreen();

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final availableWidth = screenWidth >= 1024
        ? screenWidth - 256
        : screenWidth;
    final isDesktop = availableWidth > 1024;
    final isTablet = availableWidth > 768;

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
      child: SingleChildScrollView(
        padding: EdgeInsets.all(
          MediaQuery.of(context).size.width > 1024
              ? AppSpacing.xl
              : AppSpacing.lg,
        ),
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 1280),
            child: Column(
              children: [
                // Header Card
                Container(
                  padding: const EdgeInsets.all(AppSpacing.xl),
                  decoration: BoxDecoration(
                    color: AppColors.white,
                    borderRadius: BorderRadius.circular(AppRadius.lg),
                    border: Border.all(color: AppColors.blue200),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Profile Section
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                Container(
                                  width: 64,
                                  height: 64,
                                  decoration: BoxDecoration(
                                    shape: BoxShape.circle,
                                    border: Border.all(
                                      color: AppColors.blue200,
                                      width: 4,
                                    ),
                                    image: const DecorationImage(
                                      image: NetworkImage(
                                        'https://images.unsplash.com/photo-1568880893176-fb2bdab44e41?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdHVkZW50JTIwcHJvZmlsZSUyMHBob3RvfGVufDF8fHx8MTc1NjQzNTY5MHww&ixlib=rb-4.1.0&q=80&w=1080',
                                      ),
                                      fit: BoxFit.cover,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.lg),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        'Nguyen Minh Anh',
                                        style: AppTextStyles.pageTitle.copyWith(
                                          color: AppColors.blue900,
                                        ),
                                      ),
                                      Text(
                                        'Computer Science • K64-CS',
                                        style: AppTextStyles.body.copyWith(
                                          color: AppColors.blue600,
                                        ),
                                      ),
                                      Text(
                                        'Year 3 student passionate about programming and technology',
                                        style: AppTextStyles.small.copyWith(
                                          color: AppColors.gray600,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          if (MediaQuery.of(context).size.width > 768)
                            Row(
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.settings, size: 16),
                                  label: const Text('Settings'),
                                  style: OutlinedButton.styleFrom(
                                    foregroundColor: AppColors.gray700,
                                    side: const BorderSide(
                                      color: AppColors.gray200,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: AppSpacing.sm),
                                ElevatedButton.icon(
                                  onPressed: () {},
                                  icon: const Icon(Icons.add, size: 16),
                                  label: const Text('Create Post'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: AppColors.blue600,
                                    foregroundColor: AppColors.white,
                                  ),
                                ),
                              ],
                            ),
                        ],
                      ),
                      const SizedBox(height: AppSpacing.xl),
                      // Stats Grid
                      GridView.count(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        crossAxisCount: isTablet ? 6 : 3,
                        mainAxisSpacing: AppSpacing.lg,
                        crossAxisSpacing: AppSpacing.lg,
                        childAspectRatio: 1.5,
                        children: [
                          _buildStatCard(
                            '45',
                            'Posts',
                            AppColors.blue50,
                            AppColors.blue200,
                            AppColors.blue900,
                            AppColors.blue600,
                          ),
                          _buildStatCard(
                            '128',
                            'Friends',
                            AppColors.green50,
                            AppColors.green200,
                            AppColors.green900,
                            AppColors.green600,
                          ),
                          _buildStatCard(
                            '89',
                            'Followers',
                            AppColors.purple50,
                            AppColors.purple200,
                            AppColors.purple900,
                            AppColors.purple600,
                          ),
                          _buildStatCard(
                            '12',
                            'Streak',
                            AppColors.orange50,
                            AppColors.orange200,
                            AppColors.orange900,
                            AppColors.orange600,
                            Icons.local_fire_department,
                          ),
                          _buildStatCard(
                            '2340',
                            'Points',
                            AppColors.yellow50,
                            AppColors.yellow200,
                            AppColors.yellow900,
                            AppColors.yellow600,
                          ),
                          _buildStatCard(
                            '#5',
                            'Rank',
                            AppColors.red50,
                            AppColors.red200,
                            AppColors.red900,
                            AppColors.red600,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: AppSpacing.xl),
                // Main Content
                if (isDesktop)
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 2,
                        child: Column(
                          children: [
                            _buildCreatePostCard(),
                            const SizedBox(height: AppSpacing.lg),
                            ..._buildPosts(),
                          ],
                        ),
                      ),
                      const SizedBox(width: AppSpacing.xl),
                      Expanded(
                        flex: 1,
                        child: Column(
                          children: [
                            _buildScheduleCard(),
                            const SizedBox(height: AppSpacing.xl),
                            _buildNotificationsCard(),
                            const SizedBox(height: AppSpacing.xl),
                            _buildEventsCard(),
                            const SizedBox(height: AppSpacing.xl),
                            _buildFriendSuggestionsCard(),
                          ],
                        ),
                      ),
                    ],
                  )
                else
                  Column(
                    children: [
                      _buildCreatePostCard(),
                      const SizedBox(height: AppSpacing.lg),
                      ..._buildPosts(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildScheduleCard(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildNotificationsCard(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildEventsCard(),
                      const SizedBox(height: AppSpacing.xl),
                      _buildFriendSuggestionsCard(),
                    ],
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(
    String value,
    String label,
    Color bgColor,
    Color borderColor,
    Color valueColor,
    Color labelColor, [
    IconData? icon,
  ]) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: borderColor),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(icon, size: 16, color: valueColor),
                const SizedBox(width: 4),
              ],
              Flexible(
                child: Text(
                  value,
                  style: AppTextStyles.subsectionHeading.copyWith(
                    color: valueColor,
                    fontWeight: FontWeight.w700,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            label,
            style: AppTextStyles.small.copyWith(color: labelColor),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }

  Widget _buildCreatePostCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.blue200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1568880893176-fb2bdab44e41?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdHVkZW50JTIwcHJvZmlsZSUyMHBob3RvfGVufDF8fHx8MTc1NjQzNTY5MHww&ixlib=rb-4.1.0&q=80&w=1080',
                ),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.lg,
                vertical: AppSpacing.md,
              ),
              decoration: BoxDecoration(
                border: Border.all(color: AppColors.gray200),
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Text(
                "What's on your mind?",
                style: AppTextStyles.body.copyWith(color: AppColors.gray500),
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.blue600,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(Icons.add, color: AppColors.white, size: 20),
          ),
        ],
      ),
    );
  }

  List<Widget> _buildPosts() {
    final posts = [
      {
        'name': 'Nguyen Minh Anh',
        'time': '2 hours ago',
        'content':
            'Just completed my final React project! 🎉 Thanks to everyone who supported me during the group work.',
        'likes': 15,
        'comments': 8,
        'image':
            'https://images.unsplash.com/photo-1568880893176-fb2bdab44e41?crop=entropy&cs=tinysrgb&fit=max&fm=jpg&ixid=M3w3Nzg4Nzd8MHwxfHNlYXJjaHwxfHxzdHVkZW50JTIwcHJvZmlsZSUyMHBob3RvfGVufDF8fHx8MTc1NjQzNTY5MHww&ixlib=rb-4.1.0&q=80&w=1080',
      },
      {
        'name': 'Tran Thi Lan',
        'time': '5 hours ago',
        'content':
            'Sharing Data Structures study materials for classmates. Drive link in the comments!',
        'likes': 23,
        'comments': 12,
        'image':
            'https://images.unsplash.com/photo-1494790108755-2616b612b1c0?w=100&h=100&fit=crop&crop=face',
      },
    ];

    return posts
        .map(
          (post) => Padding(
            padding: const EdgeInsets.only(bottom: AppSpacing.lg),
            child: Container(
              padding: const EdgeInsets.all(AppSpacing.xl),
              decoration: BoxDecoration(
                color: AppColors.white,
                borderRadius: BorderRadius.circular(AppRadius.lg),
                border: Border.all(color: AppColors.blue200),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          image: DecorationImage(
                            image: NetworkImage(post['image'] as String),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      const SizedBox(width: AppSpacing.md),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              post['name'] as String,
                              style: AppTextStyles.bodyMedium.copyWith(
                                color: AppColors.blue900,
                              ),
                            ),
                            Text(
                              post['time'] as String,
                              style: AppTextStyles.small.copyWith(
                                color: AppColors.gray500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Text(
                    post['content'] as String,
                    style: AppTextStyles.body.copyWith(
                      color: AppColors.gray800,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.lg),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        '${post['likes']} likes',
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                      Text(
                        '${post['comments']} comments',
                        style: AppTextStyles.small.copyWith(
                          color: AppColors.gray500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: AppSpacing.md),
                  Container(height: 1, color: AppColors.gray200),
                  const SizedBox(height: AppSpacing.md),
                  Row(
                    children: [
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.thumb_up_outlined, size: 16),
                          label: const Text('Like'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.gray700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.comment_outlined, size: 16),
                          label: const Text('Comment'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.gray700,
                          ),
                        ),
                      ),
                      Expanded(
                        child: TextButton.icon(
                          onPressed: () {},
                          icon: const Icon(Icons.share_outlined, size: 16),
                          label: const Text('Share'),
                          style: TextButton.styleFrom(
                            foregroundColor: AppColors.gray700,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        )
        .toList();
  }

  Widget _buildScheduleCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.green200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.access_time, size: 20, color: AppColors.green900),
              SizedBox(width: AppSpacing.sm),
              Text(
                "Today's Schedule",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.green900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildScheduleItem('Data Structures', '08:00 - 09:30', 'Room 201'),
          const SizedBox(height: AppSpacing.md),
          _buildScheduleItem('Web Programming', '10:00 - 11:30', 'Lab 101'),
          const SizedBox(height: AppSpacing.md),
          _buildScheduleItem('Computer Networks', '14:00 - 15:30', 'Room 304'),
        ],
      ),
    );
  }

  Widget _buildScheduleItem(String course, String time, String location) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.green50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.green200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            course,
            style: AppTextStyles.bodyMedium.copyWith(color: AppColors.green800),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: AppTextStyles.small.copyWith(color: AppColors.green600),
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 12,
                color: AppColors.green500,
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: AppTextStyles.small.copyWith(color: AppColors.green500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.yellow200),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: const [
                  Icon(
                    Icons.notifications,
                    size: 20,
                    color: AppColors.yellow900,
                  ),
                  SizedBox(width: AppSpacing.sm),
                  Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w600,
                      color: AppColors.yellow900,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.sm,
                  vertical: 2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.red500,
                  borderRadius: BorderRadius.circular(AppRadius.full),
                ),
                child: const Text(
                  '2',
                  style: TextStyle(
                    color: AppColors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildNotificationItem(
            'Pham Van Nam liked your post',
            '10 minutes ago',
            false,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildNotificationItem(
            'Le Thi Hoa commented on your post',
            '30 minutes ago',
            false,
          ),
          const SizedBox(height: AppSpacing.md),
          _buildNotificationItem(
            'Nguyen Van Duc sent you a friend request',
            '1 hour ago',
            true,
          ),
          const SizedBox(height: AppSpacing.md),
          OutlinedButton(
            onPressed: () {},
            style: OutlinedButton.styleFrom(
              minimumSize: const Size(double.infinity, 36),
              side: const BorderSide(color: AppColors.gray200),
            ),
            child: const Text('View All'),
          ),
        ],
      ),
    );
  }

  Widget _buildNotificationItem(String content, String time, bool isRead) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: isRead ? AppColors.gray50 : AppColors.yellow50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(
          color: isRead ? AppColors.gray200 : AppColors.yellow200,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            content,
            style: AppTextStyles.small.copyWith(color: AppColors.gray800),
          ),
          const SizedBox(height: 4),
          Text(
            time,
            style: AppTextStyles.extraSmall.copyWith(color: AppColors.gray500),
          ),
        ],
      ),
    );
  }

  Widget _buildEventsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.purple200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.event, size: 20, color: AppColors.purple900),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Upcoming Events',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.purple900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildEventItem(
            'Hackathon 2024',
            'Large-scale programming competition',
            '2024-09-15',
            'Hall A1',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildEventItem(
            'React Advanced Workshop',
            'Advanced React course',
            '2024-09-10',
            'Lab 302',
          ),
        ],
      ),
    );
  }

  Widget _buildEventItem(
    String title,
    String description,
    String date,
    String location,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.purple50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.purple200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: AppTextStyles.bodyMedium.copyWith(
              color: AppColors.purple800,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            description,
            style: AppTextStyles.small.copyWith(color: AppColors.purple600),
          ),
          const SizedBox(height: 4),
          Row(
            children: [
              const Icon(
                Icons.calendar_today,
                size: 12,
                color: AppColors.purple500,
              ),
              const SizedBox(width: 4),
              Text(
                date,
                style: AppTextStyles.small.copyWith(color: AppColors.purple500),
              ),
            ],
          ),
          Row(
            children: [
              const Icon(
                Icons.location_on,
                size: 12,
                color: AppColors.purple500,
              ),
              const SizedBox(width: 4),
              Text(
                location,
                style: AppTextStyles.small.copyWith(color: AppColors.purple500),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildFriendSuggestionsCard() {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.white,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.indigo200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: const [
              Icon(Icons.person_add, size: 20, color: AppColors.indigo900),
              SizedBox(width: AppSpacing.sm),
              Text(
                'Friend Suggestions',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: AppColors.indigo900,
                ),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.lg),
          _buildFriendSuggestion(
            'Hoang Van Hung',
            'Computer Science',
            '5 mutual friends',
            'https://images.unsplash.com/photo-1507003211169-0a1dd7228f2d?w=100&h=100&fit=crop&crop=face',
          ),
          const SizedBox(height: AppSpacing.md),
          _buildFriendSuggestion(
            'Do Thi Mai',
            'Information Technology',
            '3 mutual friends',
            'https://images.unsplash.com/photo-1438761681033-6461ffad8d80?w=100&h=100&fit=crop&crop=face',
          ),
        ],
      ),
    );
  }

  Widget _buildFriendSuggestion(
    String name,
    String major,
    String mutualFriends,
    String image,
  ) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.indigo50,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.indigo200),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(image),
                fit: BoxFit.cover,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.md),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: AppColors.indigo800,
                  ),
                ),
                Text(
                  major,
                  style: AppTextStyles.small.copyWith(
                    color: AppColors.indigo600,
                  ),
                ),
                Text(
                  mutualFriends,
                  style: AppTextStyles.extraSmall.copyWith(
                    color: AppColors.indigo500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: 32,
            height: 32,
            decoration: BoxDecoration(
              border: Border.all(color: AppColors.indigo600),
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            child: const Icon(
              Icons.person_add,
              size: 16,
              color: AppColors.indigo600,
            ),
          ),
        ],
      ),
    );
  }
}
