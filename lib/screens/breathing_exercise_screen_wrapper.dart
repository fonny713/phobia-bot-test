import 'dart:async';
import 'package:flutter/material.dart';
import 'breathing_exercise_screen.dart';

class BreathingExerciseScreenWrapper extends StatefulWidget {
  final VoidCallback onDone;
  final bool isFromExposure; // Określa, czy użytkownik przyszedł z ekspozycji

  const BreathingExerciseScreenWrapper({
    super.key,
    required this.onDone,
    required this.isFromExposure,
  });

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
    return Scaffold(
      body: Stack(
        children: [
          BreathingExerciseScreen(onDone: widget.onDone),
          
          // Przycisk "Pomiń" pojawia się tylko, jeśli użytkownik przyszedł z ekspozycji
          if (widget.isFromExposure)
            Positioned(
              top: 100, // Umieszczamy przycisk bliżej dolnej krawędzi
              right: 20,
              child: ElevatedButton(
                onPressed: () {
                  _timer?.cancel(); // Cancel automatic transition
                  widget.onDone();  // Przejdź od razu
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  elevation: 5,
                  shadowColor: Colors.black26,
                ),
                child: const Text(
                  "Pomiń",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
