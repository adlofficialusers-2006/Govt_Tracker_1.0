class Trip {
  final String startLocation;
  final String endLocation;
  final double distance; // meters
  final Duration duration;
  final DateTime startTime;
  final DateTime endTime;

  Trip({
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.duration,
    required this.startTime,
    required this.endTime,
  });

  @override
  String toString() {
    return '''
Trip:
Start: $startLocation
End: $endLocation
Distance: ${distance.toStringAsFixed(1)} m
Duration: ${duration.inSeconds} sec
''';
  }
}