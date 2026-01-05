import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../bloc/tracking_bloc.dart';
import '../bloc/tracking_event.dart';
import '../bloc/tracking_state.dart';

class TrackingPage extends StatefulWidget {
  final LatLng pickupLocation;
  final LatLng dropLocation;
  final String pickupAddress;
  final String dropAddress;

  const TrackingPage({
    super.key,
    required this.pickupLocation,
    required this.dropLocation,
    required this.pickupAddress,
    required this.dropAddress,
  });

  @override
  State<TrackingPage> createState() => _TrackingPageState();
}

class _TrackingPageState extends State<TrackingPage> {
  GoogleMapController? _mapController;
  bool _isTracking = false;

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }

  void _onMapCreated(GoogleMapController controller) {
    _mapController = controller;
  }

  void _updateCamera(LatLng location) {
    _mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(location, 15),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.liveTracking),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<TrackingBloc, TrackingState>(
        listener: (context, state) {
          if (state is TrackingActive) {
            _updateCamera(state.currentLocation);
          }
        },
        builder: (context, state) {
          return Stack(
            children: [
              GoogleMap(
                onMapCreated: _onMapCreated,
                initialCameraPosition: CameraPosition(
                  target: widget.pickupLocation,
                  zoom: AppConstants.defaultZoom,
                ),
                markers: _buildMarkers(state),
                polylines: _buildPolylines(state),
                myLocationButtonEnabled: false,
                myLocationEnabled: false,
                zoomControlsEnabled: false,
              ),
              // Info Card
              Positioned(
                top: 16,
                left: 16,
                right: 16,
                child: Card(
                  elevation: 4,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          children: [
                            Icon(
                              Icons.location_on,
                              color: AppColors.success,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.pickupAddress,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.location_off,
                              color: AppColors.error,
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                widget.dropAddress,
                                style: const TextStyle(
                                  fontSize: 14,
                                  fontWeight: FontWeight.w600,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // Control Button
              Positioned(
                bottom: 24,
                left: 16,
                right: 16,
                child: CustomButton(
                  text: state is TrackingActive
                      ? AppStrings.stopTracking
                      : AppStrings.startTracking,
                  onPressed: () {
                    if (state is TrackingActive) {
                      context.read<TrackingBloc>().add(const StopTracking());
                      setState(() {
                        _isTracking = false;
                      });
                    } else {
                      context.read<TrackingBloc>().add(
                            StartTracking(
                              pickupLocation: widget.pickupLocation,
                              dropLocation: widget.dropLocation,
                            ),
                          );
                      setState(() {
                        _isTracking = true;
                      });
                    }
                  },
                  backgroundColor: state is TrackingActive
                      ? AppColors.error
                      : AppColors.primary,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Set<Marker> _buildMarkers(TrackingState state) {
    final markers = <Marker>{};

    // Pickup marker
    markers.add(
      Marker(
        markerId: const MarkerId('pickup'),
        position: widget.pickupLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueGreen,
        ),
        infoWindow: InfoWindow(
          title: 'Pickup',
          snippet: widget.pickupAddress,
        ),
      ),
    );

    // Drop marker
    markers.add(
      Marker(
        markerId: const MarkerId('drop'),
        position: widget.dropLocation,
        icon: BitmapDescriptor.defaultMarkerWithHue(
          BitmapDescriptor.hueRed,
        ),
        infoWindow: InfoWindow(
          title: 'Drop',
          snippet: widget.dropAddress,
        ),
      ),
    );

    // Current location marker (if tracking is active)
    if (state is TrackingActive) {
      markers.add(
        Marker(
          markerId: const MarkerId('current'),
          position: state.currentLocation,
          icon: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueBlue,
          ),
          infoWindow: const InfoWindow(
            title: 'Current Location',
            snippet: 'Live tracking',
          ),
        ),
      );
    }

    return markers;
  }

  Set<Polyline> _buildPolylines(TrackingState state) {
    final polylines = <Polyline>{};

    if (state is TrackingActive) {
      // Route polyline
      final routePoints = [
        state.pickupLocation,
        ...state.routePoints,
        state.dropLocation,
      ];

      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: routePoints,
          color: AppColors.primary,
          width: 4,
          patterns: [],
        ),
      );

      // Traveled path polyline
      final traveledPoints = [
        state.pickupLocation,
        ...state.routePoints.takeWhile(
          (point) => point != state.currentLocation,
        ),
        state.currentLocation,
      ];

      if (traveledPoints.length > 1) {
        polylines.add(
          Polyline(
            polylineId: const PolylineId('traveled'),
            points: traveledPoints,
            color: AppColors.success,
            width: 4,
            patterns: [PatternItem.dash(10), PatternItem.gap(5)],
          ),
        );
      }
    } else {
      // Static route when not tracking
      polylines.add(
        Polyline(
          polylineId: const PolylineId('route'),
          points: [widget.pickupLocation, widget.dropLocation],
          color: AppColors.primary.withOpacity(0.5),
          width: 3,
        ),
      );
    }

    return polylines;
  }
}

