import 'package:material_ui/material_ui.dart';
import 'package:movie_app/screens/movie_screen.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: MovieScreen(), debugShowCheckedModeBanner: false);
  }
}
