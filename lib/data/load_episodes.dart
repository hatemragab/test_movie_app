import 'dart:convert';

import 'package:http/http.dart' as http;

import '../moduels/movie.dart';

Future<List<Movie>> loadEpisodes({http.Client? client}) async {
  final uri = Uri.https('api.tvmaze.com', '/shows/1/episodes');
  final response = await (client?.get(uri) ?? http.get(uri));
  if (response.statusCode != 200) {
    throw http.ClientException(
      'Episode request failed (${response.statusCode}).',
      uri,
    );
  }
  final data = jsonDecode(response.body);
  if (data is! List) throw const FormatException('Expected an episode list.');
  return data
      .map((value) {
        if (value is! Map<String, dynamic>)
          throw const FormatException('Expected an episode object.');
        return Movie.fromJson(value);
      })
      .toList(growable: false);
}
