import 'package:flutter/material.dart';
import '../models/phobia.dart';
import '../services/phobia_service.dart';
import 'course_intro_screen.dart';

class PhobiaListScreen extends StatelessWidget {
  const PhobiaListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Exposure Therapy'),
        backgroundColor: const Color(0xFF7B8EF7),
      ),
      body: FutureBuilder<List<Phobia>>(
        future: PhobiaService.getPhobias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No phobias available'));
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final phobia = snapshot.data![index];
              return PhobiaCard(phobia: phobia);
            },
          );
        },
      ),
    );
  }
}

class PhobiaCard extends StatelessWidget {
  final Phobia phobia;

  const PhobiaCard({super.key, required this.phobia});

  void _showDifficultyDialog(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
      ),
      builder: (BuildContext bc) {
        return Padding(
          padding: const EdgeInsets.all(25.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Choose Difficulty for ${phobia.name}',
                style: const TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFF7B8EF7),
                ),
              ),
              const SizedBox(height: 20),
              _buildStyledDifficultyButton(context, 'Easy', Colors.green),
              const SizedBox(height: 12),
              _buildStyledDifficultyButton(context, 'Medium', Colors.orange),
              const SizedBox(height: 12),
              _buildStyledDifficultyButton(context, 'Hard', Colors.red),
              const SizedBox(height: 20),
              Center(
                child: TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text(
                    'Cancel',
                    style: TextStyle(color: Colors.grey),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStyledDifficultyButton(BuildContext context, String level, Color color) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: color.withOpacity(0.9),
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          elevation: 3,
        ),
        onPressed: () {
          Navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => CourseIntroScreen(
                phobia: phobia,
                difficulty: level.toLowerCase(),
              ),
            ),
          );
        },
        child: Text(
          level,
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: InkWell(
        onTap: () => _showDifficultyDialog(context),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(16)),
              child: Image.network(
                phobia.imageUrl,
                height: 200,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    height: 200,
                    color: Colors.grey[300],
                    child: const Icon(Icons.error),
                  );
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          phobia.name,
                          style: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          phobia.description,
                          style: TextStyle(
                            color: Colors.grey[600],
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      phobia.isFavorite ? Icons.favorite : Icons.favorite_border,
                      color: phobia.isFavorite ? Colors.red : Colors.grey,
                    ),
                    onPressed: () async {
                      await PhobiaService.toggleFavorite(phobia);
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
} 