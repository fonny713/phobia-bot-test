import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/firebase_storage_service.dart';
import '../services/firebase_connectivity_checker.dart';
import 'dart:io';
import 'dart:math' show pi, Random, cos, sin;

class ExposureTherapyScreen extends StatefulWidget {
  final String phobiaId;
  final String phobiaName;
  final dynamic difficulty;
  final int initialLevel;

  const ExposureTherapyScreen({
    super.key,
    required this.phobiaId,
    required this.phobiaName,
    required this.difficulty,
    required this.initialLevel,
  });

  @override
  State<ExposureTherapyScreen> createState() => _ExposureTherapyScreenState();
}

class _ExposureTherapyScreenState extends State<ExposureTherapyScreen> with TickerProviderStateMixin {
  late int _currentLevel;
  late ConfettiController _confettiController;
  late AnimationController _animationController;
  late AnimationController _fireworksController;
  late AnimationController _particleController;
  late AnimationController _starController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _animation;
  Map<String, dynamic> _cachedMedia = {};
  bool _isLoading = true;
  bool _isExposureComplete = false;
  int _remainingSeconds = 0;

  // Emotion rating before and after exposure
  double _preExposureEmotion = 5.0;
  double _postExposureEmotion = 5.0;

  // Convert string difficulty to number
  int get _difficultyLevel {
    if (widget.difficulty is int) return widget.difficulty;
    switch(widget.difficulty.toString().toLowerCase()) {
      case 'easy':
        return 1;
      case 'medium':
        return 2;
      case 'hard':
        return 3;
      default:
        return 1;
    }
  }

  // Progress tracking
  final Map<String, Map<int, Map<int, Map<String, dynamic>>>> _phobiaData = {
    'arachnophobia': {
      1: { // Easy difficulty
        1: {
          'fileName': 'arachnophobia/cartoon_spider.png',
          'fact': 'Spiders have 4 to 8 eyes.',
          'duration': 30,
        },
        2: {
          'fileName': 'arachnophobia/cartoon_spider2.jpg',
          'fact': 'Spider webs are very strong.',
          'duration': 30,
        },
        3: {
          'fileName': 'arachnophobia/cartoon_spider3.jpg',
          'fact': 'Some spiders can float on the wind.',
          'duration': 30,
        },
      },
      2: { // Medium difficulty
        1: {
          'fileName': 'arachnophobia/spider_real_1.jpg',
          'fact': 'Spiders can survive without food for weeks.',
          'duration': 30,
        },
        2: {
          'fileName': 'arachnophobia/spider_real_2.jpg',
          'fact': 'Spiders molt to grow larger.',
          'duration': 30,
        },
        3: {
          'fileName': 'arachnophobia/spider_real_3.jpg',
          'fact': 'Female spiders are usually larger than males.',
          'duration': 30,
        },
      },
      3: { // Hard difficulty
        1: {
          'fileName': 'arachnophobia/spider_real_4.jpg',
          'fact': 'Most spiders are not dangerous to humans.',
          'duration': 30,
        },
        2: {
          'fileName': 'arachnophobia/spider_real_5.jpg',
          'fact': 'Spiders help control insect populations.',
          'duration': 30,
        },
        3: {
          'fileName': 'arachnophobia/spider_real_6.jpg',
          'fact': 'Spider venom mainly affects insects.',
          'duration': 30,
        },
      },
    },
    'acrophobia': {
      1: { // Easy difficulty
        1: {
          'fileName': 'acrophobia/height_cartoon_1.jpg',
          'fact': 'Fear of heights is a common phobia.',
          'duration': 30,
        },
        2: {
          'fileName': 'acrophobia/height_cartoon_2.jpg',
          'fact': 'Modern buildings are designed with safety in mind.',
          'duration': 30,
        },
        3: {
          'fileName': 'acrophobia/height_cartoon_3.jpg',
          'fact': 'Gradual exposure can help overcome height fear.',
          'duration': 30,
        },
      },
      2: { // Medium difficulty
        1: {
          'fileName': 'acrophobia/height_real_1.jpg',
          'fact': 'Understanding your fear is the first step.',
          'duration': 30,
        },
        2: {
          'fileName': 'acrophobia/height_real_2.jpg',
          'fact': 'Professional help can guide you through exposure.',
          'duration': 30,
        },
        3: {
          'fileName': 'acrophobia/height_real_3.jpg',
          'fact': 'Regular practice can reduce anxiety over time.',
          'duration': 30,
        },
      },
      3: { // Hard difficulty
        1: {
          'fileName': 'acrophobia/height_real_4.jpg',
          'fact': 'Safety equipment makes high places manageable.',
          'duration': 30,
        },
        2: {
          'fileName': 'acrophobia/height_real_5.jpg',
          'fact': 'Many activities can help overcome height fear.',
          'duration': 30,
        },
        3: {
          'fileName': 'acrophobia/height_real_6.jpg',
          'fact': 'Regular exposure helps build confidence.',
          'duration': 30,
        },
      },
    },
    'social_phobia': {
      1: { // Easy difficulty
        1: {
          'fileName': 'social_phobia/social_cartoon_1.jpg',
          'fact': 'Social anxiety is common and treatable.',
          'duration': 30,
        },
        2: {
          'fileName': 'social_phobia/social_cartoon_2.jpg',
          'fact': 'Small social interactions can build confidence.',
          'duration': 30,
        },
        3: {
          'fileName': 'social_phobia/social_cartoon_3.jpg',
          'fact': 'Practice can help overcome social anxiety.',
          'duration': 30,
        },
      },
      2: { // Medium difficulty
        1: {
          'fileName': 'social_phobia/social_real_1.jpg',
          'fact': 'Understanding triggers helps manage anxiety.',
          'duration': 30,
        },
        2: {
          'fileName': 'social_phobia/social_real_2.jpg',
          'fact': 'Professional guidance can be very helpful.',
          'duration': 30,
        },
        3: {
          'fileName': 'social_phobia/social_real_3.jpg',
          'fact': 'Regular practice reduces social anxiety.',
          'duration': 30,
        },
      },
      3: { // Hard difficulty
        1: {
          'fileName': 'social_phobia/social_real_4.jpg',
          'fact': 'Many people successfully overcome social anxiety.',
          'duration': 30,
        },
        2: {
          'fileName': 'social_phobia/social_real_5.jpg',
          'fact': 'Social confidence grows with experience.',
          'duration': 30,
        },
        3: {
          'fileName': 'social_phobia/social_real_6.jpg',
          'fact': 'Most people are understanding of social anxiety.',
          'duration': 30,
        },
      },
    },
  };

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.initialLevel;
    _confettiController = ConfettiController(duration: const Duration(seconds: 2));
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 500),
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.1),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _fireworksController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _particleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _starController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    
    // Initialize media and start animation
    _initializeAndLoadMedia().then((_) {
      if (mounted) {
        _animationController.forward();
      }
    });
    
    // Preload next images
    _preloadNextImages();
  }

  Future<void> _preloadNextImages() async {
    final currentLevelData = _phobiaData[widget.phobiaId]?[_difficultyLevel];
    if (currentLevelData == null) return;

    // Get next 2 levels' image names
    final imagesToPreload = <String>[];
    for (int i = _currentLevel + 1; i <= _currentLevel + 2; i++) {
      if (currentLevelData.containsKey(i)) {
        final fileName = currentLevelData[i]?['fileName'] as String?;
        if (fileName != null) {
          imagesToPreload.add(fileName);
        }
      }
    }

    // Preload images in background
    if (imagesToPreload.isNotEmpty) {
      FirebaseStorageService.preloadImages(imagesToPreload);
    }
  }

  Future<void> _initializeAndLoadMedia() async {
    setState(() {
      _isLoading = true;
    });
    
    try {
      final levelInfo = _phobiaData[widget.phobiaId]?[_difficultyLevel]?[_currentLevel];
      
      if (levelInfo == null) {
        print('No media info found for phobia: ${widget.phobiaId}, difficulty: ${_difficultyLevel}, level: $_currentLevel');
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      final fileName = levelInfo['fileName'];
      print('Attempting to load image: $fileName');
      
      // Check if we already have this image cached
      if (_cachedMedia.containsKey(fileName) && _cachedMedia[fileName] != null) {
        print('Using cached image: $fileName');
        setState(() {
          _isLoading = false;
        });
        return;
      }
      
      // Try to download the image
      try {
        final file = await FirebaseStorageService.downloadImage(fileName);
        if (file != null) {
          setState(() {
            _cachedMedia[fileName] = file;
            _isLoading = false;
          });
          print('Successfully loaded image: $fileName');
        } else {
          print('Failed to download image: $fileName');
          setState(() {
            _cachedMedia[fileName] = null;
            _isLoading = false;
          });
        }
      } catch (e) {
        print('Error downloading image $fileName: $e');
        setState(() {
          _cachedMedia[fileName] = null;
          _isLoading = false;
        });
        
        // Show error dialog
        if (mounted) {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Image Loading Error'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Failed to load image: $fileName'),
                  const SizedBox(height: 8),
                  const Text('Possible reasons:'),
                  const SizedBox(height: 4),
                  const Text('• Image does not exist in storage'),
                  const Text('• Network connection issues'),
                  const Text('• Firebase configuration issues'),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('OK'),
                ),
                TextButton(
                  onPressed: () {
                    Navigator.pop(context);
                    _initializeAndLoadMedia();
                  },
                  child: const Text('Retry'),
                ),
              ],
            ),
          );
        }
      }
    } catch (e) {
      print('Error in _initializeAndLoadMedia: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    _animationController.dispose();
    _fireworksController.dispose();
    _particleController.dispose();
    _starController.dispose();
    super.dispose();
  }

  Future<void> _saveProgress() async {
    final prefs = await SharedPreferences.getInstance();
    final key = '${widget.phobiaId}_difficulty_${_difficultyLevel}_level_$_currentLevel';
    await prefs.setDouble(key, _postExposureEmotion);
    
    // Calculate overall progress for this difficulty level
    int completedLevels = 0;
    for (int i = 1; i <= 3; i++) {
      final levelKey = '${widget.phobiaId}_difficulty_${_difficultyLevel}_level_$i';
      final value = await prefs.getDouble(levelKey);
      if (value != null) {
        completedLevels++;
      }
    }
    
    // Calculate progress percentage (3 levels per difficulty)
    final progress = (completedLevels / 3 * 100).round();
    await prefs.setInt('${widget.phobiaId}_difficulty_${_difficultyLevel}', progress);

    // If all levels are completed, mark this difficulty as completed
    if (completedLevels == 3) {
      final completedKey = '${widget.phobiaId}_difficulty_${_difficultyLevel}_completed';
      await prefs.setBool(completedKey, true);
    }
  }

  Future<void> _loadNextLevel() async {
    final maxLevel = _phobiaData[widget.phobiaId]?[_difficultyLevel]?.length ?? 1;
    if (_currentLevel < maxLevel) {
      setState(() {
        _currentLevel++;
        _isLoading = true;
      });
      _animationController.reset();
      await _initializeAndLoadMedia();
      _animationController.forward();
    }
  }

  Future<void> _loadPreviousLevel() async {
    if (_currentLevel > 1) {
      setState(() {
        _currentLevel--;
        _isLoading = true;
      });
      _animationController.reset();
      await _initializeAndLoadMedia();
      _animationController.forward();
    }
  }

  void _showHelpDialog() {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('How it works'),
        content: const Text(
          '1. View the image for the specified duration\n'
          '2. Read the fact about your phobia\n'
          '3. Use the arrows to navigate between levels'
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

  Future<void> _startExposure() async {
    final levelInfo = _phobiaData[widget.phobiaId]?[_difficultyLevel]?[_currentLevel];
    if (levelInfo == null) return;

    setState(() {
      _isExposureComplete = false;
    });

    if (!mounted) return;

    setState(() {
      _isExposureComplete = true;
    });
  }

  void _showLevelCompleteDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          backgroundColor: Colors.transparent,
          elevation: 0,
          child: Container(
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: const Color(0xFF7B8EF7).withOpacity(0.3),
                  blurRadius: 20,
                  spreadRadius: 5,
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                // Animated icon
                TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  curve: Curves.elasticOut,
                  tween: Tween<double>(begin: 0.0, end: 1.0),
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF7B8EF7), Color(0xFF6E7FF3)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF7B8EF7).withOpacity(0.3),
                              blurRadius: 10,
                              spreadRadius: 2,
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.psychology,
                          color: Colors.white,
                          size: 50,
                        ),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 24),
                const Text(
                  'Rate your anxiety',
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF7B8EF7),
                  ),
                ),
                const SizedBox(height: 16),
                const Text(
                  'How do you feel now?',
                  style: TextStyle(
                    fontSize: 18,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 24),
                StatefulBuilder(
                  builder: (context, setSliderState) => Column(
                    children: [
                      // Anxiety level indicator
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: _getAnxietyColor(_postExposureEmotion).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          _getAnxietyText(_postExposureEmotion),
                          style: TextStyle(
                            color: _getAnxietyColor(_postExposureEmotion),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Custom slider
                      SliderTheme(
                        data: SliderThemeData(
                          activeTrackColor: _getAnxietyColor(_postExposureEmotion),
                          inactiveTrackColor: Colors.grey[300],
                          thumbColor: _getAnxietyColor(_postExposureEmotion),
                          overlayColor: _getAnxietyColor(_postExposureEmotion).withOpacity(0.2),
                          valueIndicatorColor: _getAnxietyColor(_postExposureEmotion),
                          valueIndicatorTextStyle: const TextStyle(color: Colors.white),
                          trackHeight: 10,
                          thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 15),
                          overlayShape: const RoundSliderOverlayShape(overlayRadius: 25),
                        ),
                        child: Slider(
                          value: _postExposureEmotion,
                          min: 0,
                          max: 10,
                          divisions: 10,
                          label: _postExposureEmotion.round().toString(),
                          onChanged: (value) {
                            setSliderState(() {
                              _postExposureEmotion = value;
                            });
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              'Less anxious',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                            Text(
                              'More anxious',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () async {
                    Navigator.pop(context);
                    await _saveProgress();
                    if (_currentLevel == 3) {
                      _showCompletionDialog();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF7B8EF7),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    elevation: 5,
                  ),
                  child: const Text(
                    'Save',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getAnxietyColor(double value) {
    if (value < 3) {
      return const Color(0xFF4CAF50); // Green for low anxiety
    } else if (value < 7) {
      return const Color(0xFFFF9800); // Orange for medium anxiety
    } else {
      return const Color(0xFFF44336); // Red for high anxiety
    }
  }

  String _getAnxietyText(double value) {
    if (value < 3) {
      return 'Calm';
    } else if (value < 5) {
      return 'Mild Anxiety';
    } else if (value < 7) {
      return 'Moderate Anxiety';
    } else if (value < 9) {
      return 'High Anxiety';
    } else {
      return 'Extreme Anxiety';
    }
  }

  void _showCompletionDialog() {
    // Reset and start all animations
    _fireworksController.reset();
    _particleController.reset();
    _starController.reset();
    
    _fireworksController.forward();
    _particleController.forward();
    _starController.forward();
    
    // Show full screen celebration instead of a dialog
    showDialog(
      context: context,
      barrierDismissible: false,
      barrierColor: Colors.transparent,
      builder: (context) => Dialog.fullscreen(
        child: Stack(
          fit: StackFit.expand,
          children: [
            // Background gradient
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF7B8EF7), Color(0xFF6E7FF3)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
            
            // Celebration animation overlay
            Positioned.fill(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  // Background glow effect
                  AnimatedBuilder(
                    animation: _fireworksController,
                    builder: (context, child) {
                      return Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: RadialGradient(
                            colors: [
                              Colors.white.withOpacity(0.5 * _fireworksController.value),
                              Colors.white.withOpacity(0.0),
                            ],
                            stops: const [0.0, 1.0],
                          ),
                        ),
                        width: MediaQuery.of(context).size.width * 1.5 * _fireworksController.value,
                        height: MediaQuery.of(context).size.height * 1.5 * _fireworksController.value,
                      );
                    },
                  ),
                  
                  // Animated stars
                  ...List.generate(20, (index) {
                    return AnimatedBuilder(
                      animation: _starController,
                      builder: (context, child) {
                        final angle = (index / 20) * 2 * pi;
                        final radius = 200.0 * _starController.value;
                        final x = cos(angle) * radius;
                        final y = sin(angle) * radius;
                        
                        return Positioned(
                          left: MediaQuery.of(context).size.width / 2 + x,
                          top: MediaQuery.of(context).size.height / 2 + y,
                          child: Transform.scale(
                            scale: 1.0 + 0.5 * sin(_starController.value * pi * 2 + index),
                            child: Icon(
                              Icons.star,
                              color: _getRandomColor().withOpacity(0.8),
                              size: 30 + 15 * sin(_starController.value * pi * 2 + index),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                  
                  // Animated particles
                  ...List.generate(40, (index) {
                    return AnimatedBuilder(
                      animation: _particleController,
                      builder: (context, child) {
                        final random = Random();
                        final startX = random.nextDouble() * MediaQuery.of(context).size.width - MediaQuery.of(context).size.width / 2;
                        final startY = random.nextDouble() * MediaQuery.of(context).size.height - MediaQuery.of(context).size.height / 2;
                        final endX = startX * 2;
                        final endY = startY * 2;
                        
                        final progress = _particleController.value;
                        final x = startX + (endX - startX) * progress;
                        final y = startY + (endY - startY) * progress;
                        
                        return Positioned(
                          left: MediaQuery.of(context).size.width / 2 + x,
                          top: MediaQuery.of(context).size.height / 2 + y,
                          child: Opacity(
                            opacity: (1 - progress).clamp(0.0, 1.0),
                            child: Container(
                              width: 12,
                              height: 12,
                              decoration: BoxDecoration(
                                color: _getRandomColor(),
                                shape: BoxShape.circle,
                                boxShadow: [
                                  BoxShadow(
                                    color: _getRandomColor().withOpacity(0.5),
                                    blurRadius: 10,
                                    spreadRadius: 2,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }),
                ],
              ),
            ),
            
            // Main content container
            Center(
              child: Container(
                width: MediaQuery.of(context).size.width * 0.85,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Animated trophy icon
                    TweenAnimationBuilder<double>(
                      duration: const Duration(milliseconds: 800),
                      curve: Curves.elasticOut,
                      tween: Tween<double>(begin: 0.0, end: 1.0),
                      builder: (context, value, child) {
                        return Transform.scale(
                          scale: value,
                          child: Container(
                            padding: const EdgeInsets.all(20),
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF7B8EF7), Color(0xFF6E7FF3)],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: const Color(0xFF7B8EF7).withOpacity(0.3),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.emoji_events,
                              color: Colors.white,
                              size: 60,
                            ),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Congratulations!',
                      style: TextStyle(
                        fontSize: 36,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF7B8EF7),
                      ),
                    ),
                    const SizedBox(height: 16),
                    const Text(
                      'You\'ve completed all levels!',
                      style: TextStyle(
                        fontSize: 20,
                        color: Colors.grey,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.popUntil(context, (route) => route.isFirst);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF7B8EF7),
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                            ),
                            elevation: 5,
                          ),
                          child: const Text(
                            'Menu',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            Navigator.pop(context);
                            setState(() {
                              _currentLevel = 1;
                              _isExposureComplete = false;
                            });
                            _initializeAndLoadMedia();
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: const Color(0xFF7B8EF7),
                            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(30),
                              side: const BorderSide(color: Color(0xFF7B8EF7), width: 2),
                            ),
                            elevation: 0,
                          ),
                          child: const Text(
                            'Retry',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  
  Color _getRandomColor() {
    final random = Random();
    final colors = [
      const Color(0xFF7B8EF7),
      const Color(0xFF6E7FF3),
      const Color(0xFF4CAF50),
      const Color(0xFFFF9800),
      const Color(0xFFF44336),
      Colors.white,
    ];
    return colors[random.nextInt(colors.length)];
  }

  @override
  Widget build(BuildContext context) {
    final levelInfo = _phobiaData[widget.phobiaId]?[_difficultyLevel]?[_currentLevel];
    final isLastLevel = _currentLevel == 3;
    
    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.phobiaName} - ${widget.difficulty.toString().toUpperCase()}'),
        backgroundColor: const Color(0xFF7B8EF7),
        elevation: 0,
        actions: [
          // Reset progress button removed
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              FirebaseStorageService.resetNetworkStatus();
              _initializeAndLoadMedia();
            },
          ),
          IconButton(
            icon: const Icon(Icons.help_outline),
            onPressed: _showHelpDialog,
          ),
        ],
      ),
      body: Stack(
        children: [
          // Background gradient
          Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xFF7B8EF7), Colors.white],
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
              ),
            ),
          ),
          if (_isLoading)
            const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Color(0xFF7B8EF7)),
              ),
            )
          else
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: FadeTransition(
                      opacity: _fadeAnimation,
                      child: SlideTransition(
                        position: _slideAnimation,
                        child: Card(
                          elevation: 8,
                          shadowColor: const Color(0xFF7B8EF7).withOpacity(0.3),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                // Media display
                                if (_cachedMedia.containsKey(levelInfo?['fileName']) && _cachedMedia[levelInfo!['fileName']] != null)
                                  Expanded(
                                    child: Hero(
                                      tag: 'phobia_image_${levelInfo['fileName']}',
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(15),
                                        child: Image.file(
                                          _cachedMedia[levelInfo['fileName']],
                                          fit: BoxFit.contain,
                                        ),
                                      ),
                                    ),
                                  )
                                else
                                  Expanded(
                                    child: Center(
                                      child: Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        children: [
                                          Icon(
                                            Icons.image,
                                            size: 48,
                                            color: Colors.grey[600],
                                          ),
                                          const SizedBox(height: 16),
                                          Text(
                                            'Image not available',
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                              fontSize: 16,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 16),
                                // Fact display
                                if (levelInfo != null)
                                  Container(
                                    decoration: BoxDecoration(
                                      color: const Color(0xFF7B8EF7).withOpacity(0.1),
                                      borderRadius: BorderRadius.circular(15),
                                      border: Border.all(
                                        color: const Color(0xFF7B8EF7).withOpacity(0.3),
                                        width: 1,
                                      ),
                                    ),
                                    padding: const EdgeInsets.all(16.0),
                                    child: Column(
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              padding: const EdgeInsets.all(8),
                                              decoration: BoxDecoration(
                                                color: const Color(0xFF7B8EF7).withOpacity(0.2),
                                                borderRadius: BorderRadius.circular(10),
                                              ),
                                              child: const Icon(
                                                Icons.lightbulb,
                                                color: Color(0xFF7B8EF7),
                                                size: 20,
                                              ),
                                            ),
                                            const SizedBox(width: 12),
                                            const Text(
                                              'Did you know?',
                                              style: TextStyle(
                                                fontSize: 18,
                                                fontWeight: FontWeight.bold,
                                                color: Color(0xFF7B8EF7),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 12),
                                        Text(
                                          levelInfo['fact'],
                                          textAlign: TextAlign.center,
                                          style: const TextStyle(
                                            fontSize: 16,
                                            color: Color(0xFF7B8EF7),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // Progress indicator and navigation
                  Column(
                    children: [
                      // Level indicator
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
                        decoration: BoxDecoration(
                          color: const Color(0xFF7B8EF7).withOpacity(0.1),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          'Level $_currentLevel of 3',
                          style: const TextStyle(
                            color: Color(0xFF7B8EF7),
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      // Progress bar
                      TweenAnimationBuilder<double>(
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeInOut,
                        tween: Tween<double>(
                          begin: (_currentLevel - 1) / 3,
                          end: _currentLevel / 3,
                        ),
                        builder: (context, value, child) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(10),
                            child: LinearProgressIndicator(
                              value: value,
                              backgroundColor: Colors.grey[200],
                              valueColor: const AlwaysStoppedAnimation<Color>(Color(0xFF7B8EF7)),
                              minHeight: 12,
                            ),
                          );
                        },
                      ),
                      const SizedBox(height: 24),
                      // Navigation buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          if (_currentLevel > 1)
                            ElevatedButton.icon(
                              onPressed: _loadPreviousLevel,
                              icon: const Icon(Icons.arrow_back),
                              label: const Text('Previous'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: const Color(0xFF7B8EF7),
                                side: const BorderSide(color: Color(0xFF7B8EF7), width: 2),
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 0,
                              ),
                            ),
                          if (isLastLevel)
                            ElevatedButton.icon(
                              onPressed: _showLevelCompleteDialog,
                              icon: const Icon(Icons.check_circle),
                              label: const Text('Finish Exposure'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7B8EF7),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                            )
                          else if (_currentLevel < 3)
                            ElevatedButton.icon(
                              onPressed: () async {
                                await _saveProgress();
                                _loadNextLevel();
                              },
                              icon: const Icon(Icons.arrow_forward),
                              label: const Text('Next'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF7B8EF7),
                                foregroundColor: Colors.white,
                                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                                elevation: 5,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}

// Custom painter for fireworks effect
class FireworksPainter extends CustomPainter {
  final Color color;
  final int particleCount;
  final double progress;
  
  FireworksPainter({
    required this.color,
    required this.particleCount,
    required this.progress,
  });
  
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke;
    
    for (int i = 0; i < particleCount; i++) {
      final angle = (i / particleCount) * 2 * pi;
      final distance = 50.0 * progress;
      final endPoint = Offset(
        center.dx + cos(angle) * distance,
        center.dy + sin(angle) * distance,
      );
      
      canvas.drawLine(center, endPoint, paint);
      
      // Draw particle at the end of each line
      final particlePaint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;
      
      canvas.drawCircle(
        endPoint,
        3 * (1 - progress),
        particlePaint,
      );
    }
  }
  
  @override
  bool shouldRepaint(FireworksPainter oldDelegate) {
    return oldDelegate.progress != progress;
  }
} 