import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:confetti/confetti.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ExposureScreen extends StatefulWidget {
  final int difficulty;
  final int initialLevel;

  const ExposureScreen({
    super.key,
    required this.difficulty,
    required this.initialLevel,
  });

  @override
  State<ExposureScreen> createState() => _ExposureScreenState();
}

class _ExposureScreenState extends State<ExposureScreen>
    with SingleTickerProviderStateMixin {
  late int _currentLevel;
  late ConfettiController _confettiController;

  double _emotionValue = 5.0; // ⬅️ dodaj na górze klasy
  double _postEmotionValue = 5.0; // ⬅️ nowa zmienna do slidera po ekspozycji


  Future<void> _saveEmotionRating(int difficulty, int level, double value) async {
    final prefs = await SharedPreferences.getInstance();
    final key = 'emotion_difficulty_${difficulty}_level_${level}';
    await prefs.setDouble(key, value);
    print("Zapisano $key = ${value.toStringAsFixed(1)}");
  }


  final Map<int, Map<int, Map<String, String>>> _levelData = {
    1: {
      1: {'image': 'assets/images/cartoon_spider.jpg', 'fact': 'Pająki mają od 4 do 8 oczu.'},
      2: {'image': 'assets/images/cartoon_spider2.jpg', 'fact': 'Pajęczyna jest bardzo mocna.'},
      3: {'image': 'assets/images/cartoon_spider3.jpg', 'fact': 'Niektóre unoszą się na wietrze.'},
      4: {'image': 'assets/images/small_spider.jpg', 'fact': 'Większość nie jest groźna.'},
      5: {'image': 'assets/images/cartoon_spider_5.jpg', 'fact': 'Pomagają zwalczać owady.'},
    },
    2: {
      1: {'image': 'assets/images/real_spider_1.jpg', 'fact': 'Pająki mogą głodować wiele dni.'},
      2: {'image': 'assets/images/real_spider_2.jpg', 'fact': 'Pająki linieją przy wzroście.'},
      3: {'image': 'assets/images/real_spider_3.jpg', 'fact': 'Samice są większe od samców.'},
      4: {'image': 'assets/images/real_spider_4.jpg', 'fact': 'Są ważne w ekosystemie.'},
      5: {'image': 'assets/images/real_spider_5.jpg', 'fact': 'Ich jad działa głównie na owady.'},
    },
  };

  @override
  void initState() {
    super.initState();
    _currentLevel = widget.initialLevel;
    _confettiController = ConfettiController(duration: const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  void _nextLevel() {
    if (_currentLevel < 5) {
      setState(() => _currentLevel++);
      if (_currentLevel == 5) {
        Future.delayed(const Duration(milliseconds: 400), () {
          _confettiController.play();
          _showCompletionDialog();
        });
      }
    }
  }

  void _previousLevel() {
    if (_currentLevel > 1) {
      setState(() => _currentLevel--);
    }
  }

  Future<void> _showCompletionDialog() async {
    final prefs = await SharedPreferences.getInstance();
    final currentUnlocked = prefs.getInt('unlocked_level') ?? 1;

    // ✅ Umożliwiamy odblokowanie tylko kolejnego poziomu i tylko jeśli użytkownik ukończył aktualny najwyższy
    if (_currentLevel == 5 && widget.difficulty == currentUnlocked) {
      final nextLevel = widget.difficulty + 1;
      if (nextLevel <= 5) {
        print("✅ Odblokowano nowy poziom: $nextLevel");
      }
    } else {
      print("⛔ Warunek odblokowania nie został spełniony.");
    }

    _confettiController.play();

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => Stack(
        alignment: Alignment.topCenter,
        children: [
          Dialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 60),
                  const SizedBox(height: 16),
                  const Text("Gratulacje!", style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
                  const SizedBox(height: 12),
                  const Text("Ukończyłeś wszystkie poziomy w tym trybie.", textAlign: TextAlign.center),
                  const SizedBox(height: 24),

                  const Text("Jak się czujesz po ekspozycji?", style: TextStyle(fontSize: 16)),
                  StatefulBuilder(
                    builder: (context, setState) {
                      return Column(
                        children: [
                          Slider(
                            value: _postEmotionValue,
                            min: 0,
                            max: 10,
                            divisions: 10,
                            label: _postEmotionValue.round().toString(),
                            onChanged: (value) {
                              setState(() => _postEmotionValue = value);
                            },
                          ),
                          Text("Poziom lęku: ${_postEmotionValue.round()}", style: const TextStyle(fontSize: 14)),
                        ],
                      );
                    },
                  ),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      ElevatedButton.icon(
                        onPressed: () {
                          _saveEmotionRating(widget.difficulty, _currentLevel, _postEmotionValue);
                          Navigator.of(context).pop(); // zamyka dialog
                          setState(() => _currentLevel = 1); // restartuje poziom
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text("Od nowa"),
                      ),
                      ElevatedButton.icon(
                        onPressed: () {
                          _saveEmotionRating(widget.difficulty, _currentLevel, _postEmotionValue);
                          Navigator.of(context).pop(); // zamyka dialog
                          Navigator.of(context).pop(true); // wraca do menu
                        },
                        icon: const Icon(Icons.home),
                        label: const Text("Menu"),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Positioned(
            top: 0,
            child: ConfettiWidget(
              confettiController: _confettiController,
              blastDirectionality: BlastDirectionality.explosive,
              numberOfParticles: 20,
              shouldLoop: false,
              emissionFrequency: 0.05,
              maxBlastForce: 20,
              minBlastForce: 5,
              gravity: 0.3,
              colors: const [Colors.blue, Colors.green, Colors.orange, Colors.pink],
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final image = _levelData[widget.difficulty]?[_currentLevel]?['image'] ?? '';
    final fact = _levelData[widget.difficulty]?[_currentLevel]?['fact'] ?? '';

    return Scaffold(
      appBar: AppBar(title: Text("Ekspozycja - Trudność ${widget.difficulty}")),
      body: Column(
        children: [
          const SizedBox(height: 16),
          Text("Poziom $_currentLevel", style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
          const SizedBox(height: 8),
          Text("Ukończono ${(20 + 20 * (_currentLevel - 1)).round()}%", style: const TextStyle(fontSize: 16)),
          const SizedBox(height: 8),
          LinearProgressIndicator(
            value: (0.2 + 0.2 * (_currentLevel - 1)),
            minHeight: 6,
            backgroundColor: Colors.grey.shade300,
            color: Colors.blueAccent,
          ),
          const SizedBox(height: 16),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24),
              child: AnimatedSwitcher(
                duration: const Duration(milliseconds: 500),
                transitionBuilder: (child, animation) => FadeTransition(
                  opacity: animation,
                  child: SlideTransition(position: Tween(begin: const Offset(0.3, 0), end: Offset.zero).animate(animation), child: child),
                ),
                child: Container(
                  key: ValueKey(image),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(color: Colors.black12, blurRadius: 10, offset: const Offset(0, 4)),
                    ],
                  ),
                  padding: const EdgeInsets.all(12),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.asset(image, fit: BoxFit.contain),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 12),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 400),
            transitionBuilder: (child, animation) => FadeTransition(
              opacity: animation,
              child: SlideTransition(position: Tween(begin: const Offset(0.2, 0), end: Offset.zero).animate(animation), child: child),
            ),
            child: Container(
              key: ValueKey(fact),
              margin: const EdgeInsets.symmetric(horizontal: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 8, offset: const Offset(0, 4))],
              ),
              child: Text(
                fact,
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
                textAlign: TextAlign.center,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _AnimatedGlassButton(
                onTap: _previousLevel,
                label: "Poprzedni poziom",
                icon: Icons.arrow_back,
              ),
              _AnimatedGlassButton(
                onTap: _nextLevel,
                label: "Następny poziom",
                icon: Icons.arrow_forward,
              ),
            ],
          ),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
}

class _AnimatedGlassButton extends StatefulWidget {
  final VoidCallback onTap;
  final String label;
  final IconData icon;

  const _AnimatedGlassButton({
    Key? key,
    required this.onTap,
    required this.label,
    required this.icon,
  }) : super(key: key);

  @override
  State<_AnimatedGlassButton> createState() => _AnimatedGlassButtonState();
}

class _AnimatedGlassButtonState extends State<_AnimatedGlassButton>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 100),
      lowerBound: 0.95,
      upperBound: 1.0,
    )..value = 1.0;

    _scaleAnimation = CurvedAnimation(parent: _controller, curve: Curves.easeInOut);
  }

  void _onTapDown(_) => _controller.reverse();
  void _onTapUp(_) => _controller.forward();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: (_) => _onTapUp(null),
      onTapCancel: () => _onTapUp(null),
      child: ScaleTransition(
        scale: _scaleAnimation,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
          decoration: BoxDecoration(
            color: const Color(0xFF8AA8FF),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.blueAccent.withOpacity(0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(widget.icon, color: Colors.white),
              const SizedBox(width: 8),
              Text(
                widget.label,
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
