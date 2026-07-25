import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../config/router_path.dart';
import '../widgets/auth_text_form_field.dart';
import '../widgets/custom_elevated_button.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Scaffold(
      backgroundColor: c.surface,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 24.h),
              Text(
                'Reset Password',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0XFF_B3B3B8),
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Enter your new password',
                textAlign: TextAlign.center,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: const Color(0xff_B3B3B8),
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 40.h),

              Text(
                'New Password',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              AuthTextFormField(
                hintText: 'Enter new password',
                controller: _newPasswordController,
                isPassword: true,
              ),

              SizedBox(height: 16.h),

              Text(
                'Confirm Password',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              AuthTextFormField(
                hintText: 'Confirm new password',
                controller: _confirmPasswordController,
                isPassword: true,
              ),

              SizedBox(height: 40.h),

              CustomElevatedButton(
                onPressed: () => context.go(AppRoutes.logIn),
                title: 'Reset Password',
                color: c.primary,
                textColor: c.onPrimary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
