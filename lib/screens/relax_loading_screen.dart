import 'dart:async';
import 'package:flutter/material.dart';
import 'breathing_exercise_screen.dart';

class RelaxLoadingScreen extends StatefulWidget {
  const RelaxLoadingScreen({super.key});

  @override
  State<RelaxLoadingScreen> createState() => _RelaxLoadingScreenState();
}

class _RelaxLoadingScreenState extends State<RelaxLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _progressAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    )..forward();

    _progressAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.easeInOut),
    );

    _controller.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        Navigator.of(context).pushReplacement(
          PageRouteBuilder(
            transitionDuration: const Duration(milliseconds: 600),
            pageBuilder: (_, __, ___) => BreathingExerciseScreen(
              onDone: () {
                // Co ma się stać po zakończeniu ćwiczenia oddechowego?
                Navigator.of(context).pop(); // lub inna logika
              },
            ),

            transitionsBuilder: (_, animation, __, child) {
              final offsetAnimation = Tween<Offset>(
                begin: const Offset(0, 0.1),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOut),
              );

              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: offsetAnimation,
                  child: child,
                ),
              );
            },
          ),
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue.shade50,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32),
          child: AnimatedBuilder(
            animation: _progressAnimation,
            builder: (context, child) {
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Ładowanie relaksu...",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                  ),
                  const SizedBox(height: 24),
                  Container(
                    height: 16,
                    decoration: BoxDecoration(
                      color: Colors.blue.shade100.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Stack(
                      children: [
                        FractionallySizedBox(
                          widthFactor: _progressAnimation.value,
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFF81D4FA), Color(0xFF0288D1)],
                                begin: Alignment.centerLeft,
                                end: Alignment.centerRight,
                              ),
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.lightBlueAccent.withOpacity(0.6),
                                  blurRadius: 10,
                                  spreadRadius: 1,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
