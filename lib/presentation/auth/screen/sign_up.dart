import 'package:academic_project/presentation/auth/provider/auth_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_animate/flutter_animate.dart';

class SignupPage extends ConsumerStatefulWidget {
  const SignupPage({super.key});

  @override
  ConsumerState<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends ConsumerState<SignupPage> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _emailController = TextEditingController();

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
                  theme.scaffoldBackgroundColor,
                  theme.colorScheme.primary.withOpacity(0.1),
                  theme.scaffoldBackgroundColor,
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
                  color:
                      theme.cardTheme.color?.withOpacity(0.8) ??
                      Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(color: Colors.black.withOpacity(0.1)),
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
                    // Header section
                    Center(
                      child: Column(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: theme.colorScheme.secondary.withOpacity(
                                0.1,
                              ),
                              shape: BoxShape.circle,
                            ),
                            child: Icon(
                              Icons.person_add_rounded,
                              size: 48,
                              color: theme.colorScheme.secondary,
                            ),
                          ).animate().scale(
                            duration: 600.ms,
                            curve: Curves.easeOutBack,
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Create Account',
                            style: theme.textTheme.headlineMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              letterSpacing: 1.2,
                            ),
                          ).animate().fadeIn(delay: 200.ms),
                          Text(
                            'Join the future of learning',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey,
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
                      controller: _emailController,
                      decoration: const InputDecoration(
                        labelText: 'Email',
                        prefixIcon: Icon(Icons.email_outlined),
                      ),
                    ).animate().slideX(begin: 0.1, delay: 600.ms).fadeIn(),
                    const SizedBox(height: 16),

                    TextField(
                      controller: _passwordController,
                      decoration: const InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.lock_outline),
                      ),
                      obscureText: true,
                    ).animate().slideX(begin: -0.1, delay: 700.ms).fadeIn(),
                    const SizedBox(height: 32),

                    if (authState.isLoading)
                      const Center(child: CircularProgressIndicator())
                    else
                      ElevatedButton(
                            onPressed: () {
                              ref
                                  .read(authProvider.notifier)
                                  .signup(
                                    _usernameController.text,
                                    _emailController.text,
                                    _passwordController.text,
                                  );
                            },
                            style: ElevatedButton.styleFrom(
                              padding: const EdgeInsets.symmetric(vertical: 16),
                              backgroundColor: theme.colorScheme.secondary,
                            ),
                            child: const Text('Sign Up'),
                          )
                          .animate()
                          .fadeIn(delay: 800.ms)
                          .scale(begin: const Offset(0.9, 0.9)),

                    const SizedBox(height: 16),
                    TextButton(
                      onPressed: () => context.go('/login'),
                      child: RichText(
                        text: TextSpan(
                          style: theme.textTheme.bodyMedium,
                          children: [
                            const TextSpan(text: "Already have an account? "),
                            TextSpan(
                              text: 'Login',
                              style: TextStyle(
                                color: theme.colorScheme.secondary,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ).animate().fadeIn(delay: 900.ms),

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
