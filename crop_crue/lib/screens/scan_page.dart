import 'package:flutter/material.dart';
import 'result_page.dart';

class ScanPage extends StatefulWidget {
  const ScanPage({super.key});

  @override
  State<ScanPage> createState() => _ScanPageState();
}

class _ScanPageState extends State<ScanPage>
    with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;

  late AnimationController _animationController;
  late Animation<double> _animation;

  static const Color darkGreen = Color(0xFF006B3C);
  static const Color cardGreenTint = Color(0xFF132E1F);

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    )..repeat(reverse: true);

    _animation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Open ScanResultPage with ScanResultData
  void _openResultPage({required String source}) {
    // Temporary sample data until ML/backend integration is connected
    final ScanResultData sampleResult = source == 'camera'
        ? const ScanResultData(
            diseaseName: 'Leaf Rust',
            confidence: 0.92,
            pathogenType: 'Fungus (Puccinia triticina)',
            mainSymptom: 'Small, round-to-oval orange-brown pustules scattered on leaves.',
            leafAssetFallback: 'assets/images/bg.jpg',
          )
        : const ScanResultData(
            diseaseName: 'Stripe Rust',
            confidence: 0.88,
            pathogenType: 'Fungus (Puccinia striiformis)',
            mainSymptom: 'Yellow-orange uredinial pustules arranged in narrow stripes along veins.',
            leafAssetFallback: 'assets/images/bg.jpg',
          );

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ScanResultPage(result: sampleResult),
      ),
    );
  }

  // Bottom navigation
  void _openPage(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      return;
    }

    final pages = [
      const SizedBox(),
      const PlaceholderPage(title: 'Disease Library'),
      const PlaceholderPage(title: 'History'),
      const PlaceholderPage(title: 'Profile'),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => pages[index],
      ),
    ).then((_) {
      if (mounted) {
        setState(() {
          _selectedIndex = 0;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,

        // Background image (make sure assets/images/bg.jpg is in pubspec.yaml)
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage('assets/images/bg.jpg'),
            fit: BoxFit.cover,
          ),
        ),

        child: SafeArea(
          bottom: false,
          child: LayoutBuilder(
            builder: (context, constraints) {
              final screenWidth = constraints.maxWidth;

              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 500,
                  ),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth < 360 ? 14 : 20,
                      vertical: 18,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Heading Card
                        Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: const Color(0xFF142C1E)
                                .withValues(alpha: 0.85),
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: const Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Scan a wheat leaf',
                                style: TextStyle(
                                  fontSize: 21,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                              SizedBox(height: 5),
                              Text(
                                'Take a clear photo to check for disease.',
                                style: TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFFB0C4B8),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Scanning Preview
                        Container(
                          width: double.infinity,
                          height: 250,
                          decoration: BoxDecoration(
                            color: cardGreenTint.withValues(alpha: 0.88),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Colors.white.withValues(alpha: 0.15),
                              width: 1.5,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ],
                          ),
                          child: Center(
                            child: SizedBox(
                              width: 160,
                              height: 160,
                              child: Stack(
                                children: [
                                  // Dashed scanning frame
                                  Positioned.fill(
                                    child: CustomPaint(
                                      painter: DashedBorderPainter(
                                        color: const Color(0xFF4CD99C),
                                      ),
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Place one leaf inside the frame',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFFB0C4B8),
                                              fontWeight: FontWeight.w500,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),

                                  // Animated scanning line locked inside 160x160 box
                                  AnimatedBuilder(
                                    animation: _animation,
                                    builder: (context, child) {
                                      return Positioned(
                                        top: 8 + (_animation.value * 140),
                                        left: 8,
                                        right: 8,
                                        child: child!,
                                      );
                                    },
                                    child: Container(
                                      height: 2,
                                      decoration: BoxDecoration(
                                        color: const Color(0xFF4CD99C),
                                        boxShadow: [
                                          BoxShadow(
                                            color: const Color(0xFF4CD99C)
                                                .withValues(alpha: 0.8),
                                            blurRadius: 8,
                                            spreadRadius: 1,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 16),

                        // Take Photo Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () => _openResultPage(source: 'camera'),
                            icon: const Icon(
                              Icons.camera_alt_outlined,
                              size: 20,
                            ),
                            label: const Text(
                              'Take photo',
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 14,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: darkGreen,
                              foregroundColor: Colors.white,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Gallery Button
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: OutlinedButton.icon(
                            onPressed: () => _openResultPage(source: 'gallery'),
                            icon: const Icon(
                              Icons.photo_library_outlined,
                              size: 20,
                            ),
                            label: const Text(
                              'Choose from gallery',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            style: OutlinedButton.styleFrom(
                              backgroundColor: const Color(0xFF142C1E)
                                  .withValues(alpha: 0.9),
                              foregroundColor: Colors.white,
                              side: const BorderSide(
                                color: Color(0xFF4CD99C),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 18),

                        // Tip Card
                        Container(
                          width: double.infinity,
                          padding: const EdgeInsets.all(14),
                          decoration: BoxDecoration(
                            color: const Color(0xFF2A2415)
                                .withValues(alpha: 0.9),
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: const Color(0xFFEAD69B)
                                  .withValues(alpha: 0.5),
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.2),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: const Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                Icons.lightbulb_outline,
                                color: Color(0xFFFFD56B),
                                size: 20,
                              ),
                              SizedBox(width: 9),
                              Expanded(
                                child: Text(
                                  'Tip: Use daylight and a plain background. '
                                  'Blurry or dark photos can lower accuracy.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.5,
                                    color: Color(0xFFF3EAD3),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        const SizedBox(height: 25),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),

      // Bottom Navigation
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: const Color(0xFF142C1E),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.1),
            ),
          ),
        ),
        child: SafeArea(
          top: false,
          child: BottomNavigationBar(
            currentIndex: _selectedIndex,
            onTap: _openPage,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: const Color(0xFF4CD99C),
            unselectedItemColor: const Color(0xFF8FA899),
            selectedFontSize: 11,
            unselectedFontSize: 10,
            elevation: 0,
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.document_scanner_outlined),
                activeIcon: Icon(Icons.document_scanner),
                label: 'Scan',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.book_outlined),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.access_time_outlined),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person_outline),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dashed scanning border painter
class DashedBorderPainter extends CustomPainter {
  final Color color;

  DashedBorderPainter({
    required this.color,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    final rect = RRect.fromRectAndRadius(
      Rect.fromLTWH(
        1,
        1,
        size.width - 2,
        size.height - 2,
      ),
      const Radius.circular(14),
    );

    final path = Path()..addRRect(rect);

    for (final metric in path.computeMetrics()) {
      double distance = 0;

      while (distance < metric.length) {
        final length = (distance + 6).clamp(0.0, metric.length);

        canvas.drawPath(
          metric.extractPath(distance, length),
          paint,
        );

        distance += 11;
      }
    }
  }

  @override
  bool shouldRepaint(covariant DashedBorderPainter oldDelegate) {
    return oldDelegate.color != color;
  }
}

// Temporary pages
class PlaceholderPage extends StatelessWidget {
  final String title;

  const PlaceholderPage({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1C12),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF142C1E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          '$title page will be designed later.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
            color: Color(0xFF4CD99C),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}