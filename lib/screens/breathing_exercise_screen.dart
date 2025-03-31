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

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String get _breathingText => _isBreathingIn ? "Wdech..." : "Wydech...";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Ćwiczenie oddechowe"),
        actions: widget.isFromExposure ? [
          TextButton(
            onPressed: () {
              widget.onDone();
            },
            child: const Text("Pomiń"),
          ),
        ] : null,
      ),
      backgroundColor: Colors.white,
      body: Center(
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                // ANIMOWANE KOŁO
                Container(
                  width: _circleAnimation.value,
                  height: _circleAnimation.value,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      colors: [Color(0xFF6EC6FF), Color(0xFF0069C0)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.blue.withOpacity(0.4),
                        blurRadius: 20,
                        spreadRadius: 5,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 30),

                // ANIMOWANY TEKST POD KOŁEM
                Text(
                  _breathingText,
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w200,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 40),

                const Text(
                  "Oddychaj spokojnie...",
                  style: TextStyle(
                    fontSize: 18,
                    fontStyle: FontStyle.italic,
                    color: Colors.grey,
                  ),
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
