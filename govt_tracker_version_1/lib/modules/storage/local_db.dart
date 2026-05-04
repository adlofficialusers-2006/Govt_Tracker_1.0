import 'package:hive/hive.dart';
import '../trip/trip_model.dart';

class LocalDB {
  final Box<dynamic> box = Hive.box('trips');

  int saveTrip(Trip trip) {
    return box.add({
      'start': trip.startLocation,
      'end': trip.endLocation,
      'distance': trip.distance,
      'duration': trip.duration.inSeconds,
      'startTime': trip.startTime.toString(),
      'endTime': trip.endTime.toString(),
      'mode': trip.mode,
      'purpose': trip.purpose,
      'cost': trip.cost,
      'companions': trip.companions,
      'frequency': trip.frequency,
      'synced': false,
    });
  }

  void updateTrip(int key, Map<String, dynamic> updates) {
    final trip = box.get(key);
    if (trip != null && trip is Map) {
      final updatedTrip = Map<String, dynamic>.from(trip);
      updatedTrip.addAll(updates);
      box.put(key, updatedTrip);
    }
  }

  void markAsSynced(int key) {
    final trip = box.get(key);
    if (trip != null && trip is Map) {
      final updatedTrip = Map<String, dynamic>.from(trip);
      updatedTrip['synced'] = true;
      box.put(key, updatedTrip);
    }
  }

  List getTrips() {
    return box.values.toList();
  }

  List<Map<String, dynamic>> getTripsWithKeys() {
    return box.keys.map((key) {
      final trip = box.get(key);
      if (trip is Map<String, dynamic>) {
        return {...trip, 'key': key as int};
      }
      return <String, dynamic>{};
    }).toList();
  }
}