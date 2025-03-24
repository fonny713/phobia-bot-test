import 'dart:async';
import 'package:flutter/material.dart';
import 'breathing_exercise_screen.dart';

class BreathingExerciseScreenWrapper extends StatefulWidget {
  final VoidCallback onDone;

  const BreathingExerciseScreenWrapper({Key? key, required this.onDone}) : super(key: key);

  @override
  State<BreathingExerciseScreenWrapper> createState() => _BreathingExerciseScreenWrapperState();
}

class _BreathingExerciseScreenWrapperState extends State<BreathingExerciseScreenWrapper> {
  Timer? _timer;

  @override
  void initState() {
    super.initState();
    _timer = Timer(const Duration(seconds: 12), () {
      widget.onDone();
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        // 👇 USUNIĘTO `const`, żeby móc przekazać onDone
        BreathingExerciseScreen(onDone: widget.onDone),
        Positioned(
          top: 40,
          right: 20,
          child: TextButton(
            onPressed: () {
              _timer?.cancel(); // Anuluj automatyczne przejście
              widget.onDone();  // Przejdź natychmiast
            },
            child: const Text(
              "",
              style: TextStyle(
                color: Colors.white,
                fontSize: 16,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
