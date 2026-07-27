import 'package:audio_waveforms/audio_waveforms.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:famka/config/app_colors.dart';
import 'package:go_router/go_router.dart';
import 'package:famka/config/router_path.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:path_provider/path_provider.dart';
import 'dart:io';

class SessionScreen extends StatefulWidget {
  const SessionScreen({super.key});

  @override
  State<SessionScreen> createState() => _SessionScreenState();
}

class _SessionScreenState extends State<SessionScreen>
    with SingleTickerProviderStateMixin {
  late final PlayerController _playerController;
  late final AnimationController _pulseCtrl;
  late final Animation<double> _pulseAnim;

  bool _isPlaying = false;
  bool _isLoaded = false;
  bool _audioCompleted = false;
  String? _loadError;
  Duration _position = Duration.zero;
  Duration _duration = Duration.zero;

  static const String _audioAssetPath =
      'assets/audio/Test your listening skill.mp3';

  @override
  void initState() {
    super.initState();
    _playerController = PlayerController();

    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );
    _pulseAnim = Tween<double>(
      begin: 1.0,
      end: 1.04,
    ).animate(CurvedAnimation(parent: _pulseCtrl, curve: Curves.easeInOut));

    _initPlayer();
  }

  Future<void> _initPlayer() async {
    try {
      // Copy the bundled audio asset to a temp file so the native player can access it.
      final dir = await getTemporaryDirectory();
      final tempFile = File('${dir.path}/session_audio.mp3');
      if (!await tempFile.exists()) {
        final data = await rootBundle.load(_audioAssetPath);
        await tempFile.writeAsBytes(data.buffer.asUint8List());
      }

      await _playerController.preparePlayer(
        path: tempFile.path,
        shouldExtractWaveform: true,
        noOfSamples: 100,
        volume: 1.0,
      );
    } catch (e) {
      if (mounted) {
        setState(
          () => _loadError =
              'Failed to load audio: ${e.toString().split('\n').first}',
        );
      }
      return;
    }

    _duration = Duration(milliseconds: _playerController.maxDuration);

    _playerController.onCurrentDurationChanged.listen((millis) {
      if (mounted) {
        setState(() {
          _position = Duration(milliseconds: millis);
          // Mark as completed when playback reaches the end
          if (!_audioCompleted &&
              _isPlaying &&
              _playerController.maxDuration > 0 &&
              millis >= _playerController.maxDuration - 200) {
            _audioCompleted = true;
            _pulseCtrl.repeat(reverse: true);
          }
        });
      }
    });

    _playerController.onPlayerStateChanged.listen((state) {
      if (mounted) {
        setState(() {
          _isPlaying = state == PlayerState.playing;
          if (state == PlayerState.playing) {
            // User started playing again — reset completion so they must
            // finish listening again before the quiz unlocks.
            _audioCompleted = false;
            _pulseCtrl.reset();
          }
          if (state == PlayerState.stopped) {
            _position = Duration.zero;
            _isPlaying = false;
          }
        });
      }
    });

    if (mounted) {
      setState(() {
        _isLoaded = true;
        _duration = Duration(milliseconds: _playerController.maxDuration);
      });
    }
  }

  Future<void> _togglePlayPause() async {
    if (_playerController.playerState == PlayerState.playing) {
      await _playerController.pausePlayer();
    } else {
      await _playerController.startPlayer();
    }
  }

  Future<void> _replay() async {
    setState(() {
      _audioCompleted = false;
      _pulseCtrl.reset();
    });
    await _playerController.seekTo(0);
    await _playerController.startPlayer();
  }

  String _formatDuration(Duration d) {
    final minutes = d.inMinutes.remainder(60).toString().padLeft(1, '0');
    final seconds = d.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }

  double get _progress {
    if (_duration.inMilliseconds == 0) return 0;
    return _position.inMilliseconds / _duration.inMilliseconds;
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    _playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.bgColor,
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(context),
            SizedBox(height: 16.h),
            _buildTitle(),
            const Spacer(),
            _buildWaveform(),
            const Spacer(),
            _buildProgressBar(),
            SizedBox(height: 8.h),
            _buildTimeRow(),
            SizedBox(height: 24.h),
            _buildControls(),
            SizedBox(height: 12.h),
            _buildForwardDisabledNote(),
            SizedBox(height: 20.h),
            _buildQuizButton(),
            SizedBox(height: 16.h),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Align(
            alignment: Alignment.centerLeft,
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: Container(
                width: 40.w,
                height: 40.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.08),
                  border: Border.all(color: Colors.white24, width: 1),
                ),
                child: Icon(
                  Icons.chevron_left_rounded,
                  color: Colors.white,
                  size: 22.sp,
                ),
              ),
            ),
          ),
          Text(
            'Session',
            style: TextStyle(
              color: Colors.white,
              fontSize: 18.sp,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTitle() {
    return Column(
      children: [
        Text(
          'Voice recognition',
          style: TextStyle(
            color: Colors.white,
            fontSize: 16.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 4.h),
        Text(
          'Chapter 1 · Lesson 2',
          style: TextStyle(
            color: Colors.white54,
            fontSize: 13.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildWaveform() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: _loadError != null
          ? SizedBox(
              height: 80.h,
              child: Center(
                child: Text(
                  _loadError!,
                  style: TextStyle(
                    color: Colors.redAccent,
                    fontSize: 12.sp,
                    fontFamily: 'Poppins',
                  ),
                  textAlign: TextAlign.center,
                ),
              ),
            )
          : _isLoaded
          ? AudioFileWaveforms(
              size: Size(double.infinity, 80.h),
              playerController: _playerController,
              enableSeekGesture: true,
              waveformType: WaveformType.fitWidth,
              playerWaveStyle: PlayerWaveStyle(
                fixedWaveColor: const Color(0xFF3D3F6B),
                liveWaveColor: AppColors.primary,
                seekLineColor: Colors.transparent,
                waveCap: StrokeCap.round,
                waveThickness: 3.0,
                spacing: 6.0,
                showSeekLine: false,
              ),
            )
          : SizedBox(
              height: 80.h,
              child: Center(
                child: CircularProgressIndicator(
                  color: AppColors.primary,
                  strokeWidth: 2,
                ),
              ),
            ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: SliderTheme(
        data: SliderThemeData(
          trackHeight: 2.h,
          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 0),
          overlayShape: const RoundSliderOverlayShape(overlayRadius: 0),
          activeTrackColor: Colors.white54,
          inactiveTrackColor: Colors.white12,
        ),
        child: Slider(
          value: _progress.clamp(0.0, 1.0),
          onChanged: (val) async {
            final seekMs = (val * _duration.inMilliseconds).toInt();
            await _playerController.seekTo(seekMs);
          },
        ),
      ),
    );
  }

  Widget _buildTimeRow() {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 24.w),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            _formatDuration(_position),
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12.sp,
              fontFamily: 'Poppins',
            ),
          ),
          Text(
            '-${_formatDuration(_duration - _position)}',
            style: TextStyle(
              color: Colors.white54,
              fontSize: 12.sp,
              fontFamily: 'Poppins',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControls() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // Replay button
        GestureDetector(
          onTap: _replay,
          child: SizedBox(
            width: 48.w,
            height: 48.w,
            child: Icon(
              Icons.replay_rounded,
              color: Colors.white70,
              size: 28.sp,
            ),
          ),
        ),
        SizedBox(width: 32.w),
        // Play/Pause button
        GestureDetector(
          onTap: _isLoaded ? _togglePlayPause : null,
          child: Container(
            width: 64.w,
            height: 64.w,
            decoration: const BoxDecoration(
              shape: BoxShape.circle,
              color: AppColors.primary,
            ),
            child: Icon(
              _isPlaying ? Icons.pause_rounded : Icons.play_arrow_rounded,
              color: Colors.white,
              size: 32.sp,
            ),
          ),
        ),
        SizedBox(width: 32.w),
        // Forward button (disabled)
        SizedBox(
          width: 48.w,
          height: 48.w,
          child: Icon(
            Icons.chevron_right_rounded,
            color: Colors.white24,
            size: 28.sp,
          ),
        ),
      ],
    );
  }

  Widget _buildForwardDisabledNote() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Icon(Icons.lock_outline_rounded, color: Colors.white38, size: 14.sp),
        SizedBox(width: 6.w),
        Text(
          'Forward skip disabled — stay focused',
          style: TextStyle(
            color: Colors.white38,
            fontSize: 12.sp,
            fontFamily: 'Poppins',
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  void _onQuizTap() {
    context.push(AppRoutes.quiz);
  }

  Widget _buildQuizButton() {
    final isActive = _audioCompleted;

    Widget button = Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: GestureDetector(
        onTap: isActive ? _onQuizTap : null,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeInOut,
          width: double.infinity,
          height: 56.h,
          decoration: BoxDecoration(
            color: isActive ? AppColors.primary : const Color(0xFF2A2D38),
            borderRadius: BorderRadius.circular(32.r),
            boxShadow: isActive
                ? [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ]
                : null,
          ),
          alignment: Alignment.center,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                isActive ? 'Take the Quiz' : 'Listen to the full audio first',
                style: TextStyle(
                  color: isActive ? Colors.white : Colors.white38,
                  fontSize: 16.sp,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );

    // Wrap in a gentle pulse when the button is active.
    if (isActive) {
      button = AnimatedBuilder(
        animation: _pulseAnim,
        builder: (context, child) =>
            Transform.scale(scale: _pulseAnim.value, child: child),
        child: button,
      );
    }

    return button;
  }
}
