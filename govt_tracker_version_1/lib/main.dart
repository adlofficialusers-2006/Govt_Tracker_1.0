import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:provider/provider.dart';

import 'core/theme/app_theme.dart';
import 'modules/location/location_tracking_module.dart';
import 'modules/trip/trip_detection_module.dart';
import 'modules/trip/trip_detection_provider.dart';
import 'ui/screens/consent_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  await Hive.openBox('trips');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => TripDetectionProvider(
            locationModule: LocationTrackingModule(),
            detectionModule: TripDetectionModule(),
          ),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Travel Tracker',
        theme: AppTheme.dark,
        home: const ConsentScreen(),
      ),
    );
  }
}
