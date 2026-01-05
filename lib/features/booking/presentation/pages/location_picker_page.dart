import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geocoding/geocoding.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/loading_widget.dart';

class LocationPickerPage extends StatefulWidget {
  final String title;

  const LocationPickerPage({
    super.key,
    required this.title,
  });

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  GoogleMapController? _mapController;
  LatLng _selectedLocation = const LatLng(
    AppConstants.defaultLatitude,
    AppConstants.defaultLongitude,
  );
  String? _selectedAddress;
  bool _isLoadingAddress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _selectedLocation,
              zoom: AppConstants.defaultZoom,
            ),
            onMapCreated: (controller) {
              _mapController = controller;
            },
            onTap: (LatLng location) {
              setState(() {
                _selectedLocation = location;
                _selectedAddress = null;
                _isLoadingAddress = true;
              });
              _getAddressFromCoordinates(location);
            },
            markers: {
              Marker(
                markerId: const MarkerId('selected_location'),
                position: _selectedLocation,
                draggable: true,
                onDragEnd: (LatLng newPosition) {
                  setState(() {
                    _selectedLocation = newPosition;
                    _selectedAddress = null;
                    _isLoadingAddress = true;
                  });
                  _getAddressFromCoordinates(newPosition);
                },
              ),
            },
            myLocationButtonEnabled: true,
            myLocationEnabled: true,
          ),
          // Center indicator
          const Center(
            child: Icon(
              Icons.location_on,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          // Bottom sheet with address and confirm button
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: const BorderRadius.vertical(
                  top: Radius.circular(20),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.1),
                    blurRadius: 10,
                    offset: const Offset(0, -2),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    'Selected Location',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  _isLoadingAddress
                      ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(
                              AppColors.primary,
                            ),
                          ),
                        )
                      : Text(
                          _selectedAddress ?? 'Tap on map to select location',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                  const SizedBox(height: 16),
                  CustomButton(
                    text: 'Confirm Location',
                    onPressed: () {
                      Navigator.pop(context, {
                        'location': _selectedLocation,
                        'address': _selectedAddress,
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getAddressFromCoordinates(LatLng location) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        location.latitude,
        location.longitude,
      );

      if (placemarks.isNotEmpty) {
        final place = placemarks[0];
        final addressParts = <String>[];
        
        if (place.street != null && place.street!.isNotEmpty) {
          addressParts.add(place.street!);
        }
        if (place.subLocality != null && place.subLocality!.isNotEmpty) {
          addressParts.add(place.subLocality!);
        }
        if (place.locality != null && place.locality!.isNotEmpty) {
          addressParts.add(place.locality!);
        }
        if (place.administrativeArea != null && place.administrativeArea!.isNotEmpty) {
          addressParts.add(place.administrativeArea!);
        }
        if (place.country != null && place.country!.isNotEmpty) {
          addressParts.add(place.country!);
        }

        final address = addressParts.isNotEmpty
            ? addressParts.join(', ')
            : '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';

        if (mounted) {
          setState(() {
            _selectedAddress = address;
            _isLoadingAddress = false;
          });
        }
      } else {
        if (mounted) {
          setState(() {
            _selectedAddress = '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
            _isLoadingAddress = false;
          });
        }
      }
    } catch (e) {
      // If geocoding fails, show coordinates
      if (mounted) {
        setState(() {
          _selectedAddress = '${location.latitude.toStringAsFixed(6)}, ${location.longitude.toStringAsFixed(6)}';
          _isLoadingAddress = false;
        });
      }
    }
  }

  @override
  void initState() {
    super.initState();
    // Get address for initial location
    _getAddressFromCoordinates(_selectedLocation);
  }

  @override
  void dispose() {
    _mapController?.dispose();
    super.dispose();
  }
}

