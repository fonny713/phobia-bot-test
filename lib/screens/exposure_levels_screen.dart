import 'package:flutter/material.dart';
import 'exposure_screen.dart';
import 'breathing_exercise_screen_wrapper.dart';

class ExposureLevelsScreen extends StatefulWidget {
  const ExposureLevelsScreen({super.key});

  @override
  State<ExposureLevelsScreen> createState() => _ExposureLevelsScreenState();
}

class _ExposureLevelsScreenState extends State<ExposureLevelsScreen> {
  int _unlockedLevel = 1;

  final List<Map<String, dynamic>> _difficultyData = [
    {'label': 'Bardzo łatwy', 'icon': Icons.bug_report},
    {'label': 'Łatwy', 'icon': Icons.pest_control},
    {'label': 'Średni', 'icon': Icons.warning_amber},
    {'label': 'Trudny', 'icon': Icons.dangerous},
    {'label': 'Bardzo trudny', 'icon': Icons.king_bed},
  ];

  void _navigateToDifficulty(int index) {
    if (index + 1 <= _unlockedLevel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => BreathingExerciseScreenWrapper(
            onDone: () {
              Navigator.pushReplacement(
                context,
                MaterialPageRoute(
                  builder: (_) => ExposureScreen(
                    difficulty: index + 1,
                    initialLevel: 1,
                  ),
                ),
              ).then((result) {
                if (result == true && index + 2 <= 5) {
                  setState(() {
                    _unlockedLevel = index + 2;
                  });
                }
              });
            },
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Wybierz poziom trudności")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView.builder(
          itemCount: _difficultyData.length,
          itemBuilder: (context, index) {
            final isUnlocked = index + 1 <= _unlockedLevel;
            final data = _difficultyData[index];

            return GestureDetector(
              onTap: () => _navigateToDifficulty(index),
              child: Container(
                margin: const EdgeInsets.symmetric(vertical: 8),
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: isUnlocked ? Colors.blueAccent : Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Icon(
                      data['icon'],
                      size: 40,
                      color: isUnlocked ? Colors.white : Colors.grey,
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Text(
                        data['label'],
                        style: TextStyle(
                          color: isUnlocked ? Colors.white : Colors.black54,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                    if (!isUnlocked)
                      const Icon(Icons.lock, color: Colors.black45),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
