import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import '../models/game.dart';
import '../services/api_service.dart';
import 'game_detail_screen.dart';

class GameListScreen extends StatefulWidget {
  const GameListScreen({super.key});

  @override
  _GameListScreenState createState() => _GameListScreenState();
}

class _GameListScreenState extends State<GameListScreen> {
  late Future<List<Game>> futureGames;
  final ApiService _apiService = ApiService();
  List<Game> allGames = [];
  List<Game> filteredGames = [];
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    futureGames = _apiService.fetchGames().then((games) {
      setState(() {
        allGames = games;
        filteredGames = games;
      });
      return games;
    });
    _searchController.addListener(_filterGames);
  }

  void _filterGames() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      filteredGames = allGames.where((game) {
        return game.title.toLowerCase().contains(query) ||
            game.shortDescription.toLowerCase().contains(query);
      }).toList();
    });
  }

  void _fetchGamesByPlatform(String platform) {
    setState(() {
      futureGames = _apiService.fetchGamesByPlatform(platform).then((games) {
        setState(() {
          allGames = games;
          filteredGames = games;
        });
        return games;
      });
    });
  }

  void _fetchGamesByCategory(String category) {
    setState(() {
      futureGames = _apiService.fetchGamesByCategory(category).then((games) {
        setState(() {
          allGames = games;
          filteredGames = games;
        });
        return games;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('MMO Games')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _searchController,
              decoration: const InputDecoration(
                labelText: 'Search Games',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () => _fetchGamesByPlatform('pc'),
                  child: const Text('Get PC Games'),
                ),
                ElevatedButton(
                  onPressed: () => _fetchGamesByCategory('shooter'),
                  child: const Text('Get Shooter Games'),
                ),
              ],
            ),
          ),
          Expanded(
            child: FutureBuilder<List<Game>>(
              future: futureGames,
              builder: (context, snapshot) {
                if (snapshot.hasData) {
                  return ListView.builder(
                    itemCount: filteredGames.length,
                    itemBuilder: (context, index) {
                      final game = filteredGames[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                          vertical: 8,
                          horizontal: 16,
                        ),
                        child: ListTile(
                          leading: CachedNetworkImage(
                            imageUrl: game.thumbnail,
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                            placeholder: (context, url) =>
                                const CircularProgressIndicator(),
                            errorWidget: (context, url, error) => Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                const Icon(Icons.error, color: Colors.red),
                                Text(
                                  'Failed to load: $url',
                                  style: const TextStyle(fontSize: 10),
                                ),
                              ],
                            ),
                          ),
                          title: Text(
                            game.title,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                            game.shortDescription,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    GameDetailScreen(gameId: game.id),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  );
                } else if (snapshot.hasError) {
                  return Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text('Error: ${snapshot.error}'),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              futureGames = _apiService.fetchGames();
                            });
                          },
                          child: const Text('Retry'),
                        ),
                      ],
                    ),
                  );
                }
                return const Center(child: CircularProgressIndicator());
              },
            ),
          ),
        ],
      ),
    );
  }
}
