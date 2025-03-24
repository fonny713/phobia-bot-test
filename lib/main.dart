import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'screens/home_screen.dart';
import 'widgets/fade_transition_switcher.dart'; // Importujemy nasz widget

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<ThemeProvider>();
    final isDarkMode = themeProvider.themeMode == ThemeMode.dark;

    final ThemeData lightTheme = ThemeData(
      brightness: Brightness.light,
      fontFamily: 'Montserrat',
      primarySwatch: Colors.blue,
      scaffoldBackgroundColor: const Color(0xFFF5F5F5),
      appBarTheme: const AppBarTheme(
        backgroundColor: Color(0xFF8AA8FF),
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFFC6E1FD),
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );

    final ThemeData darkTheme = ThemeData(
      brightness: Brightness.dark,
      fontFamily: 'Montserrat',
      scaffoldBackgroundColor: const Color(0xFF121212),
      appBarTheme: const AppBarTheme(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        titleTextStyle: TextStyle(
          fontSize: 26,
          fontWeight: FontWeight.bold,
          fontFamily: 'Montserrat',
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueAccent,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
      ),
    );

    return AnimatedTheme(
      data: isDarkMode ? darkTheme : lightTheme,
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOut,
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        themeMode: themeProvider.themeMode,
        theme: lightTheme,
        darkTheme: darkTheme,
        home: const FadeTransitionSwitcher(
          child: HomeScreen(),
        ),
      ),
    );
  }
}
