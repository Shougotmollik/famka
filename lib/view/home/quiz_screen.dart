import 'package:famka/config/router_path.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../config/app_colors.dart';
import '../../models/quiz_model.dart';
import '../widgets/custom_elevated_button.dart';
import 'widgets/quiz_explanation_box.dart';
import 'widgets/quiz_option_tile.dart';
import 'widgets/quiz_progress_dots.dart';

const _sampleQuiz = QuizModel(
  title: 'Radio Interview: Climate',
  questions: [
    QuizQuestion(
      question: 'Who mentioned that the meeting was postponed to Friday?',
      correctLabel: 'B',
      explanation:
          'Good! The climatologist gave the specific number of degrees.',
      options: [
        QuizOption(label: 'A', text: 'Anna'),
        QuizOption(label: 'B', text: 'Marek'),
        QuizOption(label: 'C', text: 'Zofia'),
        QuizOption(label: 'D', text: 'None of them'),
      ],
    ),
    QuizQuestion(
      question: 'What temperature increase was specifically mentioned?',
      correctLabel: 'C',
      explanation: 'Correct! A 1.5°C increase was the threshold discussed.',
      options: [
        QuizOption(label: 'A', text: '0.5°C'),
        QuizOption(label: 'B', text: '1.0°C'),
        QuizOption(label: 'C', text: '1.5°C'),
        QuizOption(label: 'D', text: '2.0°C'),
      ],
    ),
    QuizQuestion(
      question: 'Which topic was the main focus of the radio interview?',
      correctLabel: 'A',
      explanation:
          'Right! Climate change and its effects were the central theme.',
      options: [
        QuizOption(label: 'A', text: 'Climate change'),
        QuizOption(label: 'B', text: 'Water pollution'),
        QuizOption(label: 'C', text: 'Air quality'),
        QuizOption(label: 'D', text: 'Deforestation'),
      ],
    ),
    QuizQuestion(
      question: 'Who was the expert guest on the radio show?',
      correctLabel: 'D',
      explanation: 'Correct! A climatologist was invited as the expert guest.',
      options: [
        QuizOption(label: 'A', text: 'A biologist'),
        QuizOption(label: 'B', text: 'A geologist'),
        QuizOption(label: 'C', text: 'An astronomer'),
        QuizOption(label: 'D', text: 'A climatologist'),
      ],
    ),
    QuizQuestion(
      question: 'What action was agreed upon at the end of the interview?',
      correctLabel: 'B',
      explanation: 'Well done! A follow-up meeting was scheduled.',
      options: [
        QuizOption(label: 'A', text: 'Publish a report'),
        QuizOption(label: 'B', text: 'Schedule a follow-up'),
        QuizOption(label: 'C', text: 'Start a campaign'),
        QuizOption(label: 'D', text: 'No action taken'),
      ],
    ),
  ],
);

class QuizScreen extends StatefulWidget {
  const QuizScreen({super.key, this.quiz = _sampleQuiz});

  final QuizModel quiz;

  @override
  State<QuizScreen> createState() => _QuizScreenState();
}

class _QuizScreenState extends State<QuizScreen> {
  int _currentIndex = 0;
  String? _selectedLabel;

  QuizQuestion get _currentQuestion => widget.quiz.questions[_currentIndex];
  bool get _answered => _selectedLabel != null;

  void _select(String label) {
    if (_answered) return;
    setState(() => _selectedLabel = label);
  }

  void _next() {
    final isLast = _currentIndex == widget.quiz.questions.length - 1;
    if (isLast) {
      context.push(AppRoutes.quizResult);
      return;
    }
    setState(() {
      _currentIndex++;
      _selectedLabel = null;
    });
  }

  QuizOptionState _stateFor(String label) {
    if (_selectedLabel == null) return QuizOptionState.idle;
    if (label == _currentQuestion.correctLabel) return QuizOptionState.correct;
    if (label == _selectedLabel) return QuizOptionState.incorrect;
    return QuizOptionState.idle;
  }

  @override
  Widget build(BuildContext context) {
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
                      title: widget.quiz.title,
                      total: widget.quiz.questions.length,
                      current: _currentIndex,
                    ),
                    SizedBox(height: 24.h),
                    _QuizQuestionSection(
                      index: _currentIndex,
                      total: widget.quiz.questions.length,
                      question: _currentQuestion.question,
                    ),
                    SizedBox(height: 20.h),
                    ..._currentQuestion.options.map(
                      (opt) => Padding(
                        padding: EdgeInsets.only(bottom: 12.h),
                        child: QuizOptionTile(
                          label: opt.label,
                          text: opt.text,
                          state: _stateFor(opt.label),
                          onTap: () => _select(opt.label),
                        ),
                      ),
                    ),
                    if (_answered && _currentQuestion.explanation != null) ...[
                      SizedBox(height: 4.h),
                      QuizExplanationBox(text: _currentQuestion.explanation!),
                    ],
                    SizedBox(height: 24.h),
                  ],
                ),
              ),
            ),
            _QuizBottomBar(
              label: _currentIndex == widget.quiz.questions.length - 1
                  ? 'Submit'
                  : 'Next',
              onNext: _next,
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
