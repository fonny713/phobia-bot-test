import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import '../models/phobia.dart';

class PhobiaService {
  static const String _favoritesKey = 'favorites';
  static final List<Phobia> _defaultPhobias = [
    Phobia(
      id: '1',
      name: 'Arachnophobia',
      description: 'Fear of spiders and other arachnids',
      imageUrl: 'https://images.unsplash.com/photo-1567535969536-2b35f89c3d14',
      therapySteps: [
        'Look at pictures of spiders',
        'Watch videos of spiders',
        'Be in the same room as a spider in a container',
        'Get closer to a contained spider',
        'Be in the same room as a free spider',
      ],
    ),
    Phobia(
      id: '2',
      name: 'Acrophobia',
      description: 'Fear of heights',
      imageUrl: 'https://images.unsplash.com/photo-1465447142348-e9952c393450',
      therapySteps: [
        'Look at pictures of high places',
        'Watch videos taken from high places',
        'Stand on a low balcony or platform',
        'Gradually increase height exposure',
        'Visit observation decks with safety barriers',
      ],
    ),
    Phobia(
      id: '3',
      name: 'Claustrophobia',
      description: 'Fear of confined spaces',
      imageUrl: 'https://images.unsplash.com/photo-1516962080544-eac695c93791',
      therapySteps: [
        'Start with larger enclosed spaces',
        'Practice in elevators with others',
        'Spend time in smaller rooms',
        'Use relaxation techniques in confined spaces',
        'Gradually reduce space size',
      ],
    ),
    Phobia(
      id: '4',
      name: 'Cynophobia',
      description: 'Fear of dogs',
      imageUrl: 'https://images.unsplash.com/photo-1543466835-00a7907e9de1',
      therapySteps: [
        'Look at pictures of friendly dogs',
        'Watch videos of puppies',
        'Observe dogs from a safe distance',
        'Be in the same room as a calm dog',
        'Gradually get closer to friendly dogs',
      ],
    ),
    Phobia(
      id: '5',
      name: 'Aviophobia',
      description: 'Fear of flying',
      imageUrl: 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      therapySteps: [
        'Learn about aviation safety',
        'View airport environments',
        'Look at aircraft pictures',
        'Understand flight procedures',
        'Practice relaxation techniques',
      ],
    ),
    Phobia(
      id: '6',
      name: 'Glossophobia',
      description: 'Fear of public speaking',
      imageUrl: 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80',
      therapySteps: [
        'Practice in front of a mirror',
        'Speak to small groups',
        'Learn breathing techniques',
        'Visualize successful presentations',
        'Gradually increase audience size',
      ],
    ),
  ];

  static Future<List<Phobia>> getPhobias() async {
    final prefs = await SharedPreferences.getInstance();
    final phobiasJson = prefs.getString('phobias');
    
    if (phobiasJson == null) {
      // First time: save default phobias
      await _savePhobias(_defaultPhobias);
      return _defaultPhobias;
    }

    try {
      final List<dynamic> decoded = json.decode(phobiasJson);
      return decoded.map((json) => Phobia.fromJson(json)).toList();
    } catch (e) {
      return _defaultPhobias;
    }
  }

  static Future<List<Phobia>> getFavoritePhobias() async {
    final phobias = await getPhobias();
    return phobias.where((phobia) => phobia.isFavorite).toList();
  }

  static Future<void> toggleFavorite(Phobia phobia) async {
    final phobias = await getPhobias();
    final index = phobias.indexWhere((p) => p.id == phobia.id);
    if (index != -1) {
      phobias[index].isFavorite = !phobias[index].isFavorite;
      await _savePhobias(phobias);
    }
  }

  static Future<List<Phobia>> getCompletedPhobias() async {
    final prefs = await SharedPreferences.getInstance();
    final allPhobias = await getPhobias();
    final completedPhobias = <Phobia>[];

    for (var phobia in allPhobias) {
      if (await isPhobiaCompleted(phobia.name)) {
        completedPhobias.add(phobia);
      }
    }

    return completedPhobias;
  }

  static Future<void> markPhobiaAsCompleted(String phobiaId) async {
    final prefs = await SharedPreferences.getInstance();
    final completedIds = prefs.getStringList('completed_phobias') ?? [];
    if (!completedIds.contains(phobiaId)) {
      completedIds.add(phobiaId);
      await prefs.setStringList('completed_phobias', completedIds);
      
      // Update completed courses count
      final completedCourses = prefs.getInt('completed_courses') ?? 0;
      await prefs.setInt('completed_courses', completedCourses + 1);
    }
  }

  static Future<void> _savePhobias(List<Phobia> phobias) async {
    final prefs = await SharedPreferences.getInstance();
    final phobiasJson = json.encode(phobias.map((p) => p.toJson()).toList());
    await prefs.setString('phobias', phobiasJson);
  }

  static Future<List<String>> getFavoriteIds() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_favoritesKey) ?? [];
  }

  static Future<bool> isFavorite(String phobiaId) async {
    final favorites = await getFavoriteIds();
    return favorites.contains(phobiaId);
  }

  static Future<List<String>> getCompletedDifficulties(String phobiaName) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getStringList('completed_difficulties_$phobiaName') ?? [];
  }

  static Future<void> markDifficultyCompleted(String phobiaName, String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    final completedDifficulties = prefs.getStringList('completed_difficulties_$phobiaName') ?? [];
    if (!completedDifficulties.contains(difficulty)) {
      completedDifficulties.add(difficulty);
      await prefs.setStringList('completed_difficulties_$phobiaName', completedDifficulties);
      
      // Update completed courses count
      final completedCourses = prefs.getInt('completed_courses') ?? 0;
      await prefs.setInt('completed_courses', completedCourses + 1);
    }
  }

  static Future<bool> isDifficultyCompleted(String phobiaName, String difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    final completedDifficulties = prefs.getStringList('completed_difficulties_$phobiaName') ?? [];
    return completedDifficulties.contains(difficulty);
  }

  static Future<bool> isPhobiaCompleted(String phobiaName) async {
    final prefs = await SharedPreferences.getInstance();
    final completedDifficulties = prefs.getStringList('completed_difficulties_$phobiaName') ?? [];
    return completedDifficulties.length == 3; // All three difficulties completed
  }
} 