import 'package:flutter/material.dart';
import '../../modules/location/location_tracking_module.dart';
import '../../modules/trip/trip_detection_module.dart';
import 'trip_list_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

  final LocationTrackingModule locationModule = LocationTrackingModule();
  final TripDetectionModule tripModule = TripDetectionModule();

  String status = "Starting...";

  @override
  void initState() {
    super.initState();
    startTracking();
  }

  void startTracking() async {

    var stream = await locationModule.startTracking();

    if (stream == null) {
      setState(() {
        status = "Permission denied";
      });
      return;
    }

    setState(() {
      status = "Tracking...";
    });

    stream.listen((position) {

      tripModule.processLocation(position);

      setState(() {
        status =
            "Lat: ${position.latitude}\nLng: ${position.longitude}";
      });

    });
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(title: const Text("NATPAC Tracker")),

      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            Text(status, textAlign: TextAlign.center),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const TripListScreen(),
                  ),
                );
              },
              child: const Text("View Trips"),
            ),
          ],
        ),
      ),
    );
  }
}