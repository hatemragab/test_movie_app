import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:movie_app/data/load_episodes.dart';
import 'package:movie_app/moduels/movie.dart';

void main() {
  test('episode mapping accepts nullable artwork and rejects invalid ids', () {
    expect(Movie.fromJson({'id': 1, 'image': null}).image, isEmpty);
    expect(() => Movie.fromJson({'id': 'bad'}), throwsFormatException);
  });
  test('loader uses HTTPS and maps the response', () async {
    final client = MockClient((request) async {
      expect(request.url.toString(), 'https://api.tvmaze.com/shows/1/episodes');
      return http.Response('[{"id":1,"name":"Pilot","image":null}]', 200);
    });
    addTearDown(client.close);
    expect((await loadEpisodes(client: client)).single.name, 'Pilot');
  });
  test('loader reports HTTP failures and malformed payloads', () async {
    for (final body in ['{}', '[null]', '[{"id":"wrong"}]']) {
      final client = MockClient((_) async => http.Response(body, 200));
      addTearDown(client.close);
      await expectLater(loadEpisodes(client: client), throwsFormatException);
    }
    final client = MockClient((_) async => http.Response('Unavailable', 503));
    addTearDown(client.close);
    await expectLater(
      loadEpisodes(client: client),
      throwsA(isA<http.ClientException>()),
    );
  });
}
