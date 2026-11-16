import 'dart:async';

import 'package:flutter_test/flutter_test.dart';
import 'package:material_ui/material_ui.dart';
import 'package:movie_app/moduels/movie.dart';
import 'package:movie_app/screens/movie_screen.dart';

void main() {
  testWidgets('missing images render a fallback after loading', (tester) async {
    final response = Completer<List<Movie>>();
    await tester.pumpWidget(
      MaterialApp(home: MovieScreen(loadMovies: () => response.future)),
    );
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    response.complete([
      Movie.fromJson({'id': 1, 'name': 'Pilot', 'image': null}),
    ]);
    await tester.pumpAndSettle();
    expect(find.text('Pilot'), findsOneWidget);
    expect(find.byIcon(Icons.movie_outlined), findsOneWidget);
    await tester.tap(find.byIcon(Icons.swap_horiz));
    await tester.pumpAndSettle();
    expect(find.text('Pilot'), findsOneWidget);
    expect(tester.takeException(), isNull);
  });
  testWidgets('failed episode requests show a visible error', (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: MovieScreen(
          loadMovies: () async => throw const FormatException('Bad response'),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(
      find.text('Unable to load episodes. Please try again later.'),
      findsOneWidget,
    );
    expect(tester.takeException(), isNull);
  });
}
