import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../modules/storage/local_db.dart';
import '../../ui/widgets/glass_card.dart';
import 'trip_detail_screen.dart';

class TripListScreen extends StatefulWidget {
  const TripListScreen({super.key});

  @override
  State<TripListScreen> createState() => _TripListScreenState();
}

class _TripListScreenState extends State<TripListScreen> {
  final LocalDB db = LocalDB();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text('Trip History'),
        elevation: 0,
      ),
      body: ValueListenableBuilder(
        valueListenable: db.box.listenable(),
        builder: (context, box, _) {
          final trips = db.getTripsWithKeys();

          if (trips.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: const [
                  Icon(Icons.directions_car_filled, size: 72, color: Colors.white24),
                  SizedBox(height: 18),
                  Text('No trips recorded yet.', style: TextStyle(color: Colors.white70, fontSize: 18)),
                  SizedBox(height: 8),
                  Text('Start moving to detect and save your first trip.', textAlign: TextAlign.center, style: TextStyle(color: Colors.white54, fontSize: 15)),
                ],
              ),
            );
          }

          return ListView.separated(
            padding: const EdgeInsets.all(20),
            separatorBuilder: (_, __) => const SizedBox(height: 16),
            itemCount: trips.length,
            itemBuilder: (context, index) {
              final trip = trips[index];
              final int key = trip['key'] as int;
              final double distance = trip['distance'] is num ? (trip['distance'] as num).toDouble() : 0.0;
              final int duration = trip['duration'] is int ? trip['duration'] as int : 0;

              return GlassCard(
                child: ListTile(
                  contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 16),
                  title: Text('Trip ${index + 1}', style: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text('Distance: ${distance.toStringAsFixed(1)} m', style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      Text('Duration: ${(duration / 60).toStringAsFixed(1)} min', style: const TextStyle(color: Colors.white70)),
                      const SizedBox(height: 6),
                      Text('Mode: ${trip['mode'] ?? 'Unknown'}', style: const TextStyle(color: AppColors.neonBlue)),
                    ],
                  ),
                  trailing: const Icon(Icons.arrow_forward_ios, color: AppColors.neonBlue),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (_) => TripDetailScreen(trip: trip)));
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}
