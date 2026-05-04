import '../storage/local_db.dart';

class TripService {
  final LocalDB db = LocalDB();

  Future<List<Map<String, dynamic>>> fetchAllTrips() async {
    return db.getTripsWithKeys();
  }

  Future<List<Map<String, dynamic>>> fetchPendingTrips() async {
    final trips = db.getTripsWithKeys();
    return trips.where((trip) => trip['synced'] != true).toList();
  }

  Future<void> syncTrips() async {
    final pending = await fetchPendingTrips();
    if (pending.isEmpty) return;

    await Future.delayed(const Duration(seconds: 1));
    for (final trip in pending) {
      if (trip.containsKey('key')) {
        db.markAsSynced(trip['key'] as int);
      }
    }
  }
}
