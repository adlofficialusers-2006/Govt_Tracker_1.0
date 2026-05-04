class Trip {
  final String startLocation;
  final String endLocation;
  final double distance; // meters
  final Duration duration;
  final DateTime startTime;
  final DateTime endTime;
  String mode;
  String purpose;
  String cost;
  String companions;
  String frequency;

  Trip({
    required this.startLocation,
    required this.endLocation,
    required this.distance,
    required this.duration,
    required this.startTime,
    required this.endTime,
    this.mode = 'Unknown',
    this.purpose = 'Unknown',
    this.cost = '0',
    this.companions = '0',
    this.frequency = 'Unknown',
  });

  @override
  String toString() {
    return '''
Trip:
Start: $startLocation
End: $endLocation
Distance: ${distance.toStringAsFixed(1)} m
Duration: ${duration.inSeconds} sec
Mode: $mode
Purpose: $purpose
Cost: $cost
Companions: $companions
Frequency: $frequency
''';
  }
}