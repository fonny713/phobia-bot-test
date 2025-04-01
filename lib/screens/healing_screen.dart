import 'package:flutter/material.dart';
import '../models/phobia.dart';
import 'therapy_screen.dart';

class HealingScreen extends StatelessWidget {
  final Phobia phobia;
  final String difficulty;

  const HealingScreen({
    super.key,
    required this.phobia,
    required this.difficulty,
  });

  String _getDescription() {
    switch (phobia.name.toLowerCase()) {
      case 'spiders':
        return 'Spiders are fascinating creatures that play an important role in our ecosystem. They help control insect populations and create beautiful webs. Most spiders are harmless to humans and prefer to avoid contact.';
      case 'heights':
        return 'Fear of heights is a common phobia that can be managed through gradual exposure. Remember that modern buildings and safety measures make high places much safer than they were in the past.';
      case 'flying':
        return 'Air travel is one of the safest modes of transportation. Modern aircraft are equipped with advanced safety features and are maintained to the highest standards. The sensation of flying can be enjoyable once you understand the science behind it.';
      case 'public speaking':
        return 'Public speaking is a skill that can be developed with practice. Remember that your audience wants you to succeed and is generally supportive. Focus on your message rather than your anxiety.';
      case 'dogs':
        return 'Dogs are known as man\'s best friend for a reason. Most dogs are friendly and well-trained. Understanding dog body language can help you feel more comfortable around them.';
      case 'snakes':
        return 'While some snakes are venomous, most are harmless and beneficial to the environment. Learning to identify different snake species can help reduce fear and increase understanding.';
      case 'clowns':
        return 'Clowns are performers who aim to entertain and bring joy. Their exaggerated features and behavior are designed to be funny, not scary. Understanding their role in entertainment can help reduce fear.';
      case 'germs':
        return 'While it\'s good to be hygienic, excessive fear of germs can interfere with daily life. Most germs are harmless, and our immune system is designed to protect us from harmful ones.';
      case 'water':
        return 'Water is essential for life and can be enjoyed safely. Learning about water safety and swimming techniques can help build confidence around water.';
      case 'darkness':
        return 'Darkness is a natural part of our daily cycle. It\'s important for rest and relaxation. Understanding that darkness doesn\'t change the safety of your environment can help reduce fear.';
      default:
        return 'Understanding your phobia is the first step towards overcoming it. Knowledge and gradual exposure can help you build confidence and reduce anxiety.';
    }
  }

  String _getImageUrl() {
    switch (phobia.name.toLowerCase()) {
      case 'spiders':
        return 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
      case 'heights':
        return 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
      case 'flying':
        return 'https://images.unsplash.com/photo-1436491865332-7a61a109cc05?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
      case 'public speaking':
        return 'https://images.unsplash.com/photo-1540575467063-178a50c2df87?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
      case 'dogs':
        return 'https://images.unsplash.com/photo-1517423440428-a5a00ad493e8?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
      case 'snakes':
        return 'https://images.unsplash.com/photo-1585110396000-c9ffd4e4b308?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
      case 'clowns':
        return 'https://images.unsplash.com/photo-1516450360452-9312f5e86fc7?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
      case 'germs':
        return 'https://images.unsplash.com/photo-1583337130417-3346a1be7dee?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
      case 'water':
        return 'https://images.unsplash.com/photo-1507525428034-b723cf961d3e?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
      case 'darkness':
        return 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
      default:
        return 'https://images.unsplash.com/photo-1519682337058-a94d519337bc?ixlib=rb-1.2.1&auto=format&fit=crop&w=800&q=80';
    }
  }

  Color _getDifficultyColor() {
    switch (difficulty) {
      case 'easy':
        return const Color(0xFF4CAF50);
      case 'medium':
        return const Color(0xFFFF9800);
      case 'hard':
        return const Color(0xFFf44336);
      default:
        return const Color(0xFF2196F3);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            backgroundColor: _getDifficultyColor(),
            flexibleSpace: FlexibleSpaceBar(
              background: Stack(
                fit: StackFit.expand,
                children: [
                  Image.network(
                    _getImageUrl(),
                    fit: BoxFit.cover,
                  ),
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          Colors.black.withOpacity(0.7),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              title: Text(
                phobia.name,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor().withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      difficulty.toUpperCase(),
                      style: TextStyle(
                        color: _getDifficultyColor(),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                  Text(
                    _getDescription(),
                    style: const TextStyle(
                      fontSize: 16,
                      height: 1.5,
                    ),
                  ),
                  const SizedBox(height: 30),
                  const Text(
                    'Tips for Overcoming Your Fear',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 15),
                  _buildTipCard(
                    'Understanding',
                    'Learn about your phobia and its triggers. Knowledge is power.',
                    Icons.lightbulb,
                  ),
                  _buildTipCard(
                    'Breathing',
                    'Practice deep breathing exercises when you feel anxious.',
                    Icons.air,
                  ),
                  _buildTipCard(
                    'Gradual Exposure',
                    'Start with small steps and gradually increase exposure.',
                    Icons.trending_up,
                  ),
                  _buildTipCard(
                    'Support',
                    'Share your journey with friends or a therapist.',
                    Icons.people,
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => TherapyScreen(
                            phobia: phobia,
                            difficulty: difficulty,
                          ),
                        ),
                      );
                    },
                    child: const Text('Begin Healing Journey'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTipCard(String title, String description, IconData icon) {
    return Container(
      margin: const EdgeInsets.only(bottom: 15),
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 5,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: _getDifficultyColor().withOpacity(0.1),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: _getDifficultyColor(),
              size: 24,
            ),
          ),
          const SizedBox(width: 15),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 5),
                Text(
                  description,
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
} 