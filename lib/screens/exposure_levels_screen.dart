import 'dart:ui'; // Needed for BackdropFilter
import 'package:flutter/material.dart';
import 'breathing_exercise_screen_wrapper.dart';
import 'exposure_screen.dart';

class ExposureLevelsScreen extends StatefulWidget {
  const ExposureLevelsScreen({super.key});

  @override
  State<ExposureLevelsScreen> createState() => _ExposureLevelsScreenState();
}

class _ExposureLevelsScreenState extends State<ExposureLevelsScreen> {
  int _unlockedLevel = 1; // Default: only first level is unlocked

  final List<Map<String, dynamic>> _levels = [
    {'label': 'Very Easy', 'icon': Icons.bug_report},
    {'label': 'Easy', 'icon': Icons.pest_control},
    {'label': 'Medium', 'icon': Icons.warning_amber},
    {'label': 'Hard', 'icon': Icons.dangerous},
    {'label': 'Very Hard', 'icon': Icons.king_bed},
  ];

  void _navigateToDifficulty(int index) {
    if (index + 1 <= _unlockedLevel) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => BreathingExerciseScreenWrapper(
            isFromExposure: true,
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
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        title: const Text(
          "Difficulty Levels",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3CCF4), Color(0xFFCFDEF3)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(25.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Choose Your Challenge',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B8EF7),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Select a difficulty level to begin your exposure therapy',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                  ),
                ),
                const SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: _levels.length,
                    itemBuilder: (context, index) {
                      final isUnlocked = index + 1 <= _unlockedLevel;
                      final data = _levels[index];
                      final color = _getDifficultyColor(index);

                      return Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: isUnlocked ? () => _navigateToDifficulty(index) : null,
                            borderRadius: BorderRadius.circular(15),
                            child: Container(
                              padding: const EdgeInsets.all(16),
                              decoration: BoxDecoration(
                                color: isUnlocked
                                    ? color.withOpacity(0.1)
                                    : Colors.grey.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(15),
                                border: Border.all(
                                  color: isUnlocked
                                      ? color.withOpacity(0.2)
                                      : Colors.grey.withOpacity(0.2),
                                  width: 1,
                                ),
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isUnlocked
                                          ? color.withOpacity(0.1)
                                          : Colors.grey.withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Icon(
                                      data['icon'],
                                      color: isUnlocked ? color : Colors.grey,
                                      size: 24,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          data['label'],
                                          style: TextStyle(
                                            fontSize: 18,
                                            fontWeight: FontWeight.w500,
                                            color: isUnlocked ? color : Colors.grey,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          isUnlocked
                                              ? 'Ready to face your fears'
                                              : 'Complete previous level to unlock',
                                          style: TextStyle(
                                            fontSize: 14,
                                            color: Colors.grey[600],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  Icon(
                                    Icons.arrow_forward_ios,
                                    color: isUnlocked ? color.withOpacity(0.5) : Colors.grey.withOpacity(0.5),
                                    size: 16,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getDifficultyColor(int index) {
    switch (index) {
      case 0:
        return const Color(0xFF4CAF50); // Very Easy - Green
      case 1:
        return const Color(0xFF8BC34A); // Easy - Light Green
      case 2:
        return const Color(0xFFFF9800); // Medium - Orange
      case 3:
        return const Color(0xFFF44336); // Hard - Red
      case 4:
        return const Color(0xFFD32F2F); // Very Hard - Dark Red
      default:
        return const Color(0xFF2196F3);
    }
  }
}
