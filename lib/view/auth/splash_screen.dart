import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';

import '../../config/routes/router_path.dart';
import '../../services/local_storage.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<Offset> _logoSlide;
  late final Animation<Offset> _textSlide;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );

    _logoSlide = Tween<Offset>(
      begin: const Offset(0, -1.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _textSlide = Tween<Offset>(
      begin: const Offset(0, 1.8),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeOutCubic));

    _controller.forward();

    Future.delayed(const Duration(milliseconds: 1800), () async {
      if (!mounted) return;

      // Already signed in? Skip onboarding and go straight home.
      final token = await LocalStorage.access_token.get();
      if (!mounted) return;

      final hasToken = token != null && token.isNotEmpty;
      context.go(hasToken ? AppRoutes.home : AppRoutes.onBoarding);
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SlideTransition(
              position: _logoSlide,
              child: SvgPicture.asset("assets/logo/applogo.svg"),
            ),
            SizedBox(height: 18.h),
            SlideTransition(
              position: _textSlide,
              child: SvgPicture.asset("assets/icons/spectra.svg"),
            ),
          ],
        ),
      ),
    );
  }
}
