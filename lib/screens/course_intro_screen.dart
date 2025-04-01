import 'package:flutter/material.dart';
import '../models/phobia.dart';
import 'therapy_screen.dart';

class CourseIntroScreen extends StatelessWidget {
  final Phobia phobia;
  final String difficulty;

  const CourseIntroScreen({
    super.key,
    required this.phobia,
    required this.difficulty,
  });

  String get _getIntroText {
    switch (difficulty) {
      case 'easy':
        return 'We\'ll start with gentle exposure exercises. Remember, you\'re in control, and you can take breaks whenever needed. This level focuses on building your confidence gradually.';
      case 'medium':
        return 'This intermediate level will challenge you more, but you\'re ready for it. We\'ll use proven techniques to help you face your fears with growing confidence.';
      case 'hard':
        return 'You\'ve chosen the advanced level - that\'s brave! We\'ll work through intensive exposure exercises. Remember your progress so far and trust in your ability to overcome this fear.';
      default:
        return '';
    }
  }

  String get _getTipsText {
    switch (difficulty) {
      case 'easy':
        return '• Take deep breaths when feeling anxious\n• Start with just a few minutes\n• Use positive self-talk\n• Remember you can stop anytime';
      case 'medium':
        return '• Practice relaxation techniques\n• Focus on your progress\n• Challenge negative thoughts\n• Stay with the exposure a bit longer';
      case 'hard':
        return '• Use all your learned coping skills\n• Trust in your preparation\n• Push your boundaries safely\n• Celebrate each success';
      default:
        return '';
    }
  }

  Color get _getDifficultyColor {
    switch (difficulty) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'medium':
        return const Color(0xFFFF9800);
      case 'hard':
        return const Color(0xFFf44336);
      default:
        return const Color(0xFF2196F3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // Header Image with Gradient Overlay
                    Stack(
                      children: [
                        Image.network(
                          phobia.imageUrl,
                          height: 250,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              height: 250,
                              color: Colors.grey[300],
                              child: const Icon(Icons.error),
                            );
                          },
                        ),
                        Container(
                          height: 250,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.transparent,
                                _getDifficultyColor.withOpacity(0.8),
                              ],
                            ),
                          ),
                        ),
                        Positioned(
                          top: 16,
                          left: 16,
                          child: IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => Navigator.pop(context),
                          ),
                        ),
                        Positioned(
                          bottom: 20,
                          left: 20,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                phobia.name,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 12,
                                  vertical: 6,
                                ),
                                decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  '${difficulty[0].toUpperCase()}${difficulty.substring(1)} Level',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'About This Course',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            _getIntroText,
                            style: const TextStyle(
                              fontSize: 16,
                              height: 1.5,
                            ),
                          ),
                          const SizedBox(height: 24),
                          const Text(
                            'Tips for Success',
                            style: TextStyle(
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getDifficultyColor.withOpacity(0.3),
                              ),
                            ),
                            child: Text(
                              _getTipsText,
                              style: TextStyle(
                                fontSize: 16,
                                height: 1.5,
                                color: _getDifficultyColor,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Start Button
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Colors.white,
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    spreadRadius: 0,
                    blurRadius: 10,
                    offset: const Offset(0, -5),
                  ),
                ],
              ),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: _getDifficultyColor,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (_) => TherapyScreen(
                        phobia: phobia,
                        difficulty: difficulty,
                      ),
                    ),
                  );
                },
                child: const Text(
                  'Begin Healing Journey',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
} 