import 'package:famka/config/theme/app_colors.dart';
import 'package:famka/view/settings/widgets/policy_content.dart';
import 'package:flutter/material.dart';

class TermsConditionScreen extends StatelessWidget {
  const TermsConditionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      appBar: const PolicyAppBar(title: 'Terms and Condition'),
      body: PolicyContent(
        fetch: (notifier) => notifier.fetchTermsCondition(),
      ),
    );
  }
}
