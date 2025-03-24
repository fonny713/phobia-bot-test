import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:phobia_app/theme_provider.dart';
import 'package:phobia_app/screens/relax_screen.dart';
import 'exposure_screen.dart';
import 'journal_screen.dart';
import 'info_screen.dart';
import 'exposure_levels_screen.dart';
import 'exposure_levels_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

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
        child: ElevatedButton.icon(
          style: ElevatedButton.styleFrom(
            foregroundColor: Colors.white,
            backgroundColor: const Color(0xFFC6E1FD),
            minimumSize: const Size.fromHeight(60),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
          ),
          icon: Icon(icon, size: 24, color: Colors.white),
          label: Text(text, style: const TextStyle(fontSize: 18)),
          onPressed: () => Navigator.push(
            context,
            MaterialPageRoute(builder: (_) => screen),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor ?? Theme.of(context).primaryColor,
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
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildMenuButton("Ekspozycja", Icons.bug_report, const ExposureLevelsScreen()),
              _buildMenuButton("Dziennik", Icons.book, JournalScreen()),
              _buildMenuButton("Relaks", Icons.self_improvement, const RelaxScreen()),
              _buildMenuButton("Info", Icons.info_outline, const InfoScreen()),
            ],
          ),
        ),
      ),
    );
  }
}
