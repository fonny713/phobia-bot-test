import 'package:flutter/material.dart';

class BreathingExerciseScreen extends StatefulWidget {
  final VoidCallback onDone;
  final bool isFromExposure;
  const BreathingExerciseScreen({
    super.key, 
    required this.onDone,
    this.isFromExposure = false,
  });

  @override
  State<BreathingExerciseScreen> createState() => _BreathingExerciseScreenState();
}

class _BreathingExerciseScreenState extends State<BreathingExerciseScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _circleAnimation;
  late Animation<double> _textSizeAnimation;
  late Animation<double> _opacityAnimation;
  late Animation<double> _scaleAnimation;
  bool _isBreathingIn = true;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 4),
      vsync: this,
    )..addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        setState(() => _isBreathingIn = false);
        _controller.reverse();
      } else if (status == AnimationStatus.dismissed) {
        setState(() => _isBreathingIn = true);
        _controller.forward();
      }
    });

    _circleAnimation = Tween<double>(begin: 100, end: 250).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _textSizeAnimation = Tween<double>(begin: 24, end: 32).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _opacityAnimation = Tween<double>(begin: 0.6, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.95, end: 1.05).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _breathingText => _isBreathingIn ? "Breathe In..." : "Breathe Out...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F7FA),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Breathing Exercise",
          style: TextStyle(
            color: Color(0xFF7B8EF7),
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: widget.isFromExposure ? [
          TextButton(
            onPressed: widget.onDone,
            child: const Text(
              "Skip",
              style: TextStyle(
                color: Color(0xFF7B8EF7),
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
        ] : null,
      ),
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // Breathing Circle with Multiple Animations
                Transform.scale(
                  scale: _scaleAnimation.value,
                  child: Container(
                    width: _circleAnimation.value,
                    height: _circleAnimation.value,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(
                        colors: [
                          const Color(0xFF7B8EF7).withOpacity(_opacityAnimation.value),
                          const Color(0xFF6E7FF3).withOpacity(_opacityAnimation.value),
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF7B8EF7).withOpacity(0.3),
                          blurRadius: 20,
                          spreadRadius: 5,
                          offset: const Offset(0, 10),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Animated Breathing Text
                AnimatedBuilder(
                  animation: _textSizeAnimation,
                  builder: (context, child) {
                    return Text(
                      _breathingText,
                      style: TextStyle(
                        fontSize: _textSizeAnimation.value,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF7B8EF7),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 20),

                // Breathing Instructions
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: const Text(
                    "Take slow, deep breaths",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.grey,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
                const SizedBox(height: 40),

                // Breathing Tips
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 32),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _buildTipCard(
                        Icons.timer,
                        "4 seconds",
                        "Inhale",
                      ),
                      _buildTipCard(
                        Icons.pause,
                        "4 seconds",
                        "Hold",
                      ),
                      _buildTipCard(
                        Icons.timer,
                        "4 seconds",
                        "Exhale",
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }

  Widget _buildTipCard(IconData icon, String duration, String action) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: const Color(0xFF7B8EF7),
            size: 24,
          ),
          const SizedBox(height: 8),
          Text(
            duration,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: Color(0xFF7B8EF7),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            action,
            style: const TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }
}
