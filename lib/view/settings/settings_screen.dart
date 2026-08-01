import 'package:famka/config/routes/router_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'widgets/logout_dialog.dart';
import 'widgets/settings_profile_header.dart';
import 'widgets/settings_section.dart';
import 'widgets/settings_tile.dart';
import 'widgets/time_picker_dialog.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _pushNotifications = true;
  TimeOfDay _reminderTime = const TimeOfDay(hour: 9, minute: 0);

  String get _reminderLabel {
    final h = _reminderTime.hourOfPeriod == 0 ? 12 : _reminderTime.hourOfPeriod;
    final m = _reminderTime.minute.toString().padLeft(2, '0');
    final period = _reminderTime.period == DayPeriod.am ? 'AM' : 'PM';
    return '$h:$m $period';
  }

  @override
  Widget build(BuildContext context) {
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
            const SettingsProfileHeader(
              name: 'Nirjona Akther',
              email: 'nirjonaakther@gmail.com',
              imageUrl:
                  'https://img.freepik.com/free-photo/young-cute-woman-cap-glasses-posing-outside-showing-thumbs-up-high-quality-photo_114579-91847.jpg',
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
                    value: _pushNotifications,
                    onChanged: (v) => setState(() => _pushNotifications = v),
                    activeColor: Colors.white,
                    activeTrackColor: const Color(0xFF7B2FC4),
                    inactiveThumbColor: Colors.white,
                    inactiveTrackColor: const Color(0xFF3A4150),
                  ),
                ),
                SettingsTile(
                  svgAsset: 'assets/icons/clock.svg',
                  iconColor: const Color(0xFF_F79009),
                  title: 'Daily Reminder',
                  trailingText: _reminderLabel,
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
  }

  void _onSetReminder() async {
    final result = await ReminderTimePickerDialog.show(
      context,
      initialTime: _reminderTime,
    );
    if (result != null) setState(() => _reminderTime = result);
  }

  void _onLogout() {
    LogoutDialog.show(
      context,
      onConfirm: () {
        context.go(AppRoutes.logIn);
      },
    );
  }
}
