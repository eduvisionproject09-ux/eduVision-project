import 'package:academic_project/presentation/auth/provider/auth_provider.dart';
import 'package:academic_project/presentation/auth/screen/login_page.dart';
import 'package:academic_project/presentation/auth/screen/sign_up.dart';
import 'package:academic_project/presentation/notes/screens/notes_list_page.dart';
import 'package:academic_project/presentation/notes/screens/note_detail_page.dart';
import 'package:academic_project/presentation/ai/screens/ai_assistant_screen.dart';
import 'package:academic_project/domain/note.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

final routerProvider = Provider<GoRouter>((ref) {
  final authState = ref.watch(authProvider);

  return GoRouter(
    initialLocation: '/login',
    routes: [
      GoRoute(path: '/login', builder: (context, state) => const LoginPage()),
      GoRoute(path: '/signup', builder: (context, state) => const SignupPage()),
      GoRoute(
        path: '/resources',
        builder: (context, state) => const HomePage(),
      ),
      GoRoute(
        path: '/ai',
        builder: (context, state) {
          final noteId = state.uri.queryParameters['noteId'];
          return AiAssistantScreen(noteId: noteId != null ? int.tryParse(noteId) : null);
        },
      ),
      GoRoute(path: '/', builder: (context, state) => const NotesListPage()),
      GoRoute(
        path: '/note',
        builder: (context, state) {
          final note = state.extra as Note;
          return NoteDetailPage(note: note);
        },
      ),
    ],
    redirect: (context, state) {
      final isLoggedIn = authState.value != null;
      final isLoggingIn =
          state.matchedLocation == '/login' ||
          state.matchedLocation == '/signup';

      if (!isLoggedIn && !isLoggingIn) return '/login';
      if (isLoggedIn && isLoggingIn) return '/';

      return null;
    },
  );
});

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('EduVision Home')),
      body: const Center(child: Text('Welcome to EduVision!')),
    );
  }
}
