import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/routes/router_path.dart';
import '../../provider/user_provider.dart';
import '../../utils/app_snackbar.dart';
import '../../utils/image_picker.dart';
import '../widgets/custom_elevated_button.dart';

class UploadProfileImageScreen extends ConsumerStatefulWidget {
  const UploadProfileImageScreen({super.key});

  @override
  ConsumerState<UploadProfileImageScreen> createState() =>
      _UploadProfileImageScreenState();
}

class _UploadProfileImageScreenState
    extends ConsumerState<UploadProfileImageScreen> {
  File? _selectedImage;
  bool _isUploading = false;

  void _pickImage() {
    showImagePickerOptions(context, (source) async {
      final file = await pickSingleImage(
        context: context,
        source: source,
        compress: true,
      );
      if (file != null && mounted) {
        setState(() => _selectedImage = file);
      }
    });
  }

  Future<void> _handleUpload() async {
    final image = _selectedImage;
    if (image == null) {
      AppSnackbar.show(
        message: 'Please select a profile picture first',
        type: SnackType.warning,
      );
      return;
    }

    setState(() => _isUploading = true);
    try {
      final success = await ref
          .read(userProvider.notifier)
          .updateProfile(profileImage: image);
      if (!mounted) return;
      if (success) {
        AppSnackbar.show(
          message: 'Profile picture updated successfully',
          type: SnackType.success,
        );
        context.go(AppRoutes.home);
      } else {
        AppSnackbar.show(
          message: 'Could not update profile picture. Please try again.',
          type: SnackType.error,
        );
      }
    } finally {
      if (mounted) setState(() => _isUploading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final c = theme.colorScheme;

    return Scaffold(
      backgroundColor: c.surface,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 32.h),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(height: 20.h),
              Text(
                'Upload Profile Picture',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontWeight: FontWeight.w700,
                  color: Colors.white,
                  fontSize: 24.sp,
                ),
              ),
              SizedBox(height: 12.h),
              Text(
                'You can choose it from your gallery',
                textAlign: TextAlign.center,
                style: TextStyle(color: Colors.grey.shade400, fontSize: 14.sp),
              ),
              SizedBox(height: 20.h),

              Center(
                child: GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    width: 100.w,
                    height: 100.w,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.grey.shade600, width: 1),
                      image: _selectedImage != null
                          ? DecorationImage(
                              image: FileImage(_selectedImage!),
                              fit: BoxFit.cover,
                            )
                          : null,
                    ),
                    alignment: Alignment.center,
                    child: _selectedImage == null
                        ? SvgPicture.asset(
                            'assets/icons/assets_Picker.svg',
                            width: 32.w,
                            height: 32.w,
                          )
                        : null,
                  ),
                ),
              ),

              if (_selectedImage != null)
                Padding(
                  padding: EdgeInsets.only(top: 12.h),
                  child: Center(
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: Text(
                        'Change photo',
                        style: TextStyle(
                          fontSize: 14.sp,
                          color: c.primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                ),

              const Spacer(),

              CustomElevatedButton(
                onPressed: _handleUpload,
                title: 'Upload',
                color: c.primary,
                textColor: Colors.white,
                isLoading: _isUploading,
              ),

              SizedBox(height: 16.h),

              Center(
                child: TextButton(
                  onPressed: () => context.go(AppRoutes.home),
                  style: TextButton.styleFrom(foregroundColor: Colors.white),
                  child: Text(
                    'Skip',
                    style: TextStyle(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
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
