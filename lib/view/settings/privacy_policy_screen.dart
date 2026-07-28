import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/policy_content.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1A1E25),
      appBar: _buildAppBar(context),
      body: SingleChildScrollView(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            PolicySection(
              title: '1. Information We Collect',
              children: [
                PolicySubSection(
                  title: '1.1 Account Information',
                  intro: 'When you create an account, we may collect:',
                  bullets: const [
                    'Your name or username',
                    'Email address',
                    'Login credentials',
                  ],
                  footer:
                      'This information is used to create and manage your account securely.',
                ),
                PolicySubSection(
                  title: '1.2 Listening and Learning Data',
                  intro:
                      'While using the app, we may collect information related to your learning progress, including:',
                  bullets: const [
                    'Completed listening sessions',
                    'Quiz results and scores',
                    'Focus and concentration metrics',
                    'Listening time and activity history',
                    'Achievement badges and progress statistics',
                  ],
                  footer:
                      'This information is used to personalize your experience and track your improvement over time.',
                ),
                PolicySubSection(
                  title: '1.3 Usage Information',
                  intro:
                      'We may collect limited information about how you use the app, such as:',
                  bullets: const [
                    'Features and lessons accessed',
                    'Session activity and completion status',
                    'Device type and operating system',
                    'App performance and crash reports',
                  ],
                  footer:
                      "This information helps us improve the app's functionality, performance, and user experience.",
                ),
              ],
            ),
            PolicySection(
              title: '2. How We Use Your Information',
              children: [
                PolicyBody(
                  'We use the collected information solely to provide, improve, and personalize the app experience. We do not sell or share your personal data with third parties for marketing purposes.',
                ),
              ],
            ),
            PolicySection(
              title: '3. Data Security',
              children: [
                PolicyBody(
                  'We take reasonable measures to protect your information from unauthorized access, loss, or misuse. Your data is stored securely and access is limited to authorized personnel only.',
                ),
              ],
            ),
            PolicySection(
              title: '4. Your Rights',
              children: [
                PolicyBody(
                  'You have the right to access, update, or delete your personal information at any time through the app settings or by contacting our support team.',
                ),
              ],
            ),
            PolicySection(
              title: '5. Changes to This Policy',
              children: [
                PolicyBody(
                  'We may update this Privacy Policy from time to time. Any changes will be reflected within the app, and continued use of the app constitutes acceptance of the updated policy.',
                ),
              ],
            ),
            SizedBox(height: 20.h),
          ],
        ),
      ),
    );
  }

  PreferredSizeWidget _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: const Color(0xFF1A1E25),
      elevation: 0,
      centerTitle: true,
      leadingWidth: 64.w,
      leading: Center(
        child: GestureDetector(
          onTap: () => Navigator.of(context).pop(),
          child: Container(
            width: 40.w,
            height: 40.w,
            decoration: BoxDecoration(
              color: const Color(0xFF1F242B),
              shape: BoxShape.circle,
              border: Border.all(color: const Color(0xFF3A4150)),
            ),
            child: Icon(
              Icons.chevron_left_rounded,
              color: Colors.white,
              size: 22.r,
            ),
          ),
        ),
      ),
      title: Text(
        'Privacy Policy',
        style: TextStyle(
          fontSize: 18.sp,
          fontWeight: FontWeight.w700,
          color: Colors.white,
          fontFamily: 'Poppins',
        ),
      ),
    );
  }
}
