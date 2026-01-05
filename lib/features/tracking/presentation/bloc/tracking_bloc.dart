import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'tracking_event.dart';
import 'tracking_state.dart';

class TrackingBloc extends Bloc<TrackingEvent, TrackingState> {
  Timer? _trackingTimer;
  int _stepIndex = 0;

  TrackingBloc() : super(TrackingInitial()) {
    on<StartTracking>(_onStartTracking);
    on<StopTracking>(_onStopTracking);
    on<UpdateLocation>(_onUpdateLocation);
  }

  void _onStartTracking(
    StartTracking event,
    Emitter<TrackingState> emit,
  ) {
    // Generate route points between pickup and drop
    final routePoints = _generateRoutePoints(
      event.pickupLocation,
      event.dropLocation,
    );

    emit(TrackingActive(
      currentLocation: event.pickupLocation,
      pickupLocation: event.pickupLocation,
      dropLocation: event.dropLocation,
      routePoints: routePoints,
    ));

    _stepIndex = 0;
    _startSimulation(routePoints, emit);
  }

  void _onStopTracking(
    StopTracking event,
    Emitter<TrackingState> emit,
  ) {
    _trackingTimer?.cancel();
    _trackingTimer = null;
    emit(TrackingStopped());
  }

  void _onUpdateLocation(
    UpdateLocation event,
    Emitter<TrackingState> emit,
  ) {
    if (state is TrackingActive) {
      final currentState = state as TrackingActive;
      emit(TrackingActive(
        currentLocation: event.currentLocation,
        pickupLocation: currentState.pickupLocation,
        dropLocation: currentState.dropLocation,
        routePoints: currentState.routePoints,
      ));
    }
  }

  List<LatLng> _generateRoutePoints(LatLng start, LatLng end) {
    final points = <LatLng>[];
    const steps = 50; // Number of intermediate points

    for (int i = 0; i <= steps; i++) {
      final ratio = i / steps;
      final lat = start.latitude + (end.latitude - start.latitude) * ratio;
      final lng = start.longitude + (end.longitude - start.longitude) * ratio;
      // Add some randomness to simulate real road movement
      final randomOffset = (i % 3 - 1) * 0.0001;
      points.add(LatLng(lat + randomOffset, lng + randomOffset));
    }

    return points;
  }

  void _startSimulation(
    List<LatLng> routePoints,
    Emitter<TrackingState> emit,
  ) {
    _trackingTimer?.cancel();
    _trackingTimer = Timer.periodic(const Duration(seconds: 2), (timer) {
      if (_stepIndex < routePoints.length) {
        add(UpdateLocation(routePoints[_stepIndex]));
        _stepIndex++;
      } else {
        _trackingTimer?.cancel();
      }
    });
  }

  @override
  Future<void> close() {
    _trackingTimer?.cancel();
    return super.close();
  }
}

