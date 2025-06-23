import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_html/flutter_html.dart'; // Thêm import này
import '../models/game.dart';
import '../services/api_service.dart';

class GameDetailScreen extends StatefulWidget {
  final int gameId;

  const GameDetailScreen({super.key, required this.gameId});

  @override
  _GameDetailScreenState createState() => _GameDetailScreenState();
}

class _GameDetailScreenState extends State<GameDetailScreen> {
  late Future<GameDetail> futureGameDetail;
  final ApiService _apiService = ApiService();

  @override
  void initState() {
    super.initState();
    futureGameDetail = _apiService.fetchGameDetail(widget.gameId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Game Details')),
      body: FutureBuilder<GameDetail>(
        future: futureGameDetail,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final game = snapshot.data!;
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CachedNetworkImage(
                    imageUrl: game.thumbnail,
                    height: 200,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    game.title,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Genre: ${game.genre}'),
                  Text('Platform: ${game.platform}'),
                  Text('Publisher: ${game.publisher}'),
                  Text('Developer: ${game.developer}'),
                  Text('Release Date: ${game.releaseDate}'),
                  const SizedBox(height: 16),
                  Text(
                    'Description',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Html(data: game.description), // Sử dụng Html widget
                  const SizedBox(height: 16),
                  if (game.gameUrl.isNotEmpty)
                    ElevatedButton(
                      onPressed: () async {
                        if (await canLaunch(game.gameUrl)) {
                          await launch(game.gameUrl);
                        } else {
                          print('Could not launch ${game.gameUrl}');
                        }
                      },
                      child: const Text('Visit Game Website'),
                    ),
                ],
              ),
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
                        futureGameDetail = _apiService.fetchGameDetail(
                          widget.gameId,
                        );
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
    );
  }
}
