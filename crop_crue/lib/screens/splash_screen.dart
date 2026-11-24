import 'dart:async';
import 'package:flutter/material.dart';

import 'login_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  Timer? _timer;

  late final AnimationController _backgroundController;
  late final AnimationController _logoController;
  late final Animation<double> _logoAnimation;
  late final AnimationController _scanController;

  @override
  void initState() {
    super.initState();

    // 1. Background circles animate immediately upon opening
    _backgroundController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 4),
    )..repeat(reverse: true);

    // 2. Logo entrance animation controller (initially paused)
    _logoController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 900),
    );

    _logoAnimation = CurvedAnimation(
      parent: _logoController,
      curve: Curves.easeOut,
    );

    // 3. Scanning line animation controller (initially paused)
    _scanController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    // 4. After circles animate alone for 1.5 seconds, show the logo and start its scanning line
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (!mounted) return;
      _logoController.forward();
      _scanController.repeat(reverse: true);
    });

    // 5. Navigate to LoginPage after a total of 5 seconds
    _timer = Timer(const Duration(seconds: 5), () {
      if (!mounted) return;

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => const LoginPage(),
        ),
      );
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (MediaQuery.of(context).disableAnimations) {
      _backgroundController.stop();
      _scanController.stop();
    } else {
      if (!_backgroundController.isAnimating) {
        _backgroundController.repeat(reverse: true);
      }
      if (_logoController.isCompleted && !_scanController.isAnimating) {
        _scanController.repeat(reverse: true);
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _backgroundController.dispose();
    _logoController.dispose();
    _scanController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Determine screen parameters dynamically for deep responsiveness
    final screenSize = MediaQuery.of(context).size;
    final shortestSide = screenSize.shortestSide;

    // Responsive logo scaling capped safely for tablets/desktops
    final logoSize = (shortestSide * 0.45).clamp(140.0, 260.0);
    final borderRadius = logoSize * 0.17;

    return Scaffold(
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Dark Green Background Base
          Container(
            color: const Color(0xFF0D2818),
          ),

          // 2. Animated Pulsing Overlay Circles (animate first)
          AnimatedBuilder(
            animation: _backgroundController,
            builder: (context, child) {
              final value = Curves.easeInOut.transform(_backgroundController.value);
              return CustomPaint(
                painter: _PulsingCirclesPainter(animationValue: value),
              );
            },
          ),

          // 3. Very light gradient overlay so the background remains vibrant underneath
          DecoratedBox(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.white.withOpacity(0.0),
                  Colors.white.withOpacity(0.1),
                  Colors.white.withOpacity(0.2),
                ],
                stops: const [0.0, 0.5, 1.0],
              ),
            ),
          ),

          // 4. Centered Logo Animation (shows up after delay with scanning line)
          Center(
            child: FadeTransition(
              opacity: _logoAnimation,
              child: ScaleTransition(
                scale: Tween<double>(begin: 0.85, end: 1.0).animate(_logoAnimation),
                child: Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(borderRadius),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.15),
                        blurRadius: logoSize * 0.15,
                        offset: Offset(0, logoSize * 0.06),
                      ),
                    ],
                  ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(borderRadius),
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        // Base Logo Image
                        Image.asset(
                          'assets/images/logo.jpg',
                          fit: BoxFit.cover,
                        ),

                        // Responsive glowing scan line overlay (starts when logo appears)
                        AnimatedBuilder(
                          animation: _scanController,
                          builder: (context, child) {
                            final scanHeight = logoSize * 0.1;
                            final topPosition = _scanController.value * logoSize;
                            return Positioned(
                              top: topPosition - (scanHeight / 2),
                              left: 0,
                              right: 0,
                              child: IgnorePointer(
                                child: Container(
                                  height: scanHeight,
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.white.withOpacity(0.0),
                                        Colors.greenAccent.withOpacity(0.4),
                                        Colors.white.withOpacity(0.8),
                                        Colors.greenAccent.withOpacity(0.4),
                                        Colors.white.withOpacity(0.0),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Custom painter to draw responsive, pulsing ripple circles with clear visibility
class _PulsingCirclesPainter extends CustomPainter {
  final double animationValue;

  _PulsingCirclesPainter({required this.animationValue});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0;

    final center = Offset(size.width / 2, size.height / 2);
    final baseRadius = size.shortestSide * 0.35;

    // Centers corresponding to top, bottom, left, right watermark positions
    final offsets = [
      Offset(center.dx, 0.0), // Top circle
      Offset(center.dx, size.height), // Bottom circle
      Offset(0.0, center.dy), // Left circle
      Offset(size.width, center.dy), // Right circle
    ];

    for (int i = 0; i < offsets.length; i++) {
      final pos = offsets[i];
      for (int ring = 1; ring <= 2; ring++) {
        final radius = (baseRadius * 0.4 * ring) + (animationValue * 18.0 * ring);
        final opacity = (0.60 - (ring * 0.12)) * (0.85 + (animationValue * 0.15));

        // Wheat golden color
        paint.color = const Color(0xFFE5B84B).withOpacity(opacity.clamp(0.0, 1.0));
        canvas.drawCircle(pos, radius, paint);
      }
    }
  }

  @override
  bool shouldRepaint(covariant _PulsingCirclesPainter oldDelegate) {
    return oldDelegate.animationValue != animationValue;
  }
}