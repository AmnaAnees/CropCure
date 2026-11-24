
import 'dart:async';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  late final PageController _pageController;
  late final ScrollController _scrollController;

  Timer? _sliderTimer;

  int _currentPage = 0;
  int _selectedIndex = 0;

  // THEME COLORS
  static const Color background = Color(0xFF071F12);
  static const Color darkGreen = Color(0xFF092516);
  static const Color primaryGreen = Color(0xFF173322);
  static const Color accentGreen = Color(0xFF28563A);
  static const Color lightGreen = Color(0xFFE1EDE0);
  static const Color limeGreen = Color(0xFF8BC53F);
  static const Color lightLime = Color(0xFFA5D65D);
  static const Color warmWhite = Color(0xFFF5F8F2);
  static const Color grey = Color(0xFFAAB8AC);
  static const Color borderGreen = Color(0xFF496454);

  // HERO SLIDES
  final List<Map<String, String>> heroSlides = [
    {
      'image': 'assets/images/hero_bg1.jpg',
      'tag': 'SMART AGRICULTURE  •  AI TECHNOLOGY',
      'title': 'Protect Your Wheat,',
      'highlight': 'Secure Your Future.',
      'subtitle':
          'Identify wheat leaf diseases early and discover reliable treatment guidance.',
    },
    {
      'image': 'assets/images/hero_bg2.jpg',
      'tag': 'AI POWERED DETECTION',
      'title': 'Healthy Crops,',
      'highlight': 'Better Harvests.',
      'subtitle':
          'Use intelligent technology to understand your wheat crop health.',
    },
    {
      'image': 'assets/images/hero_bg3.jpg',
      'tag': 'GROW WITH CONFIDENCE',
      'title': 'Your Farming,',
      'highlight': 'Made Smarter.',
      'subtitle':
          'Get useful information, disease insights and practical crop care tips.',
    },
  ];

  @override
  void initState() {
    super.initState();

    _pageController = PageController();
    _scrollController = ScrollController();

    _sliderTimer = Timer.periodic(
      const Duration(seconds: 4),
      (timer) {
        if (!mounted || !_pageController.hasClients) return;

        _currentPage = (_currentPage + 1) % heroSlides.length;

        _pageController.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 800),
          curve: Curves.easeInOut,
        );
      },
    );
  }

  @override
  void dispose() {
    _sliderTimer?.cancel();
    _pageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: background,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final isMobile = constraints.maxWidth < 650;

            return Scrollbar(
              controller: _scrollController,
              thumbVisibility: true,
              trackVisibility: true,
              interactive: true,
              thickness: 6,
              radius: const Radius.circular(10),
              scrollbarOrientation: ScrollbarOrientation.right,
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: const AlwaysScrollableScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 1200,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 18 : 35,
                            vertical: 18,
                          ),
                          child: buildHeader(),
                        ),
                      ),
                    ),

                    // FULL WIDTH HERO
                    buildHeroSlider(isMobile),

                    // MAIN CONTENT
                    Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(
                          maxWidth: 1200,
                        ),
                        child: Padding(
                          padding: EdgeInsets.symmetric(
                            horizontal: isMobile ? 18 : 35,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const SizedBox(height: 65),
                              buildHowCropCureHelps(isMobile),
                              const SizedBox(height: 65),
                              buildDiseaseSection(isMobile),
                              const SizedBox(height: 65),
                              buildFarmersGuide(isMobile),
                              const SizedBox(height: 65),
                              buildRecentActivity(),
                              const SizedBox(height: 40),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      bottomNavigationBar: buildBottomNavigation(),
    );
  }

  // HEADER
  Widget buildHeader() {
    return Row(
      children: [
        Container(
          height: 45,
          width: 45,
          decoration: BoxDecoration(
            color: limeGreen.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(13),
          ),
          child: const Icon(
            Icons.eco_rounded,
            color: limeGreen,
            size: 28,
          ),
        ),
        const SizedBox(width: 12),
        const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'CropCure',
              style: TextStyle(
                color: warmWhite,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              'SMART CROP CARE',
              style: TextStyle(
                color: grey,
                fontSize: 9,
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const Spacer(),
        Container(
          height: 42,
          width: 42,
          decoration: BoxDecoration(
            color: primaryGreen,
            borderRadius: BorderRadius.circular(13),
            border: Border.all(
              color: borderGreen.withValues(alpha: 0.5),
            ),
          ),
          child: const Icon(
            Icons.person_outline_rounded,
            color: warmWhite,
          ),
        ),
      ],
    );
  }

  // HERO SLIDER
  Widget buildHeroSlider(bool isMobile) {
    return SizedBox(
      height: isMobile ? 520 : 590,
      width: double.infinity,
      child: Stack(
        fit: StackFit.expand,
        children: [
          PageView.builder(
            controller: _pageController,
            itemCount: heroSlides.length,
            onPageChanged: (index) {
              setState(() {
                _currentPage = index;
              });
            },
            itemBuilder: (context, index) {
              final slide = heroSlides[index];

              return Stack(
                fit: StackFit.expand,
                children: [
                  Image.asset(
                    slide['image']!,
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                      return Container(
                        decoration: const BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Color(0xFF183D27),
                              Color(0xFF071F12),
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                        ),
                      );
                    },
                  ),

                  // DARK OVERLAY
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.centerRight,
                        colors: [
                          background.withValues(alpha: 0.88),
                          background.withValues(alpha: 0.65),
                          background.withValues(alpha: 0.15),
                        ],
                        stops: const [0.0, 0.55, 1.0],
                      ),
                    ),
                  ),

                  // BOTTOM GRADIENT
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          background.withValues(alpha: 0.55),
                          Colors.transparent,
                        ],
                      ),
                    ),
                  ),
                ],
              );
            },
          ),

          // HERO TEXT
          Positioned.fill(
            child: Padding(
              padding: EdgeInsets.symmetric(
                horizontal: isMobile ? 25 : 75,
                vertical: isMobile ? 45 : 65,
              ),
              child: Align(
                alignment: Alignment.centerLeft,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(
                    maxWidth: 700,
                  ),
                  child: AnimatedSwitcher(
                    duration: const Duration(milliseconds: 450),
                    child: Column(
                      key: ValueKey(_currentPage),
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          heroSlides[_currentPage]['tag']!,
                          style: const TextStyle(
                            color: lightLime,
                            fontSize: 11,
                            letterSpacing: 2,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 27),
                        Text(
                          heroSlides[_currentPage]['title']!,
                          style: TextStyle(
                            color: warmWhite,
                            fontSize: isMobile ? 34 : 58,
                            height: 1.12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          heroSlides[_currentPage]['highlight']!,
                          style: TextStyle(
                            color: lightLime,
                            fontSize: isMobile ? 34 : 58,
                            height: 1.12,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(height: 22),
                        ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 620,
                          ),
                          child: Text(
                            heroSlides[_currentPage]['subtitle']!,
                            style: TextStyle(
                              color: warmWhite.withValues(alpha: 0.9),
                              fontSize: isMobile ? 13 : 16,
                              height: 1.8,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),

          // SLIDER INDICATORS
          Positioned(
            bottom: 25,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                heroSlides.length,
                (index) {
                  final selected = _currentPage == index;

                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 7,
                    width: selected ? 30 : 7,
                    decoration: BoxDecoration(
                      color: selected
                          ? limeGreen
                          : warmWhite.withValues(alpha: 0.55),
                      borderRadius: BorderRadius.circular(20),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  // SECTION HEADING
  Widget buildSectionHeading(
    String tag,
    String title,
    String subtitle,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          tag.toUpperCase(),
          style: const TextStyle(
            color: lightLime,
            fontSize: 11,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        const SizedBox(height: 0),
        Text(
          title,
          style: const TextStyle(
            color: warmWhite,
            fontSize: 28,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 10),
        Text(
          subtitle,
          style: const TextStyle(
            color: grey,
            fontSize: 14,
            height: 1.6,
          ),
        ),
      ],
    );
  }

  // HOW CROPCURE HELPS - RESPONSIVE TIMELINE
  Widget buildHowCropCureHelps(bool isMobile) {
    final steps = [
      {
        'number': '01',
        'icon': Icons.photo_camera_rounded,
        'title': 'Upload Leaf Image',
        'description':
            'Capture a clear picture of your wheat leaf or select one from your gallery.',
      },
      {
        'number': '02',
        'icon': Icons.psychology_rounded,
        'title': 'AI Disease Detection',
        'description':
            'Our intelligent system analyzes the image to identify possible wheat leaf diseases.',
      },
      {
        'number': '03',
        'icon': Icons.biotech_rounded,
        'title': 'Understand the Disease',
        'description':
            'Explore disease symptoms, causes and useful information about your crop.',
      },
      {
        'number': '04',
        'icon': Icons.spa_rounded,
        'title': 'Get Treatment Guidance',
        'description':
            'Discover practical management suggestions to support healthier wheat crops.',
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeading(
          'SIMPLE PROCESS',
          'How CropCure Helps',
          'A simple way to understand your wheat crop health.',
        ),
        const SizedBox(height: 40),

        LayoutBuilder(
          builder: (context, constraints) {
            final width = constraints.maxWidth;

            // RESPONSIVE CARD WIDTH
            final double cardWidth;

            if (width < 350) {
              cardWidth = width * 0.84;
            } else if (width < 450) {
              cardWidth = width * 0.78;
            } else if (width < 650) {
              cardWidth = width * 0.72;
            } else if (width < 900) {
              cardWidth = width * 0.43;
            } else {
              cardWidth = width * 0.38;
            }

            // RESPONSIVE CARD HEIGHT AND SPACING
            final double cardHeight;
            final double stride;

            if (width < 350) {
              cardHeight = 200;
              stride = 235;
            } else if (width < 650) {
              cardHeight = 190;
              stride = 225;
            } else if (width < 900) {
              cardHeight = 180;
              stride = 210;
            } else {
              cardHeight = 165;
              stride = 195;
            }

            final sectionHeight =
                (stride * (steps.length - 1)) + cardHeight;

            return SizedBox(
              width: width,
              height: sectionHeight,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  // CONNECTING LINE
                  Positioned.fill(
                    child: CustomPaint(
                      painter: HelpTimelinePainter(
                        cardWidth: cardWidth,
                        cardHeight: cardHeight,
                        stride: stride,
                        lineColor: limeGreen,
                      ),
                    ),
                  ),

                  // ALTERNATING RESPONSIVE CARDS
                  for (int index = 0; index < steps.length; index++)
                    Positioned(
                      top: index * stride,
                      left: index.isEven ? 0 : width - cardWidth,
                      width: cardWidth,
                      height: cardHeight,
                      child: buildHelpStepCard(
                        steps[index],
                        width,
                      ),
                    ),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  // HELP STEP CARD
  Widget buildHelpStepCard(
    Map<String, dynamic> step,
    double availableWidth,
  ) {
    final bool smallMobile = availableWidth < 350;
    final bool mobile = availableWidth < 650;

    final double cardPadding = smallMobile ? 13 : mobile ? 15 : 19;
    final double iconSize = smallMobile ? 38 : 43;
    final double titleSize = smallMobile ? 14 : mobile ? 15 : 17;
    final double descriptionSize = smallMobile ? 10 : mobile ? 11 : 12;

    return Container(
      padding: EdgeInsets.all(cardPadding),
      decoration: BoxDecoration(
        color: primaryGreen.withValues(alpha: 0.92),
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: limeGreen.withValues(alpha: 0.5),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.16),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                height: iconSize,
                width: iconSize,
                decoration: BoxDecoration(
                  color: limeGreen.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(
                  step['icon'] as IconData,
                  color: lightLime,
                  size: smallMobile ? 21 : 23,
                ),
              ),
              const Spacer(),
              Text(
                step['number'] as String,
                style: TextStyle(
                  color: lightLime,
                  fontSize: smallMobile ? 21 : 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          SizedBox(height: smallMobile ? 10 : 12),
          Text(
            step['title'] as String,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(
              color: warmWhite,
              fontSize: titleSize,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 7),
          Expanded(
            child: Text(
              step['description'] as String,
              maxLines: mobile ? 4 : 3,
              overflow: TextOverflow.ellipsis,
              style: TextStyle(
                color: grey,
                fontSize: descriptionSize,
                height: 1.45,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // DISEASE SECTION
  Widget buildDiseaseSection(bool isMobile) {
    final diseases = [
      {
        'name': 'Yellow Rust',
        'scientific': 'Puccinia striiformis',
        'description':
            'Yellow-orange stripes or pustules appear on wheat leaves.',
        'icon': Icons.warning_amber_rounded,
      },
      {
        'name': 'Brown Rust',
        'scientific': 'Puccinia triticina',
        'description':
            'Small brown circular pustules develop on leaf surfaces.',
        'icon': Icons.coronavirus_outlined,
      },
      {
        'name': 'Powdery Mildew',
        'scientific': 'Blumeria graminis',
        'description':
            'White powder-like patches develop on leaves and stems.',
        'icon': Icons.grain_rounded,
      },
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeading(
          'WHEAT LEAF DISEASES',
          'Know Your Crop',
          'Learn about common wheat leaf diseases and their symptoms.',
        ),
        const SizedBox(height: 30),
        LayoutBuilder(
          builder: (context, constraints) {
            final width = isMobile
                ? constraints.maxWidth
                : (constraints.maxWidth - 30) / 3;

            return Wrap(
              spacing: 15,
              runSpacing: 15,
              children: diseases.map((disease) {
                return SizedBox(
                  width: width,
                  child: buildDiseaseCard(disease),
                );
              }).toList(),
            );
          },
        ),
      ],
    );
  }

  Widget buildDiseaseCard(Map<String, dynamic> disease) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: primaryGreen,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(
          color: borderGreen.withValues(alpha: 0.55),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            height: 48,
            width: 48,
            decoration: BoxDecoration(
              color: limeGreen.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              disease['icon'] as IconData,
              color: lightLime,
              size: 25,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            disease['name'] as String,
            style: const TextStyle(
              color: warmWhite,
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 5),
          Text(
            disease['scientific'] as String,
            style: const TextStyle(
              color: lightLime,
              fontSize: 11,
              fontStyle: FontStyle.italic,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            disease['description'] as String,
            style: const TextStyle(
              color: grey,
              fontSize: 13,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  // FARMER GUIDE
  Widget buildFarmersGuide(bool isMobile) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isMobile ? 22 : 35),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Color(0xFF1C432C),
            Color(0xFF102B1B),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(25),
        border: Border.all(
          color: limeGreen.withValues(alpha: 0.35),
        ),
      ),
      child: isMobile
          ? Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                buildGuideContent(),
                const SizedBox(height: 25),
                buildGuideIcon(),
              ],
            )
          : Row(
              children: [
                Expanded(child: buildGuideContent()),
                const SizedBox(width: 25),
                buildGuideIcon(),
              ],
            ),
    );
  }

  Widget buildGuideContent() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'FARMER\'S GUIDE',
          style: TextStyle(
            color: lightLime,
            fontSize: 11,
            letterSpacing: 2,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 13),
        const Text(
          'A Little Care Goes a Long Way',
          style: TextStyle(
            color: warmWhite,
            fontSize: 25,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 12),
        const Text(
          'Regularly inspect your wheat plants, look for unusual leaf changes and take timely action to maintain crop health.',
          style: TextStyle(
            color: grey,
            fontSize: 14,
            height: 1.7,
          ),
        ),
        const SizedBox(height: 22),
        ElevatedButton(
          onPressed: () {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Farmer guide will be available soon.'),
              ),
            );
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: limeGreen,
            foregroundColor: darkGreen,
            padding: const EdgeInsets.symmetric(
              horizontal: 22,
              vertical: 14,
            ),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          child: const Text(
            'Explore Guide',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget buildGuideIcon() {
    return Container(
      height: 145,
      width: 145,
      decoration: BoxDecoration(
        color: limeGreen.withValues(alpha: 0.13),
        shape: BoxShape.circle,
        border: Border.all(
          color: limeGreen.withValues(alpha: 0.35),
          width: 2,
        ),
      ),
      child: const Icon(
        Icons.agriculture_rounded,
        color: lightLime,
        size: 75,
      ),
    );
  }

  // RECENT ACTIVITY
  Widget buildRecentActivity() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        buildSectionHeading(
          'YOUR RECORDS',
          'Recent Activity',
          'Keep track of your recent crop disease checks.',
        ),
        const SizedBox(height: 25),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(
            vertical: 35,
            horizontal: 20,
          ),
          decoration: BoxDecoration(
            color: primaryGreen,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: borderGreen.withValues(alpha: 0.5),
            ),
          ),
          child: Column(
            children: [
              Icon(
                Icons.history_rounded,
                size: 42,
                color: limeGreen.withValues(alpha: 0.8),
              ),
              const SizedBox(height: 15),
              const Text(
                'No Recent Activity',
                style: TextStyle(
                  color: warmWhite,
                  fontSize: 17,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your disease detection history will appear here.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: grey,
                  fontSize: 13,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  // BOTTOM NAVIGATION
  Widget buildBottomNavigation() {
    final items = [
      {'icon': Icons.home_rounded, 'label': 'Home'},
      {'icon': Icons.document_scanner_rounded, 'label': 'Detect'},
      {'icon': Icons.history_rounded, 'label': 'History'},
      {'icon': Icons.person_outline_rounded, 'label': 'Profile'},
    ];

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF0C2417),
        border: Border(
          top: BorderSide(
            color: borderGreen.withValues(alpha: 0.45),
          ),
        ),
      ),
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 9,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              items.length,
              (index) {
                final selected = _selectedIndex == index;

                return InkWell(
                  onTap: () {
                    setState(() {
                      _selectedIndex = index;
                    });
                  },
                  borderRadius: BorderRadius.circular(14),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 15,
                      vertical: 9,
                    ),
                    decoration: BoxDecoration(
                      color: selected
                          ? limeGreen.withValues(alpha: 0.14)
                          : Colors.transparent,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          items[index]['icon'] as IconData,
                          color: selected ? lightLime : grey,
                          size: 23,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          items[index]['label'] as String,
                          style: TextStyle(
                            color: selected ? lightLime : grey,
                            fontSize: 10,
                            fontWeight: selected
                                ? FontWeight.bold
                                : FontWeight.normal,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

// CURVED HELP TIMELINE CONNECTOR
class HelpTimelinePainter extends CustomPainter {
  final double cardWidth;
  final double cardHeight;
  final double stride;
  final Color lineColor;

  HelpTimelinePainter({
    required this.cardWidth,
    required this.cardHeight,
    required this.stride,
    required this.lineColor,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final linePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round
      ..shader = const LinearGradient(
        colors: [
          Color(0xFF35A7D0),
          Color(0xFF32BFA9),
          Color(0xFF8BC53F),
        ],
      ).createShader(Offset.zero & size);

    final dotPaint = Paint()
      ..color = lineColor
      ..style = PaintingStyle.fill;

    for (int index = 0; index < 3; index++) {
      // INNER EDGES OF ALTERNATING CARDS
      final currentCardIsLeft = index.isEven;

      final startX = currentCardIsLeft
          ? cardWidth
          : size.width - cardWidth;

      final endX = currentCardIsLeft
          ? size.width - cardWidth
          : cardWidth;

      final startY = (index * stride) + (cardHeight / 2);
      final endY = ((index + 1) * stride) + (cardHeight / 2);

      final middleX = size.width / 2;
      final verticalDistance = endY - startY;

      final path = Path()
        ..moveTo(startX, startY)
        ..cubicTo(
          middleX,
          startY + verticalDistance * 0.30,
          middleX,
          endY - verticalDistance * 0.30,
          endX,
          endY,
        );

      canvas.drawPath(path, linePaint);

      // CONNECTOR DOTS
      canvas.drawCircle(
        Offset(startX, startY),
        4,
        dotPaint,
      );

      canvas.drawCircle(
        Offset(endX, endY),
        4,
        dotPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant HelpTimelinePainter oldDelegate) {
    return oldDelegate.cardWidth != cardWidth ||
        oldDelegate.cardHeight != cardHeight ||
        oldDelegate.stride != stride ||
        oldDelegate.lineColor != lineColor;
  }
}
