import 'package:famka/config/routes/router_path.dart';
import 'package:famka/provider/auth_provider.dart';
import 'package:famka/provider/user_provider.dart';
import 'package:famka/utils/app_snackbar.dart';
import 'package:famka/utils/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'widgets/logout_dialog.dart';
import 'widgets/settings_profile_header.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';
import 'widgets/time_picker_dialog.dart';

class SettingsScreen extends ConsumerStatefulWidget {
  const SettingsScreen({super.key});

  @override
  ConsumerState<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends ConsumerState<SettingsScreen> {
  // bool _pushNotifications = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  // String get _reminderLabel {
  //   final h = _reminderTime.hourOfPeriod == 0 ? 12 : _reminderTime.hourOfPeriod;
  //   final m = _reminderTime.minute.toString().padLeft(2, '0');
  //   final period = _reminderTime.period == DayPeriod.am ? 'AM' : 'PM';
  //   return '$h:$m $period';
  // }

  @override
  Widget build(BuildContext context) {
    final userState = ref.watch(userProvider);

    return userState.when(
      data: (user) {
        return Scaffold(
          appBar: AppBar(
            title: Text(
              'Settings',
              style: TextStyle(
                fontSize: 20.sp,
                fontWeight: FontWeight.w500,
                color: Colors.white,
                fontFamily: 'Poppins',
              ),
            ),
            centerTitle: true,
          ),
          body: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: 20.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: 20.h),
                SettingsProfileHeader(
                  name: user.fullName,
                  email: user.email,
                  imageUrl: user.avatar,
                  onEditTap: () async {
                    showImagePickerOptions(context, (source) async {
                      final image = await pickSingleImage(
                        context: context,
                        source: source,
                        compress: true,
                      );
                      if (image != null) {
                        await ref
                            .read(userProvider.notifier)
                            .updateProfile(profileImage: image);
                      } else {
                        AppSnackbar.show(
                          message: 'Failed to update profile picture',
                          type: SnackType.error,
                        );
                      }
                    });
                  },
                ),
                SizedBox(height: 28.h),
                SettingsSection(
                  label: 'Notification',
                  children: [
                    SettingsTile(
                      svgAsset: 'assets/icons/Bell.svg',
                      iconColor: const Color(0xFF_F79009),
                      title: 'Push Notifications',
                      trailing: Switch(
                        value: user.pushNotification,
                        onChanged: (value) async {
                          final success = await ref
                              .read(userProvider.notifier)
                              .updateProfile(pushNotification: value);
                          if (!success) {
                            AppSnackbar.show(
                              message:
                                  "Failed to update push notification settings",
                              type: SnackType.warning,
                            );
                          }
                        },
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFF7B2FC4),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFF3A4150),
                      ),
                    ),
                    SettingsTile(
                      svgAsset: 'assets/icons/reminder.svg',
                      iconColor: const Color(0xFF_F79009),
                      title: 'Daily Reminder',
                      trailing: Switch(
                        value: user.dailyReminder,
                        onChanged: (value) async {
                          final success = await ref
                              .read(userProvider.notifier)
                              .updateProfile(dailyRemider: value);
                          if (!success) {
                            AppSnackbar.show(
                              message:
                                  "Failed to update daily reminder settings",
                              type: SnackType.warning,
                            );
                          }
                        },
                        activeColor: Colors.white,
                        activeTrackColor: const Color(0xFF7B2FC4),
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: const Color(0xFF3A4150),
                      ),
                    ),
                    SettingsTile(
                      svgAsset: 'assets/icons/clock.svg',
                      iconColor: const Color(0xFF_F79009),
                      title: 'Reminder Time',
                      trailingText: user.reminderTime != null
                          ? formatReminderTime(user.reminderTime)
                          : "Not Set",
                      onTap: _onSetReminder,
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                SettingsSection(
                  label: 'Support',
                  children: [
                    SettingsTile(
                      svgAsset: 'assets/icons/shield.svg',
                      iconColor: const Color(0xFF_7C83FD),
                      title: 'Privacy Policy',
                      showChevron: true,
                      onTap: () => context.push(AppRoutes.privacyPolicy),
                    ),
                    SettingsTile(
                      svgAsset: 'assets/icons/Document.svg',
                      iconColor: const Color(0xFF_7C83FD),
                      title: 'Terms and Condition',
                      showChevron: true,
                      onTap: () => context.push(AppRoutes.termsCondition),
                    ),
                  ],
                ),
                SizedBox(height: 20.h),
                SettingsSection(
                  label: 'Exit',
                  children: [
                    SettingsTile(
                      svgAsset: 'assets/icons/Logout.svg',
                      iconColor: const Color(0xFF_F04438),
                      title: 'Log out',
                      titleColor: const Color(0xFF_F04438),
                      onTap: _onLogout,
                    ),
                  ],
                ),
                SizedBox(height: 40.h),
              ],
            ),
          ),
        );
      },
      error: (error, stackTrace) {
        return Scaffold(body: Center(child: Text('Some things wents wrong')));
      },
      loading: () {
        return Scaffold(
          appBar: AppBar(title: const Text("Settings")),
          body: const Center(child: CircularProgressIndicator()),
        );
      },
    );
  }

  void _onSetReminder() async {
    final user = ref.read(userProvider).value;

    if (user?.reminderTime != null) {
      final parts = user!.reminderTime!.split(':');
      if (parts.length >= 2) {
        _reminderTime = TimeOfDay(
          hour: int.parse(parts[0]),
          minute: int.parse(parts[1]),
        );
      }
    }

    final result = await ReminderTimePickerDialog.show(
      context,
      initialTime: _reminderTime,
    );

    if (result == null) return;

    setState(() => _reminderTime = result);

    final hour = result.hour.toString().padLeft(2, '0');
    final minute = result.minute.toString().padLeft(2, '0');

    final success = await ref
        .read(userProvider.notifier)
        .updateProfile(reminderTime: '$hour:$minute:00');

    if (!success) {
      AppSnackbar.show(
        message: "Failed to update daily reminder settings",
        type: SnackType.warning,
      );
    }
  }

  void _onLogout() {
    LogoutDialog.show(
      context,
      onConfirm: () async {
        await ref.read(authProvider.notifier).logout();
        if (mounted) context.go(AppRoutes.logIn);
      },
    );
  }
}

String formatReminderTime(String? time) {
  if (time == null || time.isEmpty) return "Not Set";

  final parts = time.split(':');
  if (parts.length < 2) return "Not Set";

  final dateTime = DateTime(
    2000,
    1,
    1,
    int.parse(parts[0]),
    int.parse(parts[1]),
  );

  final tod = TimeOfDay.fromDateTime(dateTime);

  final hour = tod.hourOfPeriod == 0 ? 12 : tod.hourOfPeriod;
  final minute = tod.minute.toString().padLeft(2, '0');
  final period = tod.period == DayPeriod.am ? 'AM' : 'PM';

  return '$hour:$minute $period';
}
