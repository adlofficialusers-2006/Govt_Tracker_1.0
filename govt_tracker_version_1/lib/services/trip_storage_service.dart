import 'package:hive/hive.dart';
import '../modules/trip/trip_model.dart';

class TripStorageService {

  final Box box = Hive.box('trips');

  void saveTrip(Trip trip) {
    box.add({
      'start': trip.startLocation,
      'end': trip.endLocation,
      'distance': trip.distance,
      'duration': trip.duration.inSeconds,
      'startTime': trip.startTime.toString(),
      'endTime': trip.endTime.toString(),
    });
  }

  List getTrips() {
    return box.values.toList();
  }
}