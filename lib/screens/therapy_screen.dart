import 'package:flutter/material.dart';
import '../models/phobia.dart';
import '../services/phobia_service.dart';
import 'celebration_screen.dart';

class TherapyScreen extends StatefulWidget {
  final Phobia phobia;
  final String difficulty;

  const TherapyScreen({
    super.key,
    required this.phobia,
    required this.difficulty,
  });

  @override
  State<TherapyScreen> createState() => _TherapyScreenState();
}

class _TherapyScreenState extends State<TherapyScreen> {
  int _currentStep = 0;
  bool _isCompleted = false;

  List<Map<String, dynamic>> _getTherapySteps() {
    switch (widget.phobia.name.toLowerCase()) {
      case 'dogs':
        return [
          {
            'title': 'Understanding Dogs',
            'description': 'Learn about different dog breeds and their characteristics. Most dogs are friendly and well-trained.',
            'image': 'https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Cartoon Dogs',
            'description': 'Look at friendly cartoon dogs. Notice how they\'re designed to be cute and approachable.',
            'image': 'https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Small Dogs',
            'description': 'View pictures of small, friendly dogs. These are often less intimidating.',
            'image': 'https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Dog Body Language',
            'description': 'Learn to read dog body language. This helps you understand when a dog is friendly.',
            'image': 'https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Medium Dogs',
            'description': 'Look at pictures of medium-sized dogs. Notice their friendly expressions.',
            'image': 'https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Large Dogs',
            'description': 'View pictures of large dogs. Remember that size doesn\'t determine friendliness.',
            'image': 'https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
        ];
      case 'spiders':
        return [
          {
            'title': 'Understanding Spiders',
            'description': 'Learn about different spider species and their role in the ecosystem.',
            'image': 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Cartoon Spiders',
            'description': 'Look at friendly cartoon spiders. Notice how they\'re designed to be cute.',
            'image': 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Small Spiders',
            'description': 'View pictures of small, harmless spiders.',
            'image': 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Spider Facts',
            'description': 'Learn interesting facts about spiders and their behavior.',
            'image': 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Medium Spiders',
            'description': 'Look at pictures of medium-sized spiders.',
            'image': 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Large Spiders',
            'description': 'View pictures of larger spiders. Remember that most are harmless.',
            'image': 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
        ];
      case 'heights':
        return [
          {
            'title': 'Understanding Heights',
            'description': 'Learn about safety measures in modern buildings and structures.',
            'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Low Heights',
            'description': 'Look at pictures from low heights, like a first-floor balcony.',
            'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Medium Heights',
            'description': 'View pictures from medium heights, like a second or third floor.',
            'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Safety Measures',
            'description': 'Learn about modern safety features in buildings and structures.',
            'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'High Places',
            'description': 'Look at pictures from higher places, like tall buildings.',
            'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Very High Places',
            'description': 'View pictures from very high places, like skyscrapers.',
            'image': 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
        ];
      case 'flying':
        return [
          {
            'title': 'Understanding Air Travel',
            'description': 'Learn about modern aviation safety and statistics. Air travel is one of the safest modes of transportation.',
            'image': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Airport Environment',
            'description': 'Look at pictures of airport terminals and boarding areas. Familiarize yourself with the environment.',
            'image': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Small Aircraft',
            'description': 'View pictures of small aircraft and private jets. These are often less intimidating than large commercial planes.',
            'image': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Safety Features',
            'description': 'Learn about aircraft safety features and emergency procedures. Understanding these can help reduce anxiety.',
            'image': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Commercial Aircraft',
            'description': 'Look at pictures of commercial aircraft interiors. Notice the spacious and comfortable environment.',
            'image': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Takeoff and Landing',
            'description': 'View videos and images of takeoff and landing procedures. These are normal parts of air travel.',
            'image': 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
        ];
      case 'public speaking':
        return [
          {
            'title': 'Understanding Public Speaking',
            'description': 'Learn about common fears in public speaking and proven techniques to overcome them.',
            'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Small Groups',
            'description': 'Practice speaking in front of a mirror. This is a safe way to start building confidence.',
            'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Friendly Audience',
            'description': 'Imagine speaking to a small, friendly audience. Visualize their supportive reactions.',
            'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Speaking Techniques',
            'description': 'Learn breathing and relaxation techniques to manage anxiety while speaking.',
            'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Medium Audience',
            'description': 'Visualize speaking to a medium-sized audience. Focus on maintaining eye contact.',
            'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Large Audience',
            'description': 'Imagine speaking to a large audience. Remember that most people are supportive.',
            'image': 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
        ];
      case 'claustrophobia':
        return [
          {
            'title': 'Understanding Claustrophobia',
            'description': 'Learn about claustrophobia and common triggers. Understanding your fear is the first step to overcoming it.',
            'image': 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Open Spaces',
            'description': 'Look at pictures of open, spacious areas. Notice how they make you feel.',
            'image': 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Small Rooms',
            'description': 'View pictures of small, well-lit rooms. Notice that they can be comfortable and safe.',
            'image': 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Coping Strategies',
            'description': 'Learn breathing techniques and mental strategies to manage anxiety in confined spaces.',
            'image': 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Elevators',
            'description': 'Look at pictures of elevators. Notice their safety features and emergency options.',
            'image': 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Confined Spaces',
            'description': 'View pictures of various confined spaces. Remember that you can always leave if needed.',
            'image': 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
        ];
      default:
        return [
          {
            'title': 'Understanding Your Fear',
            'description': 'Learn about your phobia and common misconceptions.',
            'image': 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Mild Exposure',
            'description': 'Start with gentle exposure to your fear.',
            'image': 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Medium Exposure',
            'description': 'Gradually increase your exposure level.',
            'image': 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Advanced Information',
            'description': 'Learn more detailed information about your fear.',
            'image': 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'info',
          },
          {
            'title': 'Stronger Exposure',
            'description': 'Face more challenging exposure scenarios.',
            'image': 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
          {
            'title': 'Maximum Exposure',
            'description': 'Confront your fear in its most challenging form.',
            'image': 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
            'type': 'exposure',
          },
        ];
    }
  }

  Color _getDifficultyColor() {
    switch (widget.difficulty) {
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
    final steps = _getTherapySteps();
    final currentStep = steps[_currentStep];

    return Scaffold(
      appBar: AppBar(
        title: Text('Step ${_currentStep + 1} of ${steps.length}'),
        backgroundColor: _getDifficultyColor(),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Image Section
                  Stack(
                    children: [
                      Image.network(
                        currentStep['image'],
                        height: 300,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            height: 300,
                            color: Colors.grey[300],
                            child: const Icon(Icons.error),
                          );
                        },
                      ),
                      Container(
                        height: 300,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                              Colors.transparent,
                              Colors.black.withOpacity(0.7),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  // Content Section
                  Padding(
                    padding: const EdgeInsets.all(20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          currentStep['title'],
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          currentStep['description'],
                          style: const TextStyle(
                            fontSize: 16,
                            height: 1.5,
                          ),
                        ),
                        const SizedBox(height: 24),
                        if (currentStep['type'] == 'exposure') ...[
                          const Text(
                            'Exposure Exercise',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.all(16),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor().withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: _getDifficultyColor().withOpacity(0.3),
                              ),
                            ),
                            child: Column(
                              children: [
                                const Text(
                                  'Take a deep breath and look at the image above.',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                const Text(
                                  'Try to observe your thoughts and feelings without judgment. Remember, you are safe and in control.',
                                  style: TextStyle(fontSize: 16),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Navigation Buttons
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
            child: Row(
              children: [
                if (_currentStep > 0)
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.grey[300],
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      onPressed: () {
                        setState(() {
                          _currentStep--;
                          _isCompleted = false;
                        });
                      },
                      child: const Text(
                        'Previous',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ),
                  ),
                if (_currentStep > 0) const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _getDifficultyColor(),
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () async {
                      if (_currentStep < steps.length - 1) {
                        setState(() {
                          _currentStep++;
                          _isCompleted = false;
                        });
                      } else {
                        // Mark difficulty as completed
                        await PhobiaService.markDifficultyCompleted(
                          widget.phobia.name,
                          widget.difficulty,
                        );
                        
                        // Check if all difficulties are completed
                        final isPhobiaCompleted = await PhobiaService.isPhobiaCompleted(
                          widget.phobia.name,
                        );

                        if (!mounted) return;

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => CelebrationScreen(
                              phobia: widget.phobia,
                              difficulty: widget.difficulty,
                              isPhobiaCompleted: isPhobiaCompleted,
                            ),
                          ),
                        );
                      }
                    },
                    child: Text(
                      _currentStep < steps.length - 1 ? 'Next' : 'Complete',
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 