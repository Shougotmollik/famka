import 'package:famka/view/auth/forgot_password_screen.dart';
import 'package:famka/view/auth/forgot_verification_screen.dart';
import 'package:famka/view/auth/log_in_screen.dart';
import 'package:famka/view/auth/register_screen.dart';
import 'package:famka/view/auth/register_verification_screen.dart';
import 'package:famka/view/auth/reset_password_screen.dart';
import 'package:famka/view/auth/upload_profile_image_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../view/main_nav_bar.dart';
import '../view/home/home_screen.dart';
import '../view/auth/splash_screen.dart';
import '../view/auth/onboarding_screen.dart';
import 'router_path.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: AppRoutes.splash,
  debugLogDiagnostics: true,
  routes: [
    GoRoute(
      path: AppRoutes.splash,
      builder: (context, state) => const SplashScreen(),
    ),
    GoRoute(
      path: AppRoutes.onBoarding,
      builder: (context, state) => const OnboardingScreen(),
    ),
    GoRoute(
      path: AppRoutes.logIn,
      builder: (context, state) => const LogInScreen(),
    ),
    GoRoute(
      path: AppRoutes.register,
      builder: (context, state) => const RegisterScreen(),
    ),
    GoRoute(
      path: AppRoutes.registerVerification,
      builder: (context, state) => RegisterVerificationScreen(),
    ),
    GoRoute(
      path: AppRoutes.uploadProfileImage,
      builder: (context, state) => const UploadProfileImageScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotPassword,
      builder: (context, state) => const ForgotPasswordScreen(),
    ),
    GoRoute(
      path: AppRoutes.forgotVerification,
      builder: (context, state) => const ForgotVerificationScreen(),
    ),
    GoRoute(
      path: AppRoutes.resetPassword,
      builder: (context, state) => const ResetPasswordScreen(),
    ),
    ShellRoute(
      builder: (context, state, child) => MainNavBar(child: child),
      routes: [
        GoRoute(
          path: AppRoutes.home,
          builder: (context, state) => const HomeScreen(),
        ),
      ],
    ),
  ],
  errorBuilder: (context, state) {
    return Scaffold(
      appBar: AppBar(title: const Text('Page not found')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline_rounded,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: 16),
            Text('404', style: Theme.of(context).textTheme.displaySmall),
            const SizedBox(height: 8),
            Text(
              "The page you're looking for doesn't exist.",
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                color: Theme.of(context).colorScheme.onSurfaceVariant,
              ),
            ),
            const SizedBox(height: 24),
            FilledButton.icon(
              onPressed: () => context.go(AppRoutes.home),
              icon: const Icon(Icons.home_rounded),
              label: const Text('Go Home'),
            ),
          ],
        ),
      ),
    );
  },
);
