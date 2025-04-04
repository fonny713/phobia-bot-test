import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import '../models/phobia.dart';
import '../services/phobia_service.dart';
import 'phobia_list_screen.dart';
import 'exposure_difficulty_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _username = 'User';
  String _profileImagePath = '';
  int _completedCourses = 0;
  int _streak = 0;
  List<Phobia> _completedPhobias = [];

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  Future<void> _loadUserData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _username = prefs.getString('username') ?? 'User';
      _profileImagePath = prefs.getString('profile_image') ?? '';
      _completedCourses = prefs.getInt('completed_courses') ?? 0;
      _streak = prefs.getInt('streak') ?? 0;
    });
    _loadCompletedPhobias();
  }

  Future<void> _loadCompletedPhobias() async {
    final completedPhobias = await PhobiaService.getCompletedPhobias();
    setState(() {
      _completedPhobias = completedPhobias;
    });
  }

  Future<void> _updateProfileImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    
    if (image != null) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('profile_image', image.path);
      setState(() {
        _profileImagePath = image.path;
      });
    }
  }

  Future<void> _updateUsername() async {
    final TextEditingController controller = TextEditingController(text: _username);
    
    final newUsername = await showDialog<String>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Update Username'),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: 'Enter new username',
            border: OutlineInputBorder(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, controller.text),
            child: const Text('Save'),
          ),
        ],
      ),
    );

    if (newUsername != null && newUsername.isNotEmpty) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('username', newUsername);
      setState(() {
        _username = newUsername;
      });
    }
  }

  String _getNextDifficulty(String currentDifficulty) {
    switch (currentDifficulty.toLowerCase()) {
      case 'easy':
        return 'medium';
      case 'medium':
        return 'hard';
      default:
        return 'easy';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 200,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  if (_profileImagePath.isNotEmpty)
                    Image.file(
                      File(_profileImagePath),
                      fit: BoxFit.cover,
                    )
                  else
                    Container(
                      color: Colors.grey[300],
                      child: const Icon(
                        Icons.person,
                        size: 100,
                        color: Colors.grey,
                      ),
                    ),
                  Positioned(
                    bottom: 16,
                    right: 16,
                    child: CircleAvatar(
                      backgroundColor: Colors.white,
                      child: IconButton(
                        icon: const Icon(Icons.camera_alt),
                        onPressed: _updateProfileImage,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          _username,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: _updateUsername,
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Your Progress',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: _buildProgressCard(
                          'Completed Courses',
                          _completedCourses.toString(),
                          Icons.check_circle,
                          Colors.green,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: _buildProgressCard(
                          'Current Streak',
                          '$_streak days',
                          Icons.local_fire_department,
                          Colors.orange,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),
                  const Text(
                    'Finished Courses',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 16),
                  FutureBuilder<List<Phobia>>(
                    future: PhobiaService.getCompletedPhobias(),
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(child: CircularProgressIndicator());
                      }

                      if (!snapshot.hasData || snapshot.data!.isEmpty) {
                        return const Center(
                          child: Text('No completed courses yet'),
                        );
                      }

                      return ListView.builder(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: snapshot.data!.length,
                        itemBuilder: (context, index) {
                          final phobia = snapshot.data![index];
                          return Card(
                            margin: const EdgeInsets.only(bottom: 16),
                            child: ListTile(
                              leading: ClipRRect(
                                borderRadius: BorderRadius.circular(8),
                                child: Image.network(
                                  phobia.imageUrl,
                                  width: 60,
                                  height: 60,
                                  fit: BoxFit.cover,
                                ),
                              ),
                              title: Text(phobia.name),
                              subtitle: Text(phobia.description),
                              trailing: FutureBuilder<List<String>>(
                                future: PhobiaService.getCompletedDifficulties(phobia.name),
                                builder: (context, difficultiesSnapshot) {
                                  if (!difficultiesSnapshot.hasData) {
                                    return const SizedBox.shrink();
                                  }

                                  final completedDifficulties = difficultiesSnapshot.data!;
                                  if (completedDifficulties.length == 3) {
                                    return const Icon(
                                      Icons.check_circle,
                                      color: Colors.green,
                                    );
                                  }

                                  final nextDifficulty = completedDifficulties.isEmpty
                                      ? 'easy'
                                      : _getNextDifficulty(completedDifficulties.last);

                                  return ElevatedButton(
                                    onPressed: () {
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => ExposureDifficultyScreen(
                                            phobiaId: phobia.id,
                                            phobiaName: phobia.name,
                                          ),
                                        ),
                                      );
                                    },
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: _getDifficultyColor(nextDifficulty),
                                      foregroundColor: Colors.white,
                                    ),
                                    child: Text(
                                      'Start ${nextDifficulty.toUpperCase()}',
                                    ),
                                  );
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProgressCard(
    String title,
    String value,
    IconData icon,
    Color color,
  ) {
    return Card(
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Icon(icon, size: 32, color: color),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              title,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Color _getDifficultyColor(String difficulty) {
    switch (difficulty.toLowerCase()) {
      case 'easy':
        return const Color(0xFF4CAF50); // Green
      case 'medium':
        return const Color(0xFFFF9800); // Orange
      case 'hard':
        return const Color(0xFFF44336); // Red
      default:
        return const Color(0xFF2196F3); // Blue
    }
  }
} 