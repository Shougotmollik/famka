import 'package:famka/config/app_colors.dart';
import 'package:famka/view/widgets/social_button.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/router_path.dart';
import '../widgets/auth_text_form_field.dart';
import '../widgets/custom_elevated_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmPasswordController =
      TextEditingController();
  bool _agreed = false;

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
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
              SizedBox(height: 16.h),
              Center(
                child: SvgPicture.asset(
                  'assets/logo/applogo.svg',
                  height: 36.h,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ),
              SizedBox(height: 24.h),
              Text(
                'Welcome',
                textAlign: TextAlign.center,
                style: theme.textTheme.headlineSmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: const Color(0XFF_B3B3B8),
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 8.h),
              Text(
                'Register',
                textAlign: TextAlign.center,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: const Color(0xff_B3B3B8),
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(height: 32.h),

              Text(
                'Name',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              AuthTextFormField(
                hintText: 'Enter your name',
                controller: _nameController,
                keyboardType: TextInputType.name,
              ),

              SizedBox(height: 16.h),

              Text(
                'Email',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              AuthTextFormField(
                hintText: 'Enter email address',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: 16.h),

              Text(
                'Password',
                style: theme.textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  fontSize: 14.sp,
                ),
              ),
              SizedBox(height: 8.h),
              AuthTextFormField(
                hintText: 'Enter your password',
                controller: _passwordController,
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
                hintText: 'Confirm password',
                controller: _confirmPasswordController,
                isPassword: true,
              ),

              SizedBox(height: 8.h),

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 24.w,
                    height: 24.w,
                    child: Checkbox(
                      value: _agreed,
                      onChanged: (val) {
                        setState(() {
                          _agreed = val ?? false;
                        });
                      },
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4.r),
                      ),
                      side: BorderSide(color: Colors.white, width: 1.w),
                      activeColor: c.primary,
                    ),
                  ),
                  SizedBox(width: 8.w),
                  Expanded(
                    child: RichText(
                      text: TextSpan(
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12.sp,
                          height: 1.5,
                        ),
                        children: [
                          const TextSpan(
                            text: 'By Register, you are agreeing to ',
                          ),
                          TextSpan(
                            text: 'Terms of services\n',
                            style: TextStyle(color: c.primary),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                          const TextSpan(text: 'and '),
                          TextSpan(
                            text: 'Privacy Policy',
                            style: TextStyle(color: c.primary),
                            recognizer: TapGestureRecognizer()..onTap = () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              CustomElevatedButton(
                onPressed: () {
                  if (!_agreed) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: const Text(
                          'Please agree to the terms and conditions',
                          style: TextStyle(color: AppColors.onPrimary),
                        ),
                        backgroundColor: c.primary,
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                    return;
                  }
                  context.go(AppRoutes.home);
                },
                title: 'Register',
                color: c.primary,
                textColor: c.onPrimary,
              ),

              SizedBox(height: 16.h),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Already have an account? ",
                    style: TextStyle(color: Colors.white, fontSize: 13.sp),
                  ),
                  GestureDetector(
                    onTap: () {
                      context.go(AppRoutes.logIn);
                    },
                    child: Text(
                      'Log In',
                      style: TextStyle(color: c.primary, fontSize: 13.sp),
                    ),
                  ),
                ],
              ),

              SizedBox(height: 32.h),

              Row(
                children: [
                  Expanded(child: Divider(color: c.outlineVariant)),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16.w),
                    child: Text(
                      'Or continue with',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Expanded(child: Divider(color: c.outlineVariant)),
                ],
              ),

              SizedBox(height: 24.h),

              Row(
                children: [
                  Expanded(
                    child: SocialButton(
                      title: 'Google',
                      icon: 'assets/icons/google.svg',
                      onPressed: () {},
                    ),
                  ),
                  SizedBox(width: 16.w),
                  Expanded(
                    child: SocialButton(
                      title: 'Apple',
                      icon: 'assets/icons/apple.svg',
                      onPressed: () {},
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24.h),
            ],
          ),
        ),
      ),
    );
  }
}
