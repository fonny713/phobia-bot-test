import 'package:flutter/material.dart';
import 'relax_loading_screen.dart';

class RelaxScreen extends StatelessWidget {
  const RelaxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (_) => const RelaxLoadingScreen()),
      );
    });

    return const Scaffold(
      body: Center(child: CircularProgressIndicator()), // tymczasowe
    );
  }
}
