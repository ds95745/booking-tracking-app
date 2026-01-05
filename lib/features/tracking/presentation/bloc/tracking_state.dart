import 'package:equatable/equatable.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

abstract class TrackingState extends Equatable {
  const TrackingState();

  @override
  List<Object> get props => [];
}

class TrackingInitial extends TrackingState {}

class TrackingActive extends TrackingState {
  final LatLng currentLocation;
  final LatLng pickupLocation;
  final LatLng dropLocation;
  final List<LatLng> routePoints;

  const TrackingActive({
    required this.currentLocation,
    required this.pickupLocation,
    required this.dropLocation,
    required this.routePoints,
  });

  @override
  List<Object> get props => [
        currentLocation,
        pickupLocation,
        dropLocation,
        routePoints,
      ];
}

class TrackingStopped extends TrackingState {}

