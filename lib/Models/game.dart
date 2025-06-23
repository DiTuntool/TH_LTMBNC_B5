class Game {
  final int id;
  final String title;
  final String thumbnail;
  final String shortDescription;

  Game({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.shortDescription,
  });

  factory Game.fromJson(Map<String, dynamic> json) {
    return Game(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      thumbnail: json['thumbnail'] != null
          ? 'https://cors-anywhere.herokuapp.com/${json['thumbnail']}'
          : '',
      shortDescription: json['short_description'] ?? 'No Description',
    );
  }
}

class GameDetail {
  final int id;
  final String title;
  final String thumbnail;
  final String description; // Giữ nguyên dữ liệu HTML
  final String gameUrl;
  final String genre;
  final String platform;
  final String publisher;
  final String developer;
  final String releaseDate;

  GameDetail({
    required this.id,
    required this.title,
    required this.thumbnail,
    required this.description,
    required this.gameUrl,
    required this.genre,
    required this.platform,
    required this.publisher,
    required this.developer,
    required this.releaseDate,
  });

  factory GameDetail.fromJson(Map<String, dynamic> json) {
    return GameDetail(
      id: json['id'] ?? 0,
      title: json['title'] ?? 'No Title',
      thumbnail: json['thumbnail'] != null
          ? 'https://cors-anywhere.herokuapp.com/${json['thumbnail']}'
          : '',
      description: json['description'] ?? 'No Description', // Giữ HTML
      gameUrl: json['game_url'] ?? '',
      genre: json['genre'] ?? 'Unknown',
      platform: json['platform'] ?? 'Unknown',
      publisher: json['publisher'] ?? 'Unknown',
      developer: json['developer'] ?? 'Unknown',
      releaseDate: json['release_date'] ?? 'Unknown',
    );
  }
}
