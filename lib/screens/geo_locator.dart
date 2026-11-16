import 'package:geolocator/geolocator.dart';
import 'package:material_ui/material_ui.dart';

class GeoLocator extends StatefulWidget {
  const GeoLocator({super.key});

  @override
  State<GeoLocator> createState() => _GeoLocatorState();
}

class _GeoLocatorState extends State<GeoLocator> {
  String loc = ' ----------';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(
              onPressed: startGetLocation,
              child: const Text('Get location'),
            ),
            Text(loc),
          ],
        ),
      ),
    );
  }

  Future<void> startGetLocation() async {
    try {
      if (!await Geolocator.isLocationServiceEnabled()) {
        if (mounted) setState(() => loc = 'Location services are disabled.');
        return;
      }
      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        if (mounted)
          setState(() => loc = 'Location permission was not granted.');
        return;
      }
      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );
      if (!mounted) return;
      setState(() {
        loc = 'lat is ${position.latitude} lang ${position.longitude}';
      });
    } on Exception {
      if (mounted) setState(() => loc = 'Unable to read the current location.');
    }
  }
}
