class Movie {
  const Movie({
    required this.id,
    required this.url,
    required this.name,
    required this.airdate,
    required this.image,
    required this.summary,
  });

  final int id;
  final String url;
  final String name;
  final String airdate;
  final String image;
  final String summary;

  factory Movie.fromJson(Map<String, dynamic> json) {
    final id = json['id'];
    if (id is! int)
      throw const FormatException('Episode id must be an integer.');
    String text(Object? value, String key) {
      if (value == null) return '';
      if (value is! String) throw FormatException('Episode $key must be text.');
      return value;
    }

    final image = json['image'];
    if (image != null && image is! Map<String, dynamic>) {
      throw const FormatException('Episode image must be an object or null.');
    }
    return Movie(
      id: id,
      url: text(json['url'], 'url'),
      name: text(json['name'], 'name'),
      airdate: text(json['airdate'], 'airdate'),
      image: image is Map<String, dynamic>
          ? text(image['medium'], 'image.medium')
          : '',
      summary: text(json['summary'], 'summary'),
    );
  }
}
