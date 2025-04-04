import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'theme_provider.dart';
import 'screens/home_screen.dart';
import 'widgets/fade_transition_switcher.dart'; // Importujemy nasz widget
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart' as firebase_options;
import 'screens/registration_screen.dart';
import 'screens/login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'screens/breathing_screen.dart';
import 'screens/phobia_list_screen.dart';
import 'screens/exposure_difficulty_screen.dart';
import 'screens/exposure_therapy_screen.dart';
import 'services/firebase_storage_service.dart';

// Global variable to track Firebase initialization status
bool _firebaseInitialized = false;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase with error handling
  try {
    print('Starting Firebase initialization...');
    await Firebase.initializeApp(
      options: firebase_options.DefaultFirebaseOptions.currentPlatform,
    );
    print('Firebase core initialized successfully');
    
    // Configure Firebase Storage to retry failed operations
    print('Configuring Firebase Storage retry settings...');
    FirebaseStorage.instance.setMaxOperationRetryTime(const Duration(seconds: 5));
    FirebaseStorage.instance.setMaxUploadRetryTime(const Duration(seconds: 5));
    FirebaseStorage.instance.setMaxDownloadRetryTime(const Duration(seconds: 5));
    print('Firebase Storage retry settings configured');
    
    // Try to sign in anonymously if no user is signed in
    if (FirebaseAuth.instance.currentUser == null) {
      try {
        print('No user signed in, attempting anonymous sign-in...');
        await FirebaseAuth.instance.signInAnonymously();
        print('Anonymous sign-in successful');
      } catch (e) {
        print('Anonymous sign-in failed: $e');
        // Continue anyway, as some operations might work without auth
      }
    } else {
      print('User already signed in: ${FirebaseAuth.instance.currentUser!.uid}');
    }
    
    _firebaseInitialized = true;
    print('Firebase initialized successfully');
  } catch (e) {
    print('Error initializing Firebase: $e');
    print('Stack trace: ${StackTrace.current}');
    _firebaseInitialized = false;
  }
  
  // Initialize FirebaseStorageService with error handling
  if (_firebaseInitialized) {
    try {
      print('Initializing FirebaseStorageService...');
      await FirebaseStorageService.initialize();
      print('FirebaseStorageService initialized successfully');
    } catch (e) {
      print('Error initializing FirebaseStorageService: $e');
      print('Stack trace: ${StackTrace.current}');
    }
  } else {
    print('Skipping FirebaseStorageService initialization due to Firebase initialization failure');
  }
  
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
        home: _firebaseInitialized 
          ? StreamBuilder<User?>(
              stream: FirebaseAuth.instance.authStateChanges(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                
                if (snapshot.hasData) {
                  return FadeTransitionSwitcher(
                    child: const HomeScreen(key: ValueKey('homeScreen')),
                  );
                }
                
                return FadeTransitionSwitcher(
                  child: const LoginScreen(key: ValueKey('loginScreen')),
                );
              },
            )
          : const HomeScreen(), // Fallback to HomeScreen if Firebase isn't initialized
        initialRoute: '/',
        routes: {
          '/breathing': (context) => const BreathingScreen(),
          '/phobia_list': (context) => const PhobiaListScreen(),
          '/exposure_difficulty': (context) {
            final args = ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
            return ExposureDifficultyScreen(
              phobiaId: args['phobiaId'],
              phobiaName: args['phobiaName'],
            );
          },
        },
      ),
    );
  }
}
