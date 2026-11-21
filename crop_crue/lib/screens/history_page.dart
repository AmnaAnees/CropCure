import 'package:flutter/material.dart';

void main() {
  runApp(const CropScanApp());
}

class CropScanApp extends StatelessWidget {
  const CropScanApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Crop Scan',
      theme: ThemeData(useMaterial3: true, fontFamily: 'Roboto'),
      home: const ScanHistoryPage(),
    );
  }
}

class ScanHistoryPage extends StatefulWidget {
  const ScanHistoryPage({super.key});

  @override
  State<ScanHistoryPage> createState() => _ScanHistoryPageState();
}

class _ScanHistoryPageState extends State<ScanHistoryPage> {
  int selectedIndex = 2;

  final List<Map<String, dynamic>> history = [
    {
      'title': 'Yellow Rust',
      'date': 'Today',
      'accuracy': '92%',
      'color': const Color(0xFF83C956),
    },
    {
      'title': 'Healthy Wheat Leaf',
      'date': 'Yesterday',
      'accuracy': '97%',
      'color': const Color(0xFF8BCF61),
    },
    {
      'title': 'Powdery Mildew',
      'date': '3 days ago',
      'accuracy': '88%',
      'color': const Color(0xFF9BDD68),
    },
    {
      'title': 'Brown Rust',
      'date': 'Last week',
      'accuracy': '85%',
      'color': const Color(0xFF87C85B),
    },
  ];

  final List<String> navLabels = ['Scan', 'Library', 'History', 'Profile'];

  final List<IconData> navIcons = [
    Icons.document_scanner_outlined,
    Icons.book_outlined,
    Icons.access_time_rounded,
    Icons.person_outline_rounded,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFA6D1AD),

      body: SafeArea(
        child: selectedIndex == 2 ? _buildHistoryPage() : _buildOtherPage(),
      ),

      bottomNavigationBar: _buildBottomNavigation(),
    );
  }

  Widget _buildHistoryPage() {
    return LayoutBuilder(
      builder: (context, constraints) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 12),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Page title
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 22,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(22),
                ),
                child: const Text(
                  'Scan history',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 29,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 26),

              // History cards
              Expanded(
                child: ListView.separated(
                  padding: EdgeInsets.zero,
                  itemCount: history.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(height: 20),
                  itemBuilder: (context, index) {
                    final item = history[index];

                    return _buildHistoryCard(
                      title: item['title'],
                      date: item['date'],
                      accuracy: item['accuracy'],
                      color: item['color'],
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildHistoryCard({
    required String title,
    required String date,
    required String accuracy,
    required Color color,
  }) {
    return Container(
      height: 122,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: Colors.black,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: [
          // Green thumbnail
          Container(
            width: 76,
            height: 76,
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [color, const Color(0xFFB4ED8C)],
              ),
            ),
          ),

          const SizedBox(width: 18),

          // Scan details
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 7),

                Text(
                  '$date  ·  $accuracy',
                  style: const TextStyle(
                    color: Color(0xFFBDBDBD),
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomNavigation() {
    return Container(
      height: 82,
      decoration: const BoxDecoration(
        color: Colors.black,
        border: Border(top: BorderSide(color: Color(0xFF242424), width: 1)),
      ),
      child: Row(
        children: List.generate(navLabels.length, (index) {
          final isSelected = selectedIndex == index;

          return Expanded(
            child: InkWell(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      navIcons[index],
                      size: 29,
                      color: isSelected
                          ? const Color(0xFF58E88A)
                          : const Color(0xFFE0E0E0),
                    ),

                    const SizedBox(height: 5),

                    Text(
                      navLabels[index],
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: isSelected
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isSelected
                            ? const Color(0xFF58E88A)
                            : const Color(0xFFE0E0E0),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        }),
      ),
    );
  }

  Widget _buildOtherPage() {
    final title = navLabels[selectedIndex];

    return Center(
      child: Container(
        padding: const EdgeInsets.all(24),
        margin: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: Colors.black,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Text(
          '$title Page',
          style: const TextStyle(
            color: Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}
