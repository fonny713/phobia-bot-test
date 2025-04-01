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
          "Poziom trudności",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFFB3CCF4), Color(0xFFCFDEF3)], // Gradient background
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: _levels.asMap().entries.map((entry) {
                int index = entry.key;
                var data = entry.value;
                final isUnlocked = index + 1 <= _unlockedLevel;

                return GestureDetector(
                  onTap: () => isUnlocked ? _navigateToDifficulty(index) : null,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(20),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: [
                            ElevatedButton.icon(
                              onPressed: null,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: isUnlocked
                                    ? Colors.white.withOpacity(0.25) // More visible
                                    : Colors.white.withOpacity(0.1), // Darker for locked
                                foregroundColor: Colors.white,
                                minimumSize: const Size.fromHeight(60),
                                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                                elevation: 0,
                              ),
                              icon: Icon(data['icon'], size: 24, color: isUnlocked ? Colors.white : Colors.white54),
                              label: Text(
                                data['label'],
                                style: TextStyle(
                                  fontSize: 18,
                                  color: isUnlocked ? Colors.white : Colors.white54,
                                ),
                              ),
                            ),
                            if (!isUnlocked)
                              const Padding(
                                padding: EdgeInsets.only(right: 20),
                                child: Icon(Icons.lock, color: Colors.white70, size: 28),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
        ),
      ),
    );
  }
}
