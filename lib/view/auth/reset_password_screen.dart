import 'package:famka/provider/auth_provider.dart';
import 'package:famka/utils/app_snackbar.dart';
import 'package:famka/utils/form_validator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes/router_path.dart';
import '../widgets/auth_text_form_field.dart';
import '../widgets/custom_elevated_button.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key, this.args});

  /// Data passed from the verification screen (reset_token, user_id).
  final Map<String, dynamic>? args;

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final TextEditingController _newPasswordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void dispose() {
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  Future<void> _handleReset(Map<String, dynamic>? args) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final userId = args?['user_id'] as String?;
    final resetToken = args?['reset_token'] as String?;
    if (userId == null || resetToken == null) {
      AppSnackbar.show(
        message: 'Session expired. Please start the reset process again.',
        type: SnackType.error,
      );
      if (mounted) context.go(AppRoutes.forgotPassword);
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(authProvider.notifier)
          .resetPassword(
            userId: userId,
            resetToken: resetToken,
            password: _newPasswordController.text,
            confirmPassword: _confirmPasswordController.text,
          );
      if (!mounted) return;
      AppSnackbar.show(
        message: 'Password reset successfully. Please sign in.',
        type: SnackType.success,
      );
      context.go(AppRoutes.logIn);
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(message: '$e', type: SnackType.error);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
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
          child: Form(
            key: _formKey,
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
                  validator: FormValidator.validatePassword,
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
                  validator: (value) => FormValidator.validateConfirmPassword(
                    value,
                    _newPasswordController.text,
                  ),
                ),

                SizedBox(height: 40.h),

                CustomElevatedButton(
                  onPressed: () => _handleReset(widget.args),
                  title: 'Reset Password',
                  color: c.primary,
                  textColor: c.onPrimary,
                  isLoading: _isLoading,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
