import 'package:flutter/material.dart';

// Model class: Baad mein backend/ML model ka real data yahan aayega
class ScanResultData {
  final String diseaseName;
  final double confidence; // 0.0 to 1.0 (e.g. 0.92 for 92%)
  final String pathogenType;
  final String mainSymptom;
  final String? leafImagePath; // Baad mein picked/captured image ka path aayega
  final String? leafAssetFallback;

  const ScanResultData({
    required this.diseaseName,
    required this.confidence,
    required this.pathogenType,
    required this.mainSymptom,
    this.leafImagePath,
    this.leafAssetFallback = 'assets/images/bg.jpg',
  });
}

// Result Screen with dark green background
class ScanResultPage extends StatefulWidget {
  final ScanResultData result;

  const ScanResultPage({
    super.key,
    required this.result,
  });

  static const Color pageBgDarkGreen = Color(0xFF0A1C12);
  static const Color cardDarkGreen = Color(0xFF142C1E);
  static const Color forestGreen = Color(0xFF0B6B3A);
  static const Color accentMint = Color(0xFF4CD99C);
  static const Color wheatGold = Color(0xFFE6BE6A);
  static const Color badgeBg = Color(0xFF2A2415);
  static const Color badgeText = Color(0xFFFFD56B);
  static const Color bottomNavLight = Color(0xFFF3F6F4);
  static const Color bottomNavActivePill = Color(0xFFDDECE2);

  @override
  State<ScanResultPage> createState() => _ScanResultPageState();
}

class _ScanResultPageState extends State<ScanResultPage> {
  int _selectedIndex = 0;

  void _onNavTap(int index) {
    setState(() {
      _selectedIndex = index;
    });

    if (index == 0) {
      Navigator.pop(context);
      return;
    }

    final labels = ['Scan', 'Library', 'History', 'Profile'];
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text('${labels[index]} page will be connected here.'),
          behavior: SnackBarBehavior.floating,
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
        color: isSelected
            ? ScanResultPage.bottomNavActivePill
            : Colors.transparent,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Icon(
        icon,
        color: isSelected
            ? ScanResultPage.pageBgDarkGreen
            : const Color(0xFF4A5D50),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final result = widget.result;
    final int confidencePercent = (result.confidence * 100).round();

    return Scaffold(
      backgroundColor: ScanResultPage.pageBgDarkGreen,
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: ScanResultPage.pageBgDarkGreen,
        child: SafeArea(
          bottom: false,
          child: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Leaf Image Preview Card ("Your leaf photo")
                    Container(
                      width: double.infinity,
                      height: 135,
                      decoration: BoxDecoration(
                        color: ScanResultPage.cardDarkGreen,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              ScanResultPage.accentMint.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(16),
                        child: Stack(
                          fit: StackFit.expand,
                          children: [
                            // Filhaal placeholder/asset image; baad mein File(result.leafImagePath!) use kar sakti hain
                            Image.asset(
                              result.leafAssetFallback ?? 'assets/images/bg.jpg',
                              fit: BoxFit.cover,
                            ),
                            Container(
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [
                                    Colors.transparent,
                                    Colors.black.withValues(alpha: 0.65),
                                  ],
                                ),
                              ),
                            ),
                            Positioned(
                              left: 10,
                              bottom: 10,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 9,
                                  vertical: 4,
                                ),
                                decoration: BoxDecoration(
                                  color: ScanResultPage.pageBgDarkGreen
                                      .withValues(alpha: 0.85),
                                  borderRadius: BorderRadius.circular(8),
                                  border: Border.all(
                                    color: ScanResultPage.accentMint
                                        .withValues(alpha: 0.3),
                                  ),
                                ),
                                child: const Text(
                                  'Your leaf photo',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 11,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Disease Detected Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: ScanResultPage.cardDarkGreen,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              ScanResultPage.accentMint.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 9,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: ScanResultPage.badgeBg,
                                    borderRadius: BorderRadius.circular(20),
                                    border: Border.all(
                                      color: ScanResultPage.badgeText
                                          .withValues(alpha: 0.35),
                                    ),
                                  ),
                                  child: const Text(
                                    'Disease detected',
                                    style: TextStyle(
                                      fontSize: 10.5,
                                      fontWeight: FontWeight.w600,
                                      color: ScanResultPage.badgeText,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  result.diseaseName,
                                  style: const TextStyle(
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          // Audio / Speaker icon button (Wheat golden)
                          InkWell(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                      'Audio feature will be added later.'),
                                  behavior: SnackBarBehavior.floating,
                                ),
                              );
                            },
                            borderRadius: BorderRadius.circular(24),
                            child: Container(
                              width: 40,
                              height: 40,
                              decoration: const BoxDecoration(
                                color: ScanResultPage.wheatGold,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.volume_up,
                                color: ScanResultPage.pageBgDarkGreen,
                                size: 20,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Confidence Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: ScanResultPage.cardDarkGreen,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              ScanResultPage.accentMint.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              const Text(
                                'Confidence',
                                style: TextStyle(
                                  fontSize: 12.5,
                                  color: Color(0xFFC4D8CC),
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              Text(
                                '$confidencePercent%',
                                style: const TextStyle(
                                  fontSize: 12.5,
                                  color: ScanResultPage.wheatGold,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: result.confidence.clamp(0.0, 1.0),
                              minHeight: 7,
                              backgroundColor: const Color(0xFF1F3E2B),
                              valueColor: const AlwaysStoppedAnimation<Color>(
                                ScanResultPage.wheatGold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 10),

                    // Pathogen Type & Main Symptom Card
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 14, vertical: 12),
                      decoration: BoxDecoration(
                        color: ScanResultPage.cardDarkGreen,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color:
                              ScanResultPage.accentMint.withValues(alpha: 0.25),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.35),
                            blurRadius: 10,
                            offset: const Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFFDDF0E5),
                                height: 1.4,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Pathogen type: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(text: result.pathogenType),
                              ],
                            ),
                          ),
                          const SizedBox(height: 6),
                          RichText(
                            text: TextSpan(
                              style: const TextStyle(
                                fontSize: 12.5,
                                color: Color(0xFFDDF0E5),
                                height: 1.4,
                              ),
                              children: [
                                const TextSpan(
                                  text: 'Main symptom: ',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                TextSpan(text: result.mainSymptom),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 12),

                    // Primary Button: View cure and prevention (Wheat golden)
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: ElevatedButton(
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Cure and prevention page will be added later.'),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: ScanResultPage.wheatGold,
                          foregroundColor: ScanResultPage.pageBgDarkGreen,
                          elevation: 3,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'View cure and prevention',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 8),

                    // Secondary Button: Scan another leaf (Wheat golden outline)
                    SizedBox(
                      width: double.infinity,
                      height: 44,
                      child: OutlinedButton(
                        onPressed: () => Navigator.pop(context),
                        style: OutlinedButton.styleFrom(
                          backgroundColor: ScanResultPage.cardDarkGreen,
                          foregroundColor: ScanResultPage.wheatGold,
                          side: const BorderSide(
                            color: ScanResultPage.wheatGold,
                            width: 1.2,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: const Text(
                          'Scan another leaf',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: ScanResultPage.bottomNavLight,
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
            onTap: _onNavTap,
            type: BottomNavigationBarType.fixed,
            backgroundColor: Colors.transparent,
            selectedItemColor: ScanResultPage.pageBgDarkGreen,
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
                  icon: Icons.history_outlined,
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
}