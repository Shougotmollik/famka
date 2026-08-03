import 'dart:async';

import 'package:famka/provider/auth_provider.dart';
import 'package:famka/utils/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../config/routes/router_path.dart';
import '../widgets/custom_elevated_button.dart';

class RegisterVerificationScreen extends ConsumerStatefulWidget {
  const RegisterVerificationScreen({super.key, this.args});

  /// Data passed from the register screen (user_id, email, password).
  final Map<String, dynamic>? args;

  @override
  ConsumerState<RegisterVerificationScreen> createState() =>
      _RegisterVerificationScreenState();
}

class _RegisterVerificationScreenState
    extends ConsumerState<RegisterVerificationScreen> {
  final TextEditingController _pinController = TextEditingController();
  Timer? _countdownTimer;
  int _remainingSeconds = 41;
  bool _isResending = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _startCountdown();
  }

  @override
  void dispose() {
    _countdownTimer?.cancel();
    _pinController.dispose();
    super.dispose();
  }

  void _startCountdown() {
    _countdownTimer?.cancel();
    _remainingSeconds = 41;
    _countdownTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_remainingSeconds > 0) {
        setState(() => _remainingSeconds--);
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> _resendOtp(Map<String, dynamic>? args) async {
    final userId = args?['user_id'] as String?;
    if (userId == null || userId.isEmpty) {
      AppSnackbar.show(
        message: 'Account details missing. Please register again.',
        type: SnackType.error,
      );
      return;
    }

    setState(() => _isResending = true);
    try {
      await ref.read(authProvider.notifier).resendOtp(
            userId: userId,
            purpose: 'SIGNUP',
          );
      if (!mounted) return;
      _pinController.clear();
      _startCountdown();
      AppSnackbar.show(
        message: 'Verification code sent',
        type: SnackType.success,
      );
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(message: '$e', type: SnackType.error);
      }
    } finally {
      if (mounted) setState(() => _isResending = false);
    }
  }

  Future<void> _verifyCode(Map<String, dynamic>? args) async {
    final userId = args?['user_id'] as String?;
    final code = _pinController.text.trim();

    if (userId == null || userId.isEmpty) {
      AppSnackbar.show(
        message: 'Session expired. Please register again.',
        type: SnackType.error,
      );
      return;
    }
    if (code.length != 6) {
      AppSnackbar.show(
        message: 'Please enter the 6-digit verification code',
        type: SnackType.warning,
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).verifySignUpOtp(
            userId: userId,
            otp: code,
          );
      if (!mounted) return;
      context.go(AppRoutes.uploadProfileImage);
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(message: '$e', type: SnackType.error);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  String get _formattedTime {
    final minutes = (_remainingSeconds ~/ 60).toString().padLeft(2, '0');
    final seconds = (_remainingSeconds % 60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    final primaryColor = Theme.of(context).colorScheme.primary;

    final defaultPinTheme = PinTheme(
      width: 56.w,
      height: 56.w,
      textStyle: TextStyle(
        fontSize: 22.sp,
        color: primaryColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.white),
        shape: BoxShape.circle,
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2),
        shape: BoxShape.circle,
      ),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        border: Border.all(color: primaryColor, width: 2),
        shape: BoxShape.circle,
      ),
    );

    final userEmail = widget.args?['email'] as String? ?? 'example@gmail.com';

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: 60.h),
              Text(
                'Account verification',
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'Please enter the 6-digit verification code we sent to',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 14.sp, color: Colors.grey.shade400),
              ),
              SizedBox(height: 8.h),
              Text(
                userEmail,
                style: TextStyle(fontSize: 14.sp, color: primaryColor),
              ),
              SizedBox(height: 40.h),
              Pinput(
                controller: _pinController,
                length: 6,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                submittedPinTheme: submittedPinTheme,
                showCursor: true,
              ),
              SizedBox(height: 40.h),
              CustomElevatedButton(
                onPressed: () => _verifyCode(widget.args),
                title: 'Verify',
                color: primaryColor,
                textColor: Colors.white,
                isLoading: _isLoading,
              ),
              SizedBox(height: 20.h),

              if (_isResending)
                RichText(
                  text: TextSpan(
                    text: "Didn't get the email? ",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade300,
                    ),
                    children: [
                      WidgetSpan(
                        alignment: PlaceholderAlignment.middle,
                        child: SizedBox(
                          height: 14.sp,
                          width: 14.sp,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ),
                      TextSpan(
                        text: ' Resending...',
                        style: TextStyle(
                          color: Colors.grey.shade500,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                    ],
                  ),
                )
              else if (_remainingSeconds > 0)
                RichText(
                  text: TextSpan(
                    text: "Didn't get the email? ",
                    style: TextStyle(
                      fontSize: 13.sp,
                      color: Colors.grey.shade300,
                    ),
                    children: [
                      TextSpan(
                        text: 'Resend in $_formattedTime',
                        style: TextStyle(color: Colors.grey.shade500),
                      ),
                    ],
                  ),
                )
              else
                GestureDetector(
                  onTap: () => _resendOtp(widget.args),
                  child: RichText(
                    text: TextSpan(
                      text: "Didn't get the email? ",
                      style: TextStyle(
                        fontSize: 13.sp,
                        color: Colors.grey.shade300,
                      ),
                      children: [
                        TextSpan(
                          text: 'Resend',
                          style: TextStyle(
                            color: primaryColor,
                            fontWeight: FontWeight.w600,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
