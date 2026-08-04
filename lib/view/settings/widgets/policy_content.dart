import 'package:famka/config/theme/app_colors.dart';
import 'package:famka/provider/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_widget_from_html/flutter_widget_from_html.dart';
import 'package:url_launcher/url_launcher.dart';

class PolicyAppBar extends StatelessWidget implements PreferredSizeWidget {
  const PolicyAppBar({super.key, required this.title});

  final String title;

  @override
  Size get preferredSize => Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.bgColor,
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
        title,
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

class PolicyContent extends ConsumerStatefulWidget {
  const PolicyContent({super.key, required this.fetch});

  /// Loads the policy content from the API.
  final Future<String> Function(User notifier) fetch;

  @override
  ConsumerState<PolicyContent> createState() => _PolicyContentState();
}

class _PolicyContentState extends ConsumerState<PolicyContent> {
  late Future<String> _contentFuture;

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() {
    _contentFuture = widget.fetch(ref.read(userProvider.notifier));
  }

  void _retry() {
    setState(_load);
  }

  Future<void> _refresh() async {
    final future = widget.fetch(ref.read(userProvider.notifier));
    setState(() => _contentFuture = future);
    try {
      await future;
    } catch (_) {
      // Error state is rendered by the FutureBuilder.
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String>(
      future: _contentFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != ConnectionState.done) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasError) {
          return _ErrorView(onRetry: _retry);
        }
        return RefreshIndicator(
          onRefresh: _refresh,
          color: AppColors.primary,
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 20.h),
            child: _PolicyHtmlContent(snapshot.data ?? ''),
          ),
        );
      },
    );
  }
}

class _PolicyHtmlContent extends StatelessWidget {
  const _PolicyHtmlContent(this.content);

  final String content;

  @override
  Widget build(BuildContext context) {
    final headingHex = _colorToCssHex(Theme.of(context).colorScheme.onSurface);
    final linkHex = _colorToCssHex(Theme.of(context).colorScheme.primary);

    final h1Size = 22.sp;
    final h2Size = 20.sp;
    final h3Size = 18.sp;
    final h4Size = 17.sp;
    final h5Size = 16.sp;
    final h6Size = 15.sp;

    return HtmlWidget(
      content,
      textStyle: TextStyle(
        fontSize: 14.sp,
        fontWeight: FontWeight.w400,
        color: Theme.of(context).colorScheme.onSurface.withValues(alpha: 0.8),
        height: 1.6,
        fontFamily: 'Poppins',
      ),
      onTapUrl: (url) async {
        final uri = Uri.tryParse(url);
        if (uri != null && await canLaunchUrl(uri)) {
          await launchUrl(uri, mode: LaunchMode.externalApplication);
          return true;
        }
        return false;
      },
      customStylesBuilder: (element) {
        switch (element.localName) {
          case 'h1':
            return {
              'font-size': '${h1Size.toStringAsFixed(0)}px',
              'font-weight': 'bold',
              'color': headingHex,
              'margin': '24px 0 12px 0',
            };
          case 'h2':
            return {
              'font-size': '${h2Size.toStringAsFixed(0)}px',
              'font-weight': 'bold',
              'color': headingHex,
              'margin': '20px 0 10px 0',
            };
          case 'h3':
            return {
              'font-size': '${h3Size.toStringAsFixed(0)}px',
              'font-weight': '600',
              'color': headingHex,
              'margin': '16px 0 8px 0',
            };
          case 'h4':
            return {
              'font-size': '${h4Size.toStringAsFixed(0)}px',
              'font-weight': '600',
              'color': headingHex,
              'margin': '14px 0 6px 0',
            };
          case 'h5':
            return {
              'font-size': '${h5Size.toStringAsFixed(0)}px',
              'font-weight': '500',
              'color': headingHex,
              'margin': '12px 0 4px 0',
            };
          case 'h6':
            return {
              'font-size': '${h6Size.toStringAsFixed(0)}px',
              'font-weight': '500',
              'color': headingHex,
              'margin': '10px 0 4px 0',
            };
          case 'p':
            return {'margin': '0 0 12px 0', 'line-height': '1.6'};
          case 'ul':
          case 'ol':
            return {'margin': '0 0 12px 0', 'padding-left': '24px'};
          case 'li':
            return {'margin': '0 0 4px 0', 'line-height': '1.6'};
          case 'a':
            return {'color': linkHex, 'text-decoration': 'underline'};
          default:
            return null;
        }
      },
    );
  }

  static String _colorToCssHex(Color color) {
    final r = (color.r * 255).round().toRadixString(16).padLeft(2, '0');
    final g = (color.g * 255).round().toRadixString(16).padLeft(2, '0');
    final b = (color.b * 255).round().toRadixString(16).padLeft(2, '0');
    return '#$r$g$b';
  }
}

class _ErrorView extends StatelessWidget {
  const _ErrorView({required this.onRetry});

  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.cloud_off, size: 48, color: Colors.white38),
          SizedBox(height: 12.h),
          Text(
            "Couldn't load content",
            style: TextStyle(fontSize: 16.sp, color: Colors.white70),
          ),
          SizedBox(height: 16.h),
          ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
        ],
      ),
    );
  }
}
