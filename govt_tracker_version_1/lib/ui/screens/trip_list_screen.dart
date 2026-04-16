import 'package:flutter/material.dart';
import '../../modules/storage/local_db.dart';
import 'package:hive_flutter/hive_flutter.dart'; 

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
      appBar: AppBar(title: const Text("Trip History")),
      body: ValueListenableBuilder(
      valueListenable: db.box.listenable(),
      builder: (context, box, _) {

        var trips = box.values.toList();

        if (trips.isEmpty) {
          return const Center(child: Text("No trips yet"));
        }

        return ListView.builder(
          itemCount: trips.length,
          itemBuilder: (context, index) {

            var trip = trips[index];

            return Card(
              margin: const EdgeInsets.all(10),
              child: ListTile(
                title: Text("Trip ${index + 1}"),
                subtitle: Text(
                  "Distance: ${trip['distance'].toStringAsFixed(1)} m\n"
                  "Duration: ${trip['duration']} sec",
                ),
              ),
            );
          },
        );
      },
    ),

      
    );
  }
}