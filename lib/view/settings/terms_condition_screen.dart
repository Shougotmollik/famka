import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'widgets/policy_content.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

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
              title: '1. Acceptance of Terms',
              children: [
                PolicyBody(
                  'By creating an account and using the application, you agree to comply with these Terms and Conditions. If you do not agree with any part of these terms, please do not use the app.',
                ),
              ],
            ),
            PolicySection(
              title: '2. User Accounts',
              children: [
                PolicyBody(
                  'To access certain features of the app, you may be required to create an account. You are responsible for:',
                ),
                SizedBox(height: 4),
                PolicyBullet('Providing accurate and up-to-date information.'),
                PolicyBullet(
                  'Maintaining the confidentiality of your login credentials.',
                ),
                PolicyBullet('All activities that occur under your account.'),
                SizedBox(height: 6),
                PolicyBody(
                  'You are responsible for keeping your account information secure and notifying us immediately of any unauthorized use.',
                ),
              ],
            ),
            PolicySection(
              title: '3. Use of the Application',
              children: [
                PolicyBody(
                  'The app is designed to help users improve their focus, concentration, active listening, and memory skills through interactive listening exercises and quizzes.',
                ),
                SizedBox(height: 6),
                PolicyBody('By using the app, you agree to:'),
                SizedBox(height: 4),
                PolicyBullet('Use the application only for lawful purposes.'),
                PolicyBullet(
                  "Not misuse or attempt to interfere with the app's functionality.",
                ),
                PolicyBullet(
                  'Not copy, distribute, or modify any content without permission.',
                ),
                PolicyBullet(
                  'Respect the intellectual property rights associated with the application.',
                ),
              ],
            ),
            PolicySection(
              title: '4. Learning Progress and Statistics',
              children: [
                PolicyBody(
                  'The application may store information related to your learning activities, including:',
                ),
                SizedBox(height: 4),
                PolicyBullet('Listening session progress.'),
                PolicyBullet('Quiz results and scores.'),
                PolicyBullet('Focus and concentration statistics.'),
                PolicyBullet('Achievement badges and milestones.'),
                PolicyBullet('Listening time and activity history.'),
                SizedBox(height: 6),
                PolicyBody(
                  'This information is used to provide personalized learning experiences and track your progress.',
                ),
              ],
            ),
            PolicySection(
              title: '5. Modifications to the App',
              children: [
                PolicyBody(
                  'We reserve the right to modify, suspend, or discontinue the app or any of its features at any time without prior notice. We are not liable for any changes or interruptions to the service.',
                ),
              ],
            ),
            PolicySection(
              title: '6. Termination',
              children: [
                PolicyBody(
                  'We reserve the right to suspend or terminate your account if you violate these Terms and Conditions or engage in any behavior that is harmful to other users or the application.',
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
        'Terms and Condition',
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
