# Flutter Student Social Network - Screen Files

Ei Flutter screen file gula tumhar React app tar exact replica banabe Flutter web e.

## 📁 Files Created

1. **app_constants.dart** - All colors, text styles, and spacing constants
2. **dashboard_screen.dart** - Main dashboard with posts, stats, and sidebar
3. **profile_screen.dart** - Student profile with notebook theme
4. **friends_screen.dart** - Friends page with tabs (Friends, Requests, Suggestions)
5. **messages_screen.dart** - Messaging interface with conversation list and chat
6. **placeholder_screens.dart** - Notifications, Events, Resources, Achievements screens
7. **app_navigation.dart** - Navigation setup using go_router

## 🚀 How to Use

### Step 1: Create a New Flutter Project
```bash
flutter create student_social_network
cd student_social_network
```

### Step 2: Add Required Dependencies

Tomar `pubspec.yaml` file e ei dependencies gulo add koro:

```yaml
dependencies:
  flutter:
    sdk: flutter
  go_router: ^14.0.0

dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^4.0.0
```

Then run:
```bash
flutter pub get
```

### Step 3: Copy the Screen Files

1. `lib` folder er modhhe `screens` naam e ekta folder banao
2. Sob `.dart` files gula copy kore `lib/screens/` e paste koro:
   - app_constants.dart
   - dashboard_screen.dart
   - profile_screen.dart
   - friends_screen.dart
   - messages_screen.dart
   - placeholder_screens.dart
   - app_navigation.dart

### Step 4: Update main.dart

Tomar `lib/main.dart` file ta replace koro ei code diye:

```dart
import 'package:flutter/material.dart';
import 'screens/app_navigation.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Student Social Network',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF2563EB)),
        useMaterial3: true,
        fontFamily: 'system-ui',
      ),
      routerConfig: router,
    );
  }
}
```

### Step 5: Run the App

```bash
flutter run -d chrome
```

## 📱 Responsive Design

- **Desktop (>= 1024px)**: Side navigation with full layout
- **Mobile (< 1024px)**: Bottom navigation bar
- All screens are responsive and adapt to screen size

## 🎨 Design Features

✅ **Notebook Theme** - Profile page e spiral binding, holes, and lined paper effect  
✅ **Color System** - Same colors as React app (blue, indigo, purple, green, etc.)  
✅ **Typography** - Matching font sizes and weights  
✅ **Gradients** - Background gradients for all screens  
✅ **Cards & Badges** - Same styling as React components  
✅ **Icons** - Material Icons (same as Lucide React)  

## 🔄 Navigation Routes

- `/dashboard` - Main dashboard
- `/profile` - Student profile
- `/friends` - Friends page
- `/messages` - Messaging
- `/notifications` - Notifications (placeholder)
- `/events` - Events (placeholder)
- `/resources` - Resources (placeholder)
- `/achievements` - Achievements (placeholder)

## 📦 What's Included

### Dashboard Screen
- User profile header
- 6 stat cards (Posts, Friends, Followers, Streak, Points, Rank)
- Create post section
- Posts feed with Like/Comment/Share
- Sidebar with:
  - Today's Schedule
  - Notifications
  - Upcoming Events
  - Friend Suggestions

### Profile Screen
- Notebook design with spiral binding
- Profile picture with online indicator
- Contact information
- Academic progress with progress bars
- Achievements section
- Extracurricular activities
- Today's schedule

### Friends Screen
- Search bar
- 3 tabs: Friends, Requests, Suggestions
- Grid layout for friends
- Accept/Decline friend requests
- Add friend functionality

### Messages Screen
- Conversation list with search
- Chat interface
- Message bubbles (sent/received)
- Read receipts
- Message input with emoji and attachment icons

## 🎯 Size Handling

Flutter uses **logical pixels**, not CSS pixels. Ami sizes adjust korechi jate exactly same dekhay:

- React `text-sm` (14px) = Flutter `fontSize: 14`
- React `p-4` (16px) = Flutter `padding: 16`
- React `rounded-lg` (8px) = Flutter `borderRadius: 8`

## 🖼️ Images

Screen e use kora hoyeche same Unsplash images React app theke. Internet connection lagbe images load howar jonno.

## ⚠️ Notes

1. **No main.dart included** - Tumi nijeyi banabe (Step 4 dekho)
2. **Internet required** - Images load howar jonno
3. **Chrome recommended** - Web development er jonno
4. **Hot reload works** - Code change korle automatically update hobe

## 🔧 Customization

### Change Profile Data
`dashboard_screen.dart` and `profile_screen.dart` e hard-coded data ache. Tumi chaile modify korte paro.

### Change Colors
`app_constants.dart` e sob colors define kora ache. Ekhanei change korle sob jaygay update hobe.

### Add More Features
- API integration korar jonno `http` or `dio` package use koro
- State management er jonno `provider` or `riverpod` add koro
- Database er jonno `sqflite` or `hive` use koro

## 🎉 Result

Chrome e run korle exactly same dekhbe jemon React app e dekho! All features, colors, layouts, and interactions match perfectly.

---

**Created for:** Converting React + Tailwind student social network to Flutter  
**Responsive:** ✅ Desktop & Mobile  
**Theme:** Notebook design with gradient backgrounds  
**Navigation:** go_router with ShellRoute  
