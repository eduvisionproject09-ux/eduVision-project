import 'package:academic_project/presentation/navigation/app_navigation.dart';
import 'package:academic_project/presentation/dashboard/screens/dashboard_screen.dart';
import 'package:academic_project/presentation/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:device_preview/device_preview.dart';

void main() {
  runApp(const ProviderScope(child: MyApp()));
  // runApp(
  //   DevicePreview(
  //     enabled: true,
  //     tools: [...DevicePreview.defaultTools],
  //     builder: (context) => const ProviderScope(child: MyApp()),
  //   ),
  // );
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider2);

    return MaterialApp.router(
      title: 'EduVision',
      theme: AppTheme.lightTheme,
      routerConfig: router,
      debugShowCheckedModeBanner: false,
      builder: DevicePreview.appBuilder,
      locale: DevicePreview.locale(context),
    );
  }
}
