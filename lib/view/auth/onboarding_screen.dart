import 'package:famka/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/theme/app_colors.dart';
import '../../config/routes/router_path.dart';

// ─── Page data ───────────────────────────────────────────────────────────────

class _PageData {
  final String svgPath;
  final String title;
  final String description;
  final bool isLogo;

  const _PageData({
    required this.svgPath,
    required this.title,
    required this.description,
    this.isLogo = false,
  });
}

const _pages = [
  _PageData(
    svgPath: 'assets/icons/onboarding1.svg',
    title: 'FAMKA',
    isLogo: true,
    description:
        'Improve focus by following real conversations between multiple speakers. Every session sharpens your attention.',
  ),
  _PageData(
    svgPath: 'assets/icons/onboarding2.svg',
    title: 'Recognize Every Voice',
    description:
        'Remember who said what. Track ideas, and build an accurate mental map of every conversation.',
  ),
  _PageData(
    svgPath: 'assets/icons/onboarding3.svg',
    title: 'Build Your Focus',
    description:
        'Track your daily streak, earn badges, and watch your concentration scores climb over time.',
  ),
];

// ─── Screen ──────────────────────────────────────────────────────────────────

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  int _currentPage = 0;
  int _previousPage = 0;
  bool _isBusy = false;

  // ── Entry animation (first load) ──────────────────────────────────────────
  late final AnimationController _entryCtrl;
  late final Animation<double> _entryFade;
  late final Animation<Offset> _entrySlide;
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  // ── Page-switch animation ─────────────────────────────────────────────────
  late final AnimationController _switchCtrl;
  late final Animation<double> _outFade;
  late final Animation<double> _inFade;

  // ── Drag / swipe tracking ─────────────────────────────────────────────────
  double _dragStartX = 0;

  @override
  void initState() {
    super.initState();

    // Entry
    _entryCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );
    _entryFade = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.0, 0.6, curve: Curves.easeOut),
    );
    _entrySlide = Tween<Offset>(begin: const Offset(0, 0.18), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.0, 0.7, curve: Curves.easeOutCubic),
          ),
        );
    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.4), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _entryCtrl,
            curve: const Interval(0.35, 1.0, curve: Curves.easeOutCubic),
          ),
        );
    _buttonFade = CurvedAnimation(
      parent: _entryCtrl,
      curve: const Interval(0.35, 0.9, curve: Curves.easeOut),
    );

    // Switch
    _switchCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 520),
    );

    _outFade = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _switchCtrl,
        curve: const Interval(0.0, 0.38, curve: Curves.easeIn),
      ),
    );

    _inFade = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _switchCtrl,
        curve: const Interval(0.52, 1.0, curve: Curves.easeOut),
      ),
    );

    _entryCtrl.forward();
  }

  @override
  void dispose() {
    _entryCtrl.dispose();
    _switchCtrl.dispose();
    super.dispose();
  }

  // ── Navigation ────────────────────────────────────────────────────────────

  Future<void> _goToPage(int next, {bool forward = true}) async {
    if (_isBusy || next == _currentPage) return;
    _isBusy = true;

    final outEnd = forward ? const Offset(-0.08, 0) : const Offset(0.08, 0);
    final inStart = forward ? const Offset(0.08, 0) : const Offset(-0.08, 0);

    // Store direction for the builder
    _outEndOffset = outEnd;
    _inStartOffset = inStart;

    setState(() => _previousPage = _currentPage);

    _switchCtrl.reset();
    await _switchCtrl.animateTo(0.42, curve: Curves.easeIn);

    if (!mounted) return;
    setState(() => _currentPage = next);

    await _switchCtrl.forward();

    _isBusy = false;
  }

  // Direction offsets accessible in build
  Offset _outEndOffset = const Offset(-0.08, 0);
  Offset _inStartOffset = const Offset(0.08, 0);

  Future<void> _onContinue() async {
    if (_currentPage < _pages.length - 1) {
      await _goToPage(_currentPage + 1, forward: true);
    } else {
      if (mounted) context.go(AppRoutes.logIn);
    }
  }

  void _onSkip() => context.go(AppRoutes.logIn);

  // ── Swipe gesture ─────────────────────────────────────────────────────────

  void _onHorizontalDragStart(DragStartDetails d) {
    _dragStartX = d.globalPosition.dx;
  }

  void _onHorizontalDragEnd(DragEndDetails d) {
    final dx = d.globalPosition.dx - _dragStartX;
    final velocity = d.primaryVelocity ?? 0;

    if ((dx < -40 || velocity < -300) && _currentPage < _pages.length - 1) {
      _goToPage(_currentPage + 1, forward: true);
    } else if ((dx > 40 || velocity > 300) && _currentPage > 0) {
      _goToPage(_currentPage - 1, forward: false);
    }
  }

  // ── Build ─────────────────────────────────────────────────────────────────

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: GestureDetector(
          onHorizontalDragStart: _onHorizontalDragStart,
          onHorizontalDragEnd: _onHorizontalDragEnd,
          behavior: HitTestBehavior.opaque,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 24.w),
            child: Column(
              children: [
                Expanded(
                  child: Column(
                    children: [
                      Expanded(child: _buildContent()),
                      _buildIndicators(),
                    ],
                  ),
                ),
                SizedBox(height: 40.h),
                _buildButtons(),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ── Content area ──────────────────────────────────────────────────────────

  Widget _buildContent() {
    return AnimatedBuilder(
      animation: _switchCtrl,
      builder: (context, _) {
        final t = _switchCtrl.value;
        final switching = _switchCtrl.isAnimating || t > 0;

        // Which page data to show
        final showingNew = t >= 0.42;
        final page = showingNew ? _pages[_currentPage] : _pages[_previousPage];

        // Compute opacity & slide
        double opacity;
        Offset slide;

        if (!switching) {
          opacity = 1.0;
          slide = Offset.zero;
        } else if (t < 0.42) {
          // outgoing
          opacity = _outFade.value;
          final frac = (t / 0.42).clamp(0.0, 1.0);
          final easedFrac = Curves.easeInCubic.transform(frac);
          slide = Offset(easedFrac * _outEndOffset.dx, 0);
        } else {
          // incoming
          opacity = _inFade.value;
          final frac = ((t - 0.48) / 0.52).clamp(0.0, 1.0);
          final easedFrac = Curves.easeOutCubic.transform(frac);
          slide = Offset(_inStartOffset.dx * (1.0 - easedFrac), 0);
        }

        Widget content = FadeTransition(
          opacity: !switching
              ? _entryCtrl.isAnimating
                    ? _entryFade
                    : const AlwaysStoppedAnimation(1.0)
              : AlwaysStoppedAnimation(opacity.clamp(0.0, 1.0)),
          child: SlideTransition(
            position: !switching
                ? _entryCtrl.isAnimating
                      ? _entrySlide
                      : const AlwaysStoppedAnimation(Offset.zero)
                : AlwaysStoppedAnimation(slide),
            child: _buildPageBody(page),
          ),
        );

        return content;
      },
    );
  }

  Widget _buildPageBody(_PageData page) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      key: ValueKey(page.svgPath),
      children: [
        SvgPicture.asset(page.svgPath, width: 120.w, height: 120.w),
        SizedBox(height: 56.h),
        page.isLogo
            ? SvgPicture.asset(
                'assets/logo/applogo.svg',
                height: 32.h,
                colorFilter: const ColorFilter.mode(
                  Colors.white,
                  BlendMode.srcIn,
                ),
              )
            : Text(
                page.title,
                style: TextStyle(
                  fontSize: 26.sp,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                  letterSpacing: -0.5,
                ),
                textAlign: TextAlign.center,
              ),
        SizedBox(height: 16.h),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.w),
          child: Text(
            page.description,
            style: TextStyle(
              fontSize: 14.sp,
              fontWeight: FontWeight.w400,
              color: Theme.of(
                context,
              ).colorScheme.onPrimary.withValues(alpha: 0.6),
              height: 1.5,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ],
    );
  }

  // ── Dots indicator ────────────────────────────────────────────────────────

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(_pages.length, (i) {
        final active = i == _currentPage;
        return AnimatedContainer(
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeOutCubic,
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 6.h,
          width: active ? 28.w : 6.w,
          decoration: BoxDecoration(
            color: active
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }

  // ── Buttons ───────────────────────────────────────────────────────────────

  Widget _buildButtons() {
    return SlideTransition(
      position: _buttonSlide,
      child: FadeTransition(
        opacity: _buttonFade,
        child: Column(
          children: [
            CustomElevatedButton(
              onPressed: _onContinue,
              title: 'Continue',
              color: Theme.of(context).colorScheme.primary,
              textColor: Theme.of(context).colorScheme.onPrimary,
            ),
            SizedBox(height: 16.h),
            TextButton(
              onPressed: _onSkip,
              style: TextButton.styleFrom(
                minimumSize: const Size.fromHeight(50),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24.r),
                ),
              ),
              child: Text(
                'Skip',
                style: TextStyle(
                  fontSize: 14.sp,
                  fontWeight: FontWeight.w600,
                  color: Theme.of(context).colorScheme.onPrimary,
                ),
              ),
            ),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }
}
