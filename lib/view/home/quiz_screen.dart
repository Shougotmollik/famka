import 'package:famka/config/routes/router_path.dart';
import 'package:famka/config/theme/app_colors.dart';
import 'package:famka/models/quiz.dart';
import 'package:famka/provider/quiz_provider.dart';
import 'package:famka/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import 'widgets/quiz_explanation_box.dart';
import 'widgets/quiz_option_tile.dart';
import 'widgets/quiz_progress_dots.dart';

class QuizScreen extends ConsumerStatefulWidget {
  const QuizScreen({super.key, this.storyId, this.difficulty, this.title});

  final String? storyId;
  final String? difficulty;
  final String? title;

  @override
  ConsumerState<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends ConsumerState<QuizScreen> {
  int _currentIndex = 0;
  String? _selectedKey;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      _fetchQuiz();
    });
  }

  void _fetchQuiz() {
    final storyId = widget.storyId;
    final difficulty = widget.difficulty;
    if (storyId == null || difficulty == null) return;
    ref
        .read(quizProvider.notifier)
        .fetchQuiz(storyId: storyId, difficulty: difficulty);
  }

  void _select(String key) {
    if (_selectedKey != null) return;
    setState(() => _selectedKey = key);
  }

  void _next(List<QuizQuestionModel> questions) {
    final isLast = _currentIndex == questions.length - 1;
    if (isLast) {
      context.push(AppRoutes.quizResult);
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedKey = null;
    });
  }

  QuizOptionState _stateFor(QuizOptionModel option, String? correctKey) {
    if (_selectedKey == null) return QuizOptionState.idle;
    if (option.optionKey == correctKey) return QuizOptionState.correct;
    if (option.optionKey == _selectedKey) return QuizOptionState.incorrect;
    return QuizOptionState.idle;
  }

  @override
  Widget build(BuildContext context) {
    final quizAsync = ref.watch(quizProvider);

    return quizAsync.when(
      skipLoadingOnRefresh: true,
      loading: () => const _QuizScaffold(child: _QuizLoading()),
      error: (error, stackTrace) =>
          _QuizScaffold(child: _QuizError(onRetry: _fetchQuiz)),
      data: (response) {
        final questions = response.questions;
        if (questions.isEmpty) {
          return _QuizScaffold(child: _QuizError(onRetry: _fetchQuiz));
        }
        // Guard against a refresh that returns fewer questions while the
        // user is partway through the quiz.
        if (_currentIndex >= questions.length) {
          _currentIndex = questions.length - 1;
        }

        final question = questions[_currentIndex];
        final correctKey = question.options
            .where((o) => o.isCorrect)
            .map((o) => o.optionKey)
            .firstOrNull;

        return Scaffold(
          backgroundColor: AppColors.bgColor,
          body: SafeArea(
            child: Column(
              children: [
                _QuizAppBar(onBack: () => Navigator.pop(context)),
                Expanded(
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(horizontal: 20.w),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(height: 16.h),
                        _QuizHeader(
                          title: widget.title ?? question.difficulty,
                          total: questions.length,
                          current: _currentIndex,
                        ),
                        SizedBox(height: 24.h),
                        _QuizQuestionSection(
                          index: _currentIndex,
                          total: questions.length,
                          question: question.questionText,
                        ),
                        SizedBox(height: 20.h),
                        ...question.options.map(
                          (opt) => Padding(
                            padding: EdgeInsets.only(bottom: 12.h),
                            child: QuizOptionTile(
                              label: opt.optionKey.toUpperCase(),
                              text: opt.optionText,
                              state: _stateFor(opt, correctKey),
                              onTap: () => _select(opt.optionKey),
                            ),
                          ),
                        ),
                        if (_selectedKey != null &&
                            question.explanation.isNotEmpty) ...[
                          SizedBox(height: 4.h),
                          QuizExplanationBox(text: question.explanation),
                        ],
                        SizedBox(height: 24.h),
                      ],
                    ),
                  ),
                ),
                _QuizBottomBar(
                  label: _currentIndex == questions.length - 1
                      ? 'Submit'
                      : 'Next',
                  onNext: () => _next(questions),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _QuizScaffold extends StatelessWidget {
  const _QuizScaffold({required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(child: child),
    );
  }
}

class _QuizLoading extends StatelessWidget {
  const _QuizLoading();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(
        color: AppColors.primary,
        strokeWidth: 3,
      ),
    );
  }
}

class _QuizError extends StatelessWidget {
  const _QuizError({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 32.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.cloud_off_rounded, size: 48.w, color: Colors.white38),
            SizedBox(height: 12.h),
            Text(
              'Could not load the quiz',
              style: TextStyle(
                fontSize: 15.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            CustomElevatedButton(
              title: 'Retry',
              color: AppColors.primary,
              textColor: Colors.white,
              onPressed: onRetry,
            ),
          ],
        ),
      ),
    );
  }
}

class _QuizAppBar extends StatelessWidget {
  const _QuizAppBar({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: onBack,
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: const Color(0xFF2A2F3B),
                ),
                child: Icon(
                  Icons.chevron_left,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ),
          Text(
            'Questions',
            style: TextStyle(
              fontSize: 18.sp,
              fontWeight: FontWeight.w600,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuizHeader extends StatelessWidget {
  const _QuizHeader({
    required this.title,
    required this.total,
    required this.current,
  });

  final String title;
  final int total;
  final int current;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 15.sp,
            fontWeight: FontWeight.w700,
            color: Colors.white,
          ),
        ),
        SizedBox(height: 10.h),
        QuizProgressDots(total: total, current: current),
      ],
    );
  }
}

class _QuizQuestionSection extends StatelessWidget {
  const _QuizQuestionSection({
    required this.index,
    required this.total,
    required this.question,
  });

  final int index;
  final int total;
  final String question;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Question ${index + 1} out of $total',
          style: TextStyle(fontSize: 13.sp, color: Colors.white54),
        ),
        SizedBox(height: 6.h),
        Text(
          question,
          style: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: Colors.white,
            height: 1.4,
          ),
        ),
      ],
    );
  }
}

class _QuizBottomBar extends StatelessWidget {
  const _QuizBottomBar({required this.label, required this.onNext});

  final String label;
  final VoidCallback onNext;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(20.w, 12.h, 20.w, 16.h),
      color: AppColors.bgColor,
      child: CustomElevatedButton(
        title: label,
        color: AppColors.primary,
        textColor: Colors.white,
        onPressed: onNext,
      ),
    );
  }
}
