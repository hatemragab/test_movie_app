import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';

class GeoLocator extends StatefulWidget {
  @override
  _GeoLocatorState createState() => _GeoLocatorState();
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
            RaisedButton(onPressed: () {
              startGetLocation();
            }),
            Text("$loc")
          ],
        ),
      ),
    );
  }
  void startGetLocation() async {
    LocationPermission permissionReq = await requestPermission();
    Position position =
        await getCurrentPosition(desiredAccuracy: LocationAccuracy.high);
    setState(() {
      loc = "lat is  ${position.latitude} lang ${position.latitude}";
    });
  }
}
