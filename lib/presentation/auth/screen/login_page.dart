import 'package:academic_project/presentation/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class LoginPage extends ConsumerStatefulWidget {
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends ConsumerState<LoginPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final theme = Theme.of(context);

    return Scaffold(
      body: Stack(
        children: [
          // Background Gradient
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  theme.colorScheme.background,
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.colorScheme.background,
                ],
              ),
            ),
          ),
          Center(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(24.0),
              child: Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32.0),
                decoration: BoxDecoration(
                  color: theme.cardTheme.color?.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.white.withOpacity(0.1)),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Logo/Title section
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.primaryColor.withOpacity(0.1),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.auto_stories_rounded,
                              size: 48,
                              color: theme.primaryColor,
                            ),
                          ).animate().scale(
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'EduVision',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ).animate().fadeIn(delay: 200.ms),
                          Text(
                            'Your AI-Powered Study Companion',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.white54,
                            ),
                          ).animate().fadeIn(delay: 400.ms),
                        ],
                      ),
                    ),
                    const SizedBox(height: 40),

                    TextField(
                      controller: _usernameController,
                      decoration: const InputDecoration(
                        labelText: 'Username',
                        prefixIcon: Icon(Icons.person_outline),
                      ),
                    ).animate().slideX(begin: -0.1, delay: 500.ms).fadeIn(),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                    ).animate().slideX(begin: 0.1, delay: 600.ms).fadeIn(),
                    const SizedBox(height: 32),

                    if (authState.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(authProvider.notifier)
                                  .login(
                                    _usernameController.text,
                                    _passwordController.text,
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                            ),
                            child: const Text('Sign In'),
                          )
                          .animate()
                          .fadeIn(delay: 700.ms)
                          .scale(begin: const Offset(0.9, 0.9)),

                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/signup'),
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: [
                            const TextSpan(text: "Don't have an account? "),
                            TextSpan(
                              text: 'Sign Up',
                              style: TextStyle(
                                color: theme.primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 800.ms),

                    if (authState.hasError)
                      Padding(
                        padding: const EdgeInsets.only(top: 16),
                        child: Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: Colors.red.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: Colors.red.withOpacity(0.3),
                            ),
                          ),
                          child: Text(
                            'Error: ${authState.error}',
                            textAlign: TextAlign.center,
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ).animate().shake(),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
