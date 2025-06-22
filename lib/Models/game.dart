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
