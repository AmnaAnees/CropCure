import 'package:flutter/material.dart';

class CurePreventionPage extends StatefulWidget {
  const CurePreventionPage({super.key});

  @override
  State<CurePreventionPage> createState() => _CurePreventionPageState();
}

class _CurePreventionPageState extends State<CurePreventionPage> {
  int selectedTab = 1;
  bool isSaved = false;

  final List<String> tabs = ['Symptoms', 'Treatment', 'Prevention'];

  final Map<String, List<String>> content = {
    'Symptoms': [
      'Small yellow-orange pustules appear on wheat leaves.',
      'Yellow powder-like spots can be seen on infected leaves.',
      'Severe infection may reduce plant growth.',
      'The disease can spread to nearby plants.',
    ],

    'Treatment': [
      'Remove and destroy badly infected plants where possible.',
      'Apply a fungicide recommended for rust by your local agriculture office.',
      'Follow the label for amount and timing. Repeat only if advised.',
      'Check nearby plants again after a few days.',
    ],

    'Prevention': [
      'Grow rust-resistant wheat varieties.',
      'Use healthy and certified seeds.',
      'Regularly inspect wheat crops for early symptoms.',
      'Follow local agricultural recommendations.',
    ],
  };

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF9BBE91),

      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Container(
                width: double.infinity,

                // SAME BACKGROUND COLOR EVERYWHERE
                color: const Color(0xFF9BBE91),

                child: SingleChildScrollView(
                  padding: const EdgeInsets.fromLTRB(40, 35, 40, 30),

                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,

                    children: [
                      const Text(
                        '4 Cure and prevention',
                        style: TextStyle(color: Colors.white70, fontSize: 14),
                      ),

                      const SizedBox(height: 42),

                      // Back Button
                      GestureDetector(
                        onTap: () {
                          Navigator.pop(context);
                        },

                        child: Container(
                          height: 70,
                          width: 70,

                          decoration: const BoxDecoration(
                            color: Colors.black,
                            shape: BoxShape.circle,
                          ),

                          child: const Icon(
                            Icons.arrow_back_ios_new,
                            color: Colors.white,
                            size: 25,
                          ),
                        ),
                      ),

                      const SizedBox(height: 28),

                      // Yellow Rust Heading
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
                          'Yellow Rust',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),

                      const SizedBox(height: 26),

                      // Three Clickable Tabs
                      Container(
                        height: 78,
                        padding: const EdgeInsets.all(6),

                        decoration: BoxDecoration(
                          color: const Color(0xFF252B20),
                          borderRadius: BorderRadius.circular(20),
                        ),

                        child: Row(
                          children: List.generate(tabs.length, (index) {
                            bool isSelected = selectedTab == index;

                            return Expanded(
                              child: GestureDetector(
                                onTap: () {
                                  setState(() {
                                    selectedTab = index;
                                  });
                                },

                                child: AnimatedContainer(
                                  duration: const Duration(milliseconds: 200),

                                  alignment: Alignment.center,

                                  decoration: BoxDecoration(
                                    color: isSelected
                                        ? const Color(0xFF07351D)
                                        : Colors.transparent,

                                    borderRadius: BorderRadius.circular(16),
                                  ),

                                  child: Text(
                                    tabs[index],

                                    style: TextStyle(
                                      color: isSelected
                                          ? Colors.white
                                          : Colors.white60,

                                      fontSize: 16,

                                      fontWeight: isSelected
                                          ? FontWeight.bold
                                          : FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                        ),
                      ),

                      const SizedBox(height: 26),

                      // Information Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),

                        decoration: BoxDecoration(
                          color: Colors.black,

                          borderRadius: BorderRadius.circular(25),

                          border: Border.all(color: Colors.white24),
                        ),

                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              selectedTab == 0
                                  ? 'Common Symptoms'
                                  : selectedTab == 1
                                  ? 'Recommended management'
                                  : 'Prevention Methods',

                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                              ),
                            ),

                            const SizedBox(height: 25),

                            ...List.generate(content[tabs[selectedTab]]!.length, (
                              index,
                            ) {
                              return Padding(
                                padding: const EdgeInsets.only(bottom: 23),

                                child: Text(
                                  '${index + 1}. ${content[tabs[selectedTab]]![index]}',

                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17,
                                    height: 1.5,
                                  ),
                                ),
                              );
                            }),
                          ],
                        ),
                      ),

                      const SizedBox(height: 26),

                      // Guidance Card
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(25),

                        decoration: BoxDecoration(
                          color: const Color(0xFF302B18),

                          borderRadius: BorderRadius.circular(25),
                        ),

                        child: const Text.rich(
                          TextSpan(
                            children: [
                              TextSpan(
                                text: 'Guidance only. ',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),

                              TextSpan(
                                text: 'For large or unclear outbreaks, ask a certified agronomist to inspect the field.',
                              ),
                            ],
                          ),

                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                      ),

                      const SizedBox(height: 450),

                      // Save To History Button
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            isSaved = true;
                          });

                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Saved to history successfully!'),
                            ),
                          );
                        },

                        child: Container(
                          width: double.infinity,
                          height: 85,

                          decoration: BoxDecoration(
                            color: Colors.black,

                            borderRadius: BorderRadius.circular(25),

                            border: Border.all(
                              color: const Color(0xFF28633C),
                              width: 2,
                            ),
                          ),

                          alignment: Alignment.center,

                          child: Text(
                            isSaved ? 'Saved to history' : 'Save to history',

                            style: const TextStyle(
                              color: Color(0xFF8BC99A),
                              fontSize: 23,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ),

            // Bottom Navigation Bar
            Container(
              height: 85,
              color: const Color(0xFF22221F),

              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,

                children: const [
                  Icon(Icons.home_outlined, color: Colors.white, size: 36),

                  Icon(Icons.add_circle_outline, color: Colors.white, size: 36),

                  Icon(Icons.looks_one_outlined, color: Colors.white, size: 36),

                  Icon(Icons.menu, color: Colors.white, size: 36),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
