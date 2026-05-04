import 'dart:async';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../location/location_tracking_module.dart';
import 'trip_detection_module.dart';
import 'trip_model.dart';

class TripDetectionProvider extends ChangeNotifier {
  final LocationTrackingModule locationModule;
  final TripDetectionModule detectionModule;

  StreamSubscription<Position>? _positionSubscription;
  bool isTracking = false;
  bool permissionGranted = false;
  String statusLabel = 'Idle';
  String feedbackLabel = 'Ready to detect a new trip';
  Position? currentPosition;
  double currentDistance = 0;
  String permissionStatus = 'Location permission is required to detect trips automatically.';

  TripDetectionProvider({required this.locationModule, required this.detectionModule}) {
    detectionModule.onTripCompleted = _handleTripCompleted;
  }

  Future<bool> requestPermission() async {
    final granted = await locationModule.requestPermission();
    permissionGranted = granted;
    permissionStatus = granted
        ? 'Location tracking is enabled. The app will detect trips automatically.'
        : 'Location permission is denied. Grant access to start tracking.';
    notifyListeners();
    return granted;
  }

  Future<void> startTracking() async {
    if (!permissionGranted) {
      final granted = await requestPermission();
      if (!granted) {
        statusLabel = 'Permission denied';
        feedbackLabel = 'Please enable location permission in settings.';
        notifyListeners();
        return;
      }
    }

    final stream = await locationModule.startTracking();
    if (stream == null) {
      statusLabel = 'Permission denied';
      feedbackLabel = 'Unable to start location updates.';
      isTracking = false;
      notifyListeners();
      return;
    }

    isTracking = true;
    statusLabel = 'Tracking Active';
    feedbackLabel = 'Searching for your next trip…';
    notifyListeners();

    _positionSubscription = stream.listen((position) {
      currentPosition = position;
      currentDistance = detectionModule.distanceTravelled;
      _updateFeedback();
      notifyListeners();
      detectionModule.processLocation(position);
    });
  }

  void _updateFeedback() {
    if (detectionModule.tripStatus == 'Trip Completed') {
      feedbackLabel = 'Trip Completed';
      return;
    }
    if (detectionModule.tripActive) {
      feedbackLabel = detectionModule.tripStatus == 'Trip Started' ? 'Trip Started' : 'Trip Ongoing';
      return;
    }
    feedbackLabel = 'Waiting for movement to begin a trip';
  }

  void _handleTripCompleted(Trip trip, int key) {
    statusLabel = 'Trip Completed';
    feedbackLabel = 'Trip detected and saved. Please complete details.';
    notifyListeners();

    Future.delayed(const Duration(seconds: 4), () {
      if (!detectionModule.tripActive) {
        statusLabel = 'Tracking Active';
        feedbackLabel = 'Waiting for movement to begin a trip';
        notifyListeners();
      }
    });
  }

  String get formattedLatitude => currentPosition?.latitude.toStringAsFixed(5) ?? '--';
  String get formattedLongitude => currentPosition?.longitude.toStringAsFixed(5) ?? '--';

  @override
  void dispose() {
    _positionSubscription?.cancel();
    super.dispose();
  }
}
