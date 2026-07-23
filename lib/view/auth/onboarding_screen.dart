import 'package:famka/view/widgets/custom_elevated_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import '../../config/app_colors.dart';
import '../../config/router_path.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with TickerProviderStateMixin {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  // Entry animation
  late final AnimationController _animController;
  late final Animation<Offset> _iconSlide;
  late final Animation<double> _iconFade;
  late final Animation<Offset> _titleSlide;
  late final Animation<double> _titleFade;
  late final Animation<Offset> _descSlide;
  late final Animation<double> _descFade;
  late final Animation<Offset> _buttonSlide;
  late final Animation<double> _buttonFade;

  // Continue button press animation
  late final AnimationController _continueController;
  late final Animation<double> _continueContentScale;
  late final Animation<double> _continueContentFade;

  @override
  void initState() {
    super.initState();

    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _iconSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.0, 0.35, curve: Curves.easeOutCubic),
          ),
        );
    _iconFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.25, curve: Curves.easeIn),
      ),
    );

    _titleSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.2, 0.55, curve: Curves.easeOutCubic),
          ),
        );
    _titleFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.2, 0.45, curve: Curves.easeIn),
      ),
    );

    _descSlide = Tween<Offset>(begin: const Offset(0, 0.25), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.35, 0.7, curve: Curves.easeOutCubic),
          ),
        );
    _descFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.35, 0.6, curve: Curves.easeIn),
      ),
    );

    _buttonSlide = Tween<Offset>(begin: const Offset(0, 0.3), end: Offset.zero)
        .animate(
          CurvedAnimation(
            parent: _animController,
            curve: const Interval(0.5, 0.9, curve: Curves.easeOutCubic),
          ),
        );
    _buttonFade = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.5, 0.8, curve: Curves.easeIn),
      ),
    );

    _continueController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _continueContentScale = Tween<double>(begin: 1.0, end: 0.93).animate(
      CurvedAnimation(parent: _continueController, curve: Curves.easeInOut),
    );
    _continueContentFade = Tween<double>(begin: 1.0, end: 0.85).animate(
      CurvedAnimation(parent: _continueController, curve: Curves.easeOut),
    );

    _continueController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        _doNavigate();
      }
    });

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    _continueController.dispose();
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() {
      _currentPage = index;
    });
  }

  void _onContinue() {
    _continueController.forward();
  }

  void _doNavigate() {
    if (_currentPage < 2) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
      Future.delayed(const Duration(milliseconds: 500), () {
        if (mounted) _continueController.reset();
      });
    } else {
      context.go(AppRoutes.logIn);
    }
  }

  void _onSkip() {
    context.go(AppRoutes.logIn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 24.w),
          child: Column(
            children: [
              Expanded(
                child: Column(
                  children: [
                    Expanded(
                      child: AnimatedBuilder(
                        animation: _continueController,
                        builder: (context, _) {
                          return Opacity(
                            opacity: _continueController.isAnimating
                                ? _continueContentFade.value
                                : 1.0,
                            child: Transform.scale(
                              scale: _continueController.isAnimating
                                  ? _continueContentScale.value
                                  : 1.0,
                              child: PageView(
                                controller: _pageController,
                                onPageChanged: _onPageChanged,
                                physics: const BouncingScrollPhysics(),
                                children: [
                                  _buildPage(
                                    index: 0,
                                    svgPath: 'assets/icons/onboarding1.svg',
                                    title: 'FAMKA',
                                    isLogo: true,
                                    description:
                                        'Improve focus by following real conversations between multiple speakers. Every session sharpens your attention.',
                                    iconSlide: _iconSlide,
                                    iconFade: _iconFade,
                                    titleSlide: _titleSlide,
                                    titleFade: _titleFade,
                                    descSlide: _descSlide,
                                    descFade: _descFade,
                                  ),
                                  _buildPage(
                                    index: 1,
                                    svgPath: 'assets/icons/onboarding2.svg',
                                    title: 'Recognize Every Voice',
                                    description:
                                        'Remember who said what. Track ideas, and build an accurate mental map of every conversation.',
                                    iconSlide: _iconSlide,
                                    iconFade: _iconFade,
                                    titleSlide: _titleSlide,
                                    titleFade: _titleFade,
                                    descSlide: _descSlide,
                                    descFade: _descFade,
                                  ),
                                  _buildPage(
                                    index: 2,
                                    svgPath: 'assets/icons/onboarding3.svg',
                                    title: 'Build Your Focus',
                                    description:
                                        'Track your daily streak, earn badges, and watch your concentration scores climb over time.',
                                    iconSlide: _iconSlide,
                                    iconFade: _iconFade,
                                    titleSlide: _titleSlide,
                                    titleFade: _titleFade,
                                    descSlide: _descSlide,
                                    descFade: _descFade,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    _buildIndicators(),
                  ],
                ),
              ),
              SizedBox(height: 40.h),
              SlideTransition(
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
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIndicators() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(3, (index) {
        return AnimatedContainer(
          duration: const Duration(milliseconds: 300),
          margin: EdgeInsets.symmetric(horizontal: 4.w),
          height: 6.h,
          width: _currentPage == index ? 24.w : 6.h,
          decoration: BoxDecoration(
            color: _currentPage == index
                ? AppColors.primary
                : AppColors.primary.withValues(alpha: 0.2),
            borderRadius: BorderRadius.circular(4.r),
          ),
        );
      }),
    );
  }

  Widget _buildPage({
    required int index,
    required String svgPath,
    required String title,
    required String description,
    bool isLogo = false,
    Animation<Offset>? iconSlide,
    Animation<double>? iconFade,
    Animation<Offset>? titleSlide,
    Animation<double>? titleFade,
    Animation<Offset>? descSlide,
    Animation<double>? descFade,
  }) {
    return _PageSwipeWrapper(
      index: index,
      controller: _pageController,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _animated(
            slide: iconSlide,
            fade: iconFade,
            child: SvgPicture.asset(svgPath, width: 120.w, height: 120.w),
          ),
          SizedBox(height: 56.h),
          _animated(
            slide: titleSlide,
            fade: titleFade,
            child: isLogo
                ? SvgPicture.asset(
                    'assets/logo/applogo.svg',
                    height: 32.h,
                    colorFilter: const ColorFilter.mode(
                      Colors.white,
                      BlendMode.srcIn,
                    ),
                  )
                : Text(
                    title,
                    style: TextStyle(
                      fontSize: 26.sp,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      letterSpacing: -0.5,
                    ),
                    textAlign: TextAlign.center,
                  ),
          ),
          SizedBox(height: 16.h),
          _animated(
            slide: descSlide,
            fade: descFade,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.w),
              child: Text(
                description,
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
          ),
        ],
      ),
    );
  }

  Widget _animated({
    required Animation<Offset>? slide,
    required Animation<double>? fade,
    required Widget child,
  }) {
    if (slide == null && fade == null) return child;

    Widget result = child;
    if (fade != null) {
      result = FadeTransition(opacity: fade, child: result);
    }
    if (slide != null) {
      result = SlideTransition(position: slide, child: result);
    }
    return result;
  }
}

class _PageSwipeWrapper extends StatelessWidget {
  final int index;
  final PageController controller;
  final Widget child;

  const _PageSwipeWrapper({
    required this.index,
    required this.controller,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        final page = controller.page ?? index.toDouble();
        final diff = (page - index).abs().clamp(0.0, 1.0);

        final scale = 1.0 - diff * 0.06;
        final opacity = 1.0 - diff * 0.25;

        return Opacity(
          opacity: opacity,
          child: Transform.scale(scale: scale, child: child),
        );
      },
    );
  }
}
