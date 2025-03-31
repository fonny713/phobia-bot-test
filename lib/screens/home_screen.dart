import 'dart:ui'; // potrzebne do BackdropFilter
import 'package:flutter/material.dart';
import 'package:phobia_app/screens/exposure_loading_screen.dart';
import 'package:provider/provider.dart';
import 'package:phobia_app/theme_provider.dart';
import 'journal_screen.dart';
import 'info_screen.dart';
import 'relax_loading_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeInOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildMenuButton(String text, IconData icon, Widget screen) {
    return FadeTransition(
      opacity: _fadeAnimation,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: ElevatedButton.icon(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white.withOpacity(0.15),
                foregroundColor: Colors.white,
                minimumSize: const Size.fromHeight(60),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                elevation: 0,
              ),
              icon: Icon(icon, size: 24, color: Colors.white),
              label: Text(text, style: const TextStyle(fontSize: 18, color: Colors.white)),
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => screen),
              ),
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    final gradientColors = isDarkMode
        ? [const Color(0xFF4DA2E8), const Color(0xFF2575FC)]
        : [const Color(0xFFB3CCF4), const Color(0xFFCFDEF3)];

    return Scaffold(
      backgroundColor: Colors.transparent,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          "Menu",
          style: TextStyle(
            fontSize: 26,
            fontWeight: FontWeight.bold,
            color: Colors.white,
            fontFamily: 'Montserrat',
          ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: IconButton(
              icon: Icon(
                isDarkMode ? Icons.light_mode : Icons.dark_mode,
                color: Colors.white,
              ),
              onPressed: () {
                themeProvider.toggleTheme();
              },
            ),
          ),
        ],
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: gradientColors,
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.fromLTRB(15.0, 100.0, 15.0, 15.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _buildMenuButton("Ekspozycja", Icons.bug_report, const ExposureLoadingScreen()),
                _buildMenuButton("Dziennik", Icons.book, JournalScreen()),
                _buildMenuButton("Relaks", Icons.self_improvement, const RelaxLoadingScreen(isFromExposure: false)),
                _buildMenuButton("Info", Icons.info_outline, const InfoScreen()),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
