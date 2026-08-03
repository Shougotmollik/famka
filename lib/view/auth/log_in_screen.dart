import 'package:famka/config/routes/router_path.dart';
import 'package:famka/provider/auth_provider.dart';
import 'package:famka/services/local_storage.dart';
import 'package:famka/utils/app_snackbar.dart';
import 'package:famka/utils/form_validator.dart';
import 'package:famka/view/widgets/social_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../widgets/auth_text_form_field.dart';
import '../widgets/custom_elevated_button.dart';

class LogInScreen extends ConsumerStatefulWidget {
  const LogInScreen({super.key});

  @override
  ConsumerState<LogInScreen> createState() => _LogInScreenState();
}

class _LogInScreenState extends ConsumerState<LogInScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _rememberMe = false;
  bool _isLoading = false;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _loadRememberedEmail();
  }

  Future<void> _loadRememberedEmail() async {
    final email = await LocalStorage.remembered_email.get();
    if (!mounted || email == null || email.isEmpty) return;
    setState(() {
      _emailController.text = email;
      _rememberMe = true;
    });
  }

  Future<void> _handleLogin() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final email = _emailController.text.trim();
    setState(() => _isLoading = true);
    try {
      await ref.read(authProvider.notifier).logIn(
            email: email,
            password: _passwordController.text,
          );
      // Persist the email only while Remember Me is checked.
      if (_rememberMe) {
        await LocalStorage.remembered_email.set(email);
      } else {
        await LocalStorage.remembered_email.remove();
      }
      if (mounted) context.go(AppRoutes.home);
    } catch (e) {
      if (mounted) {
        AppSnackbar.show(message: '$e', type: SnackType.error);
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }
  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
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
          child: Form(
            key: _formKey,
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
                  'Welcome Back!',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: const Color(0XFF_B3B3B8),
                    fontSize: 24.sp,
                  ),
                ),
                SizedBox(height: 8.h),
                Text(
                  'Log In',
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: const Color(0xff_B3B3B8),
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(height: 48.h),

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
                  hintText: 'Enter Email Address',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  validator: FormValidator.validateEmail,
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
                  hintText: 'Enter Password',
                  controller: _passwordController,
                  isPassword: true,
                  validator: FormValidator.validatePassword,
                ),

                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 24.w,
                          height: 24.w,
                          child: Checkbox(
                            value: _rememberMe,
                            onChanged: (val) {
                              setState(() {
                                _rememberMe = val ?? false;
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
                        Text(
                          'Remember Me',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12.sp,
                          ),
                        ),
                      ],
                    ),
                    TextButton(
                      onPressed: () => context.push(AppRoutes.forgotPassword),
                      style: TextButton.styleFrom(
                        padding: EdgeInsets.zero,
                        minimumSize: Size.zero,
                        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                      child: Text(
                        'Forget Password?',
                        style: TextStyle(color: c.primary, fontSize: 12.sp),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 32.h),

                CustomElevatedButton(
                  onPressed: _handleLogin,
                  title: 'Log In',
                  color: c.primary,
                  textColor: c.onPrimary,
                  isLoading: _isLoading,
                ),

                SizedBox(height: 16.h),

                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Don't have an account? ",
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    ),
                    GestureDetector(
                      onTap: () => context.push(AppRoutes.register),
                      child: Text(
                        'Register Now',
                        style: TextStyle(color: c.primary, fontSize: 13.sp),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 48.h),

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
      ),
    );
  }
}
