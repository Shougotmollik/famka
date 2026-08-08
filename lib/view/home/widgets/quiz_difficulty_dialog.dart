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

  static QuizDifficulty fromApiKey(String key) {
    switch (key.toUpperCase()) {
      case 'EASY':
        return QuizDifficulty.easy;
      case 'MEDIUM':
        return QuizDifficulty.medium;
      case 'HARD':
        return QuizDifficulty.hard;
      default:
        return QuizDifficulty.easy;
    }
  }
}

Future<QuizDifficulty?> showQuizDifficultyDialog(
  BuildContext context, {
  Map<QuizDifficulty, bool> attempted = const {},
}) {
  return showDialog<QuizDifficulty>(
    context: context,
    barrierColor: Colors.black54,
    builder: (context) => QuizDifficultyDialog(attempted: attempted),
  );
}

class QuizDifficultyDialog extends StatefulWidget {
  const QuizDifficultyDialog({super.key, this.attempted = const {}});

  final Map<QuizDifficulty, bool> attempted;

  @override
  State<QuizDifficultyDialog> createState() => _QuizDifficultyDialogState();
}

class _QuizDifficultyDialogState extends State<QuizDifficultyDialog> {
  late QuizDifficulty _selected;

  @override
  void initState() {
    super.initState();
    _selected = QuizDifficulty.values.firstWhere(
      (d) => !(widget.attempted[d] ?? false),
      orElse: () => QuizDifficulty.easy,
    );
  }

  void _selectAndClose(QuizDifficulty difficulty) {
    Navigator.of(context).pop(difficulty);
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: const Color(0xFF232832),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.r)),
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
            ...QuizDifficulty.values.map((difficulty) {
              final isAttempted = widget.attempted[difficulty] ?? false;
              return Padding(
                padding: EdgeInsets.only(bottom: 8.h),
                child: _DifficultyOption(
                  difficulty: difficulty,
                  isSelected: _selected == difficulty,
                  isAttempted: isAttempted,
                  onTap: () {
                    setState(() => _selected = difficulty);
                    _selectAndClose(difficulty);
                  },
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}

class _DifficultyOption extends StatelessWidget {
  final QuizDifficulty difficulty;
  final bool isSelected;
  final bool isAttempted;
  final VoidCallback? onTap;

  const _DifficultyOption({
    required this.difficulty,
    required this.isSelected,
    required this.isAttempted,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final accent = isAttempted
        ? const Color(0xFF22B07D)
        : const Color(0xFF8B8E95);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20.r),
        child: Ink(
          decoration: BoxDecoration(
            color: const Color(0xFF2C323E),
            borderRadius: BorderRadius.circular(20.r),
            border: Border.all(
              color: isAttempted
                  ? const Color(0xFF22B07D)
                  : const Color(0xFF3A4150),
            ),
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
                    color: isAttempted
                        ? const Color(0xFF1E2B2C)
                        : Colors.transparent,
                    border: Border.all(
                      color: isAttempted
                          ? const Color(0xFF22B07D)
                          : const Color(0xFF3A4150),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: isAttempted
                      ? SvgPicture.asset(
                          'assets/icons/tick.svg',
                          height: 15.w,
                          width: 15.w,
                          colorFilter: ColorFilter.mode(
                            const Color(0xFF22B07D),
                            BlendMode.srcIn,
                          ),
                        )
                      : Text(
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
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        difficulty.label,
                        style: TextStyle(
                          fontSize: 14.sp,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                      if (isAttempted)
                        Text(
                          'Completed',
                          style: TextStyle(
                            fontSize: 11.sp,
                            fontWeight: FontWeight.w500,
                            color: accent,
                          ),
                        ),
                    ],
                  ),
                ),
                if (isSelected)
                  Icon(
                    Icons.check_circle_rounded,
                    size: 20.w,
                    color: isAttempted
                        ? const Color(0xFF22B07D)
                        : const Color(0xFF8E35E1),
                  )
                else if (isAttempted)
                  Container(
                    width: 24.w,
                    height: 24.w,
                    decoration: BoxDecoration(
                      color: const Color(0xFF233534),
                      shape: BoxShape.circle,
                      border: Border.all(color: const Color(0xFF2F4345)),
                    ),
                    alignment: Alignment.center,
                    child: SvgPicture.asset(
                      'assets/icons/tick.svg',
                      height: 15.w,
                      width: 15.w,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
