import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'exposure_therapy_screen.dart';

class ExposureDifficultyScreen extends StatefulWidget {
  final String phobiaId;
  final String phobiaName;

  const ExposureDifficultyScreen({
    super.key,
    required this.phobiaId,
    required this.phobiaName,
  });

  @override
  State<ExposureDifficultyScreen> createState() => _ExposureDifficultyScreenState();
}

class _ExposureDifficultyScreenState extends State<ExposureDifficultyScreen> {
  bool _isLoading = true;
  final Map<int, Map<String, dynamic>> _difficultyData = {
    1: {
      'title': 'Easy',
      'description': 'Start with gentle exposure to your fear.',
      'icon': Icons.sentiment_satisfied,
      'color': Colors.green,
      'duration': '5-10 minutes',
    },
    2: {
      'title': 'Medium',
      'description': 'Gradually increase your exposure level.',
      'icon': Icons.sentiment_neutral,
      'color': Colors.orange,
      'duration': '10-15 minutes',
    },
    3: {
      'title': 'Hard',
      'description': 'Face more challenging exposure scenarios.',
      'icon': Icons.sentiment_dissatisfied,
      'color': Colors.red,
      'duration': '15-20 minutes',
    },
  };

  Map<int, int> _progress = {};

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      setState(() {
        for (var i = 1; i <= 3; i++) {
          // First check if the difficulty is marked as completed
          final completedKey = '${widget.phobiaId}_difficulty_${i}_completed';
          final isCompleted = prefs.getBool(completedKey) ?? false;
          
          if (isCompleted) {
            _progress[i] = 100; // Set to 100% if completed
          } else {
            // Otherwise load the saved progress
            _progress[i] = prefs.getInt('${widget.phobiaId}_difficulty_$i') ?? 0;
          }
        }
        _isLoading = false;
      });
    } catch (e) {
      print('Error loading progress: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> _saveProgress(int difficulty, int progress) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setInt('${widget.phobiaId}_difficulty_$difficulty', progress);
      setState(() {
        _progress[difficulty] = progress;
      });
    } catch (e) {
      print('Error saving progress: $e');
    }
  }

  void _showDifficultyInfo(Map<String, dynamic> data) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(data['title']),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(data['description']),
            const SizedBox(height: 8),
            Text(
              'Estimated duration: ${data['duration']}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Got it'),
          ),
        ],
      ),
    );
  }

  void _navigateToTherapy(int difficulty) {
    String difficultyName = _difficultyData[difficulty]!['title'].toString().toLowerCase();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ExposureTherapyScreen(
          phobiaId: widget.phobiaId,
          phobiaName: widget.phobiaName,
          difficulty: difficultyName,
          initialLevel: 1,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (_isLoading) {
      return const Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

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
        title: Text(
          '${widget.phobiaName} - Select Difficulty',
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 24,
          ),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.restore),
            tooltip: 'Reset Progress',
            onPressed: _showResetProgressDialog,
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('About Difficulty Levels'),
                  content: const Text(
                    'Choose a difficulty level that matches your comfort zone.\n\n'
                    '• Start with Mild if you\'re new to exposure therapy\n'
                    '• Progress gradually through the levels\n'
                    '• Take breaks when needed\n'
                    '• Use breathing exercises if anxiety increases'
                  ),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Got it'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _difficultyData.length,
        itemBuilder: (context, index) {
          final difficulty = index + 1;
          final data = _difficultyData[difficulty]!;
          final progress = _progress[difficulty] ?? 0;
          
          return Card(
            margin: const EdgeInsets.only(bottom: 16),
            child: InkWell(
              onTap: () => _navigateToTherapy(difficulty),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          data['icon'],
                          color: data['color'],
                          size: 32,
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                data['title'],
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                data['description'],
                                style: TextStyle(
                                  color: Colors.grey[600],
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.info_outline),
                          onPressed: () => _showDifficultyInfo(data),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    LinearProgressIndicator(
                      value: progress / 100,
                      backgroundColor: Colors.grey[200],
                      valueColor: AlwaysStoppedAnimation<Color>(data['color']),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Progress: $progress%',
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
                          ),
                        ),
                        Text(
                          data['duration'],
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 12,
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
    );
  }

  void _showResetProgressDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Reset Progress'),
        content: const Text(
          'This will reset all your progress for this phobia across all difficulty levels. '
          'You will need to start over from the beginning. This action cannot be undone.'
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () async {
              Navigator.pop(context);
              await _resetProgress();
            },
            style: TextButton.styleFrom(
              foregroundColor: Colors.red,
            ),
            child: const Text('Reset'),
          ),
        ],
      ),
    );
  }

  Future<void> _resetProgress() async {
    final prefs = await SharedPreferences.getInstance();
    
    for (int difficulty = 1; difficulty <= 3; difficulty++) {
      for (int level = 1; level <= 3; level++) {
        final levelKey = '${widget.phobiaId}_difficulty_${difficulty}_level_$level';
        await prefs.remove(levelKey);
      }
      
      await prefs.remove('${widget.phobiaId}_difficulty_$difficulty');
      
      await prefs.remove('${widget.phobiaId}_difficulty_${difficulty}_completed');
    }
    
    await _loadProgress();
    
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('All progress has been reset.'),
          backgroundColor: Color(0xFF7B8EF7),
          duration: Duration(seconds: 3),
        ),
      );
    }
  }
} 