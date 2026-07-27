import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import '../config/router_path.dart';

class MainNavBar extends StatelessWidget {
  const MainNavBar({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    const inactiveColor = Color(0xFF8B8E95);

    return Scaffold(
      extendBody: true,
      body: child,
      bottomNavigationBar: SafeArea(
        child: Container(
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          decoration: BoxDecoration(
            color: const Color(0xFF_2E3540),
            borderRadius: BorderRadius.circular(100),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 12.0,
            ),
            child: GNav(
              gap: 8,
              activeColor: Colors.white,
              color: inactiveColor,
              iconSize: 24,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
              duration: const Duration(milliseconds: 400),
              tabBackgroundColor: const Color(0xFF3B404D),
              tabs: [
                GButton(
                  icon: Icons.home,
                  leading: SvgPicture.asset(
                    "assets/icons/home.svg",
                    colorFilter: ColorFilter.mode(
                      selectedIndex == 0 ? Colors.white : inactiveColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  text: 'Home',
                ),
                GButton(
                  icon: Icons.bar_chart_rounded,
                  leading: SvgPicture.asset(
                    "assets/icons/Chart.svg",
                    colorFilter: ColorFilter.mode(
                      selectedIndex == 1 ? Colors.white : inactiveColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  text: 'Statistics',
                ),
                GButton(
                  icon: Icons.settings_rounded,
                  leading: SvgPicture.asset(
                    "assets/icons/Settings.svg",
                    colorFilter: ColorFilter.mode(
                      selectedIndex == 2 ? Colors.white : inactiveColor,
                      BlendMode.srcIn,
                    ),
                  ),
                  text: 'Settings',
                ),
              ],
              selectedIndex: selectedIndex,
              onTabChange: (index) => _onItemTapped(index, context),
            ),
          ),
        ),
      ),
    );
  }

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();
    if (location.startsWith(AppRoutes.home)) {
      return 0;
    }
    if (location.startsWith(AppRoutes.statistics)) {
      return 1;
    }
    if (location.startsWith(AppRoutes.settings)) {
      return 2;
    }
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(AppRoutes.home);
        break;
      case 1:
        context.go(AppRoutes.statistics);
        break;
      case 2:
        context.go(AppRoutes.settings);
        break;
    }
  }
}
