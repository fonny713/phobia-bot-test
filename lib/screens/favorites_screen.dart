import 'package:flutter/material.dart';
import '../models/phobia.dart';
import '../services/phobia_service.dart';

class FavoritesScreen extends StatefulWidget {
  const FavoritesScreen({super.key});

  @override
  State<FavoritesScreen> createState() => _FavoritesScreenState();
}

class _FavoritesScreenState extends State<FavoritesScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: const Color(0xFF7B8EF7),
      ),
      body: FutureBuilder<List<Phobia>>(
        future: PhobiaService.getFavoritePhobias(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No favorite phobias yet.\nAdd some from the list!',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: snapshot.data!.length,
            itemBuilder: (context, index) {
              final phobia = snapshot.data![index];
              return Card(
                margin: const EdgeInsets.only(bottom: 16),
                child: ListTile(
                  leading: const Icon(Icons.psychology),
                  title: Text(phobia.name),
                  subtitle: Text(phobia.description),
                  trailing: IconButton(
                    icon: const Icon(Icons.favorite, color: Colors.red),
                    onPressed: () async {
                      await PhobiaService.toggleFavorite(phobia);
                      setState(() {}); // Refresh the list
                    },
                  ),
                  onTap: () {
                    // TODO: Navigate to phobia details
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
} 