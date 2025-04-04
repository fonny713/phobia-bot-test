import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:ui' as ui;

class PhobiaListScreen extends StatefulWidget {
  const PhobiaListScreen({super.key});

  @override
  State<PhobiaListScreen> createState() => _PhobiaListScreenState();
}

class _PhobiaListScreenState extends State<PhobiaListScreen> {
  final List<Map<String, dynamic>> _phobias = [
    {
      'id': 'arachnophobia',
      'title': 'Arachnophobia',
      'description': 'Fear of spiders and other arachnids',
      'icon': Icons.bug_report,
      'color': Colors.brown,
      'prevalence': 'Most common specific phobia',
      'symptoms': 'Anxiety, panic attacks, avoidance behavior',
      'image': 'spider_phobia.jpg',
    },
    {
      'id': 'acrophobia',
      'title': 'Acrophobia',
      'description': 'Fear of heights',
      'icon': Icons.height,
      'color': Colors.blue,
      'prevalence': 'Affects about 5% of people',
      'symptoms': 'Dizziness, vertigo, anxiety in high places',
      'image': 'height_phobia.jpg',
    },
    {
      'id': 'social_phobia',
      'title': 'Social Phobia',
      'description': 'Fear of social situations and interactions',
      'icon': Icons.people,
      'color': Colors.purple,
      'prevalence': 'Affects about 7% of adults',
      'symptoms': 'Social anxiety, fear of judgment, avoidance',
      'image': 'social_phobia.jpg',
    },
  ];

  String? _selectedPhobiaId;
  Map<String, int> _progress = {};
  Map<String, ui.Image?> _phobiaImages = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
    _loadImages();
  }

  Future<void> _loadImages() async {
    for (var phobia in _phobias) {
      try {
        final imageProvider = AssetImage(phobia['image']);
        final imageStream = imageProvider.resolve(ImageConfiguration.empty);
        
        imageStream.addListener(
          ImageStreamListener((ImageInfo info, bool _) {
            setState(() {
              _phobiaImages[phobia['id']] = info.image;
            });
            imageStream.removeListener(ImageStreamListener((ImageInfo info, bool _) {}));
          }),
        );
      } catch (e) {
        print('Error loading image for ${phobia['id']}: $e');
      }
    }
  }

  Future<void> _loadProgress() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      for (var phobia in _phobias) {
        // Calculate overall progress based on all difficulty levels
        int totalProgress = 0;
        int completedDifficulties = 0;
        
        // Check each difficulty level (1-3)
        for (int difficulty = 1; difficulty <= 3; difficulty++) {
          // First check if the difficulty is marked as completed
          final completedKey = '${phobia['id']}_difficulty_${difficulty}_completed';
          final isCompleted = prefs.getBool(completedKey) ?? false;
          
          if (isCompleted) {
            totalProgress += 100;
            completedDifficulties++;
          } else {
            // Otherwise load the saved progress
            final difficultyProgress = prefs.getInt('${phobia['id']}_difficulty_$difficulty') ?? 0;
            totalProgress += difficultyProgress;
          }
        }
        
        // Calculate average progress across all difficulty levels
        final averageProgress = totalProgress ~/ 3;
        _progress[phobia['id']] = averageProgress;
      }
    });
  }

  Future<void> _saveProgress(String phobiaId, int progress) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt('phobia_progress_$phobiaId', progress);
    setState(() {
      _progress[phobiaId] = progress;
    });
  }

  void _showPhobiaInfo(Map<String, dynamic> phobia) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        title: Row(
          children: [
            Icon(phobia['icon'], color: phobia['color'], size: 28),
            const SizedBox(width: 12),
            Text(phobia['title']),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Display the phobia image with transparency
            if (_phobiaImages[phobia['id']] != null)
              Container(
                height: 150,
                width: double.infinity,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: phobia['color'].withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: RawImage(
                    image: _phobiaImages[phobia['id']],
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: phobia['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Prevalence:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phobia['prevalence'],
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: phobia['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Common Symptoms:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    phobia['symptoms'],
                    style: const TextStyle(fontSize: 15),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: phobia['color'].withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Progress:',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: (_progress[phobia['id']] ?? 0) / 100,
                    backgroundColor: Colors.grey[300],
                    valueColor: AlwaysStoppedAnimation<Color>(phobia['color']),
                    minHeight: 10,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${_progress[phobia['id']] ?? 0}% completed',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: phobia['color'],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Theme.of(context).primaryColor.withOpacity(0.8),
                Theme.of(context).primaryColor.withOpacity(0.6),
              ],
            ),
          ),
        ),
        title: const Text(
          'Choose Your Phobia',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  title: const Text('About Phobias'),
                  content: const Text(
                    'Select a phobia to begin your exposure therapy journey. Each phobia has different difficulty levels and exercises to help you overcome your fear.',
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Close'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Colors.white,
              Colors.grey[100]!,
            ],
          ),
        ),
        child: ListView.builder(
          padding: const EdgeInsets.all(24),
          itemCount: _phobias.length,
          itemBuilder: (context, index) {
            final phobia = _phobias[index];
            final progress = _progress[phobia['id']] ?? 0;
            
            return Card(
              margin: const EdgeInsets.only(bottom: 24),
              elevation: 4,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: InkWell(
                onTap: () {
                  setState(() => _selectedPhobiaId = phobia['id']);
                  Navigator.pushNamed(
                    context,
                    '/exposure_difficulty',
                    arguments: {
                      'phobiaId': phobia['id'],
                      'phobiaName': phobia['title'],
                    },
                  );
                },
                borderRadius: BorderRadius.circular(20),
                child: Container(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          // Display the phobia image with transparency
                          if (_phobiaImages[phobia['id']] != null)
                            Container(
                              width: 60,
                              height: 60,
                              margin: const EdgeInsets.only(right: 16),
                              decoration: BoxDecoration(
                                color: phobia['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Center(
                                child: RawImage(
                                  image: _phobiaImages[phobia['id']],
                                  fit: BoxFit.contain,
                                ),
                              ),
                            )
                          else
                            Container(
                              padding: const EdgeInsets.all(12),
                              decoration: BoxDecoration(
                                color: phobia['color'].withOpacity(0.1),
                                borderRadius: BorderRadius.circular(16),
                              ),
                              child: Icon(
                                phobia['icon'],
                                color: phobia['color'],
                                size: 32,
                              ),
                            ),
                          const SizedBox(width: 20),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  phobia['title'],
                                  style: const TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 6),
                                Text(
                                  phobia['description'],
                                  style: TextStyle(
                                    color: Colors.grey[600],
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.info_outline, size: 28),
                            color: phobia['color'],
                            onPressed: () => _showPhobiaInfo(phobia),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Overall Progress',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: Colors.grey[700],
                                ),
                              ),
                              Text(
                                '$progress%',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  color: phobia['color'],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          LinearProgressIndicator(
                            value: progress / 100,
                            backgroundColor: Colors.grey[300],
                            valueColor: AlwaysStoppedAnimation<Color>(phobia['color']),
                            minHeight: 10,
                            borderRadius: BorderRadius.circular(5),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          TextButton.icon(
                            onPressed: () {
                              setState(() => _selectedPhobiaId = phobia['id']);
                              Navigator.pushNamed(
                                context,
                                '/exposure_difficulty',
                                arguments: {
                                  'phobiaId': phobia['id'],
                                  'phobiaName': phobia['title'],
                                },
                              );
                            },
                            icon: const Icon(Icons.play_arrow),
                            label: const Text('Start Therapy'),
                            style: TextButton.styleFrom(
                              foregroundColor: Colors.white,
                              backgroundColor: phobia['color'],
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
} 