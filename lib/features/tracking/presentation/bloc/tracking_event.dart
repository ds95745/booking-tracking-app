import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TrackingEvent extends Equatable {
  const TrackingEvent();

  @override
  List<Object> get props => [];
}

class StartTracking extends TrackingEvent {
  final LatLng pickupLocation;
  final LatLng dropLocation;

  const StartTracking({
    required this.pickupLocation,
    required this.dropLocation,
  });

  @override
  List<Object> get props => [pickupLocation, dropLocation];
}

class StopTracking extends TrackingEvent {
  const StopTracking();
}

class UpdateLocation extends TrackingEvent {
  final LatLng currentLocation;

  const UpdateLocation(this.currentLocation);

  @override
  List<Object> get props => [currentLocation];
}

