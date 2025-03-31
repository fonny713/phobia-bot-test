import 'package:flutter/material.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("O aplikacji"),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color(0xFFB3CCF4), // Kolor górny (ciemnoniebieski)
              Color(0xFFCFDEF3), // Kolor dolny (fioletowy)
            ],
          ),
        ),
        child: Center( // Centrowanie całej zawartości
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisSize: MainAxisSize.min, // Minimalna wysokość, żeby było na środku
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        blurRadius: 10,
                        spreadRadius: 2,
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      const Icon(Icons.info_outline, size: 50, color: Colors.white),
                      const SizedBox(height: 10),
                      const Text(
                        "PhobiaApp - Twój przewodnik w przezwyciężaniu lęków.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 18, color: Colors.white),
                      ),
                      const SizedBox(height: 10),
                      const Text(
                        "Aplikacja wspiera użytkowników w stopniowej ekspozycji na fobie, pomagając w ich przezwyciężaniu metodą poznawczą.",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 16, color: Colors.white70),
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        "Wersja aplikacji: 1.0.0",
                        style: TextStyle(fontSize: 14, color: Colors.white54),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 40),
                const Text(
                  "\"Największa odwaga to przezwyciężenie własnych lęków.\"",
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 16, fontStyle: FontStyle.italic, color: Colors.white70),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
