import 'package:flutter/material.dart';
import 'modules/location/location_tracking_module.dart';
import 'package:geolocator/geolocator.dart';
import './modules/trip/trip_detection_module.dart';
import 'package:hive_flutter/hive_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Hive.initFlutter();

  await Hive.openBox('trips'); // our storage

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final TripDetectionModule tripModule = TripDetectionModule();
  final LocationTrackingModule locationModule = LocationTrackingModule();

  String locationText = "Waiting for location...";

  @override
  void initState() {
    super.initState();
    startTracking();
  }

  void startTracking() async {
    Stream<Position>? stream = await locationModule.startTracking();

    if (stream == null) {
      setState(() {
        locationText = "Permission denied";
      });
      return;
    }

    stream.listen((position) {
      setState(() {
        locationText =
            "Lat: ${position.latitude}\nLng: ${position.longitude}";
      });
      tripModule.processLocation(position);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(title: const Text("Travel Tracker")),
        body: Center(
          child: Text(
            locationText,
            style: const TextStyle(fontSize: 20),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}