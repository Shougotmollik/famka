import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';

enum QuizDifficulty { easy, medium, hard }

extension QuizDifficultyX on QuizDifficulty {
  String get label {
    switch (this) {
      case QuizDifficulty.easy:
        return 'Easy';
      case QuizDifficulty.medium:
        return 'Medium';
      case QuizDifficulty.hard:
        return 'Hard';
    }
  }

  String get letter {
    switch (this) {
      case QuizDifficulty.easy:
        return 'E';
      case QuizDifficulty.medium:
        return 'M';
      case QuizDifficulty.hard:
        return 'H';
    }
  }
}

Future<QuizDifficulty?> showQuizDifficultyDialog(BuildContext context) {
  return showDialog<QuizDifficulty>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => const QuizDifficultyDialog(),
  );
}

class QuizDifficultyDialog extends StatefulWidget {
  const QuizDifficultyDialog({super.key});

  @override
  State<QuizDifficultyDialog> createState() => _QuizDifficultyDialogState();
}

class _QuizDifficultyDialogState extends State<QuizDifficultyDialog> {
  QuizDifficulty _selected = QuizDifficulty.easy;

  void _selectAndClose(QuizDifficulty difficulty) {
    Navigator.of(context).pop(difficulty);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF232832),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(20.r),
      ),
      insetPadding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Padding(
        padding: EdgeInsets.all(20.w),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Choose your quiz difficulty',
              style: TextStyle(
                fontSize: 16.sp,
                fontWeight: FontWeight.w700,
                color: Colors.white,
              ),
            ),
            SizedBox(height: 16.h),
            ...QuizDifficulty.values.map(
              (difficulty) => Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _DifficultyOption(
                  difficulty: difficulty,
                  isSelected: _selected == difficulty,
                  onTap: () {
                    setState(() => _selected = difficulty);
                    _selectAndClose(difficulty);
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  final QuizDifficulty difficulty;
  final bool isSelected;
  final VoidCallback onTap;

  const _DifficultyOption({
    required this.difficulty,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFF2C323E),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(color: const Color(0xFF3A4150)),
          ),
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 12.h),
            child: Row(
              children: [
                Container(
                  width: 32.w,
                  height: 32.w,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: const Color(0xFF3A4150)),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    difficulty.letter,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF8B8E95),
                    ),
                  ),
                ),
                SizedBox(width: 12.w),
                Expanded(
                  child: Text(
                    difficulty.label,
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
                if (isSelected)
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration:  BoxDecoration(
                      color: Color(0xFF_233534),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF_2F4345)),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset("assets/icons/tick.svg",height: 15.w,width: 15.w,),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
