import 'package:flutter/material.dart';
import 'package:crop_crue/screens/result_page.dart';

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

  // Color palette matched to CropCure dark forest green & wheat golden buttons
  static const Color canvasDarkGreen = Color(0xFF061B0D);
  static const Color cardDarkGreen = Color(0xFF14311E);
  static const Color cardBorderGreen = Color(0xFF284F36);
  static const Color wheatGold = Color(0xFFE5B84B);
  static const Color wheatGoldText = Color(0xFF142419);
  static const Color accentMint = Color(0xFF7AE582);
  static const Color bottomNavLight = Color(0xFFF3F6F4);
  static const Color bottomNavActivePill = Color(0xFFDDECE2);

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
      backgroundColor: canvasDarkGreen,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: canvasDarkGreen,
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
                            color: cardDarkGreen,
                            borderRadius: BorderRadius.circular(16),
                            border: Border.all(
                              color: cardBorderGreen,
                              width: 1.4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
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
                                  color: Color(0xFFB8CEBE),
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
                            color: cardDarkGreen,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: cardBorderGreen,
                              width: 1.4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.35),
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
                                        color: accentMint,
                                      ),
                                      child: const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(10),
                                          child: Text(
                                            'Place one leaf inside the frame',
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 11,
                                              color: Color(0xFFD5E6DA),
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
                                        color: accentMint,
                                        boxShadow: [
                                          BoxShadow(
                                            color: accentMint
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

                        // Take Photo Button (Wheat Golden)
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
                              backgroundColor: wheatGold,
                              foregroundColor: wheatGoldText,
                              elevation: 2,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(13),
                              ),
                            ),
                          ),
                        ),

                        const SizedBox(height: 14),

                        // Gallery Button (Wheat Golden)
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton.icon(
                            onPressed: () => _openResultPage(source: 'gallery'),
                            icon: const Icon(
                              Icons.photo_library_outlined,
                              size: 20,
                            ),
                            label: const Text(
                              'Choose from gallery',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: wheatGold,
                              foregroundColor: wheatGoldText,
                              elevation: 2,
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
                            color: cardDarkGreen,
                            borderRadius: BorderRadius.circular(15),
                            border: Border.all(
                              color: cardBorderGreen,
                              width: 1.4,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.28),
                                blurRadius: 8,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: const Color(0xFF1F472D),
                                  borderRadius: BorderRadius.circular(10),
                                ),
                                child: const Icon(
                                  Icons.lightbulb_outline,
                                  color: accentMint,
                                  size: 20,
                                ),
                              ),
                              const SizedBox(width: 11),
                              const Expanded(
                                child: Text(
                                  'Tip: Use daylight and a plain background. '
                                  'Blurry or dark photos can lower accuracy.',
                                  style: TextStyle(
                                    fontSize: 12,
                                    height: 1.5,
                                    color: Color(0xFFD5E6DA),
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
          color: bottomNavLight,
          border: Border(
            top: BorderSide(
              color: Colors.black.withValues(alpha: 0.08),
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
            selectedItemColor: canvasDarkGreen,
            unselectedItemColor: const Color(0xFF4A5D50),
            selectedFontSize: 11,
            unselectedFontSize: 10,
            elevation: 0,
            items: [
              BottomNavigationBarItem(
                icon: _buildNavIcon(
                  icon: Icons.document_scanner_outlined,
                  isSelected: _selectedIndex == 0,
                ),
                activeIcon: _buildNavIcon(
                  icon: Icons.document_scanner,
                  isSelected: true,
                ),
                label: 'Scan',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(
                  icon: Icons.book_outlined,
                  isSelected: _selectedIndex == 1,
                ),
                label: 'Library',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(
                  icon: Icons.access_time_outlined,
                  isSelected: _selectedIndex == 2,
                ),
                label: 'History',
              ),
              BottomNavigationBarItem(
                icon: _buildNavIcon(
                  icon: Icons.person_outline,
                  isSelected: _selectedIndex == 3,
                ),
                label: 'Profile',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavIcon({
    required IconData icon,
    required bool isSelected,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
      decoration: BoxDecoration(
        color: isSelected ? bottomNavActivePill : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: isSelected ? canvasDarkGreen : const Color(0xFF4A5D50),
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
      backgroundColor: const Color(0xFF061B0D),
      appBar: AppBar(
        title: Text(title),
        backgroundColor: const Color(0xFF14311E),
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Text(
          '$title page will be designed later.',
          textAlign: TextAlign.center,
          style: const TextStyle(
            fontSize: 17,
            color: Color(0xFF7AE582),
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}