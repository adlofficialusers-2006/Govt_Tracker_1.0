import 'package:geolocator/geolocator.dart';
import './trip_model.dart';
import '../storage/local_db.dart';

class TripDetectionModule {
  final LocalDB db = LocalDB();

  bool tripActive = false;
  Position? lastPosition;
  double distanceTravelled = 0;

  DateTime? startCandidateTime;
  DateTime? stopCandidateTime;
  Position? stopCenter;

  DateTime? tripStartTime;
  String startLocation = 'Unknown';
  String tripStatus = 'Idle';

  Function(Trip, int)? onTripCompleted;

  void processLocation(Position position) {
    final double speedKmph = position.speed * 3.6;
    final DateTime now = DateTime.now();

    if (lastPosition != null) {
      final double d = Geolocator.distanceBetween(
        lastPosition!.latitude,
        lastPosition!.longitude,
        position.latitude,
        position.longitude,
      );

      if (d > 5) {
        distanceTravelled += d;
      }
    }

    lastPosition = position;
    print('Speed: ${speedKmph.toStringAsFixed(2)} km/h');
    print('Distance: ${distanceTravelled.toStringAsFixed(1)} m');

    if (!tripActive && speedKmph > 8 && distanceTravelled > 100) {
      startCandidateTime ??= now;
      if (now.difference(startCandidateTime!).inSeconds >= 30) {
        tripActive = true;
        tripStartTime = now;
        startLocation = 'Lat: ${position.latitude}, Lng: ${position.longitude}';
        tripStatus = 'Trip Started';
        print('🚀 Trip STARTED');
      }
    } else {
      startCandidateTime = null;
    }

    if (!tripActive && speedKmph < 2) {
      distanceTravelled = 0;
      tripStatus = 'Idle';
    }

    if (tripActive && speedKmph < 1) {
      stopCandidateTime ??= now;
      stopCenter ??= position;

      final double stopDistance = Geolocator.distanceBetween(
        stopCenter!.latitude,
        stopCenter!.longitude,
        position.latitude,
        position.longitude,
      );

      if (stopDistance > 30) {
        stopCandidateTime = null;
        stopCenter = null;
      }
      if (tripStartTime == null) return;

      if (stopCandidateTime != null &&
          now.difference(stopCandidateTime!).inMinutes >= 2) {
        final DateTime tripEndTime = now;
        final Duration tripDuration = tripEndTime.difference(tripStartTime!);

        final String endLocation =
            'Lat: ${position.latitude}, Lng: ${position.longitude}';

        final Trip trip = Trip(
          startLocation: startLocation,
          endLocation: endLocation,
          distance: distanceTravelled,
          duration: tripDuration,
          startTime: tripStartTime!,
          endTime: tripEndTime,
        );

        print(trip);
        final int tripKey = db.saveTrip(trip);
        tripStatus = 'Trip Completed';

        if (onTripCompleted != null) {
          onTripCompleted!(trip, tripKey);
        }

        print('🛑 Trip ENDED');
        tripActive = false;
        distanceTravelled = 0;
        stopCandidateTime = null;
        stopCenter = null;
        tripStartTime = null;
      } else {
        tripStatus = 'Trip Ongoing';
      }
    } else if (tripActive) {
      tripStatus = 'Trip Ongoing';
    }
  }
} 