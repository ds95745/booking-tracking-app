import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../../../../core/widgets/custom_button.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../domain/entities/booking.dart';
import '../../../tracking/presentation/pages/tracking_page.dart';

class BookingDetailsPage extends StatefulWidget {
  final String bookingId;

  const BookingDetailsPage({
    super.key,
    required this.bookingId,
  });

  @override
  State<BookingDetailsPage> createState() => _BookingDetailsPageState();
}

class _BookingDetailsPageState extends State<BookingDetailsPage> {
  Booking? _booking;

  @override
  void initState() {
    super.initState();
    _loadBooking();
  }

  void _loadBooking() {
    context.read<BookingBloc>().add(const GetBookingsRequested());
  }

  void _showStatusDialog() {
    if (_booking == null) return;

    final currentStatus = _booking!.status;
    final statuses = [
      AppConstants.statusPending,
      AppConstants.statusAccepted,
      AppConstants.statusOnTheWay,
      AppConstants.statusCompleted,
    ];

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text(AppStrings.changeStatus),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: statuses.map((status) {
            return RadioListTile<String>(
              title: Text(status),
              value: status,
              groupValue: currentStatus,
              onChanged: (value) {
                if (value != null && value != currentStatus) {
                  context.read<BookingBloc>().add(
                        UpdateBookingStatusRequested(
                          bookingId: widget.bookingId,
                          status: value,
                        ),
                      );
                  Navigator.pop(context);
                }
              },
            );
          }).toList(),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bookingDetails),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingLoaded) {
            try {
              final booking = state.bookings.firstWhere(
                (b) => b.id == widget.bookingId,
              );
              setState(() {
                _booking = booking;
              });
            } catch (e) {
              // Booking not found in the list
              if (_booking == null) {
                // Only show error if we don't have a cached booking
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Booking not found'),
                    backgroundColor: AppColors.error,
                  ),
                );
              }
            }
          } else if (state is BookingStatusUpdated) {
            setState(() {
              _booking = state.booking;
            });
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Status updated successfully'),
                backgroundColor: AppColors.success,
              ),
            );
          }
        },
        builder: (context, state) {
          if (state is BookingLoading && _booking == null) {
            return const LoadingWidget();
          }

          if (state is BookingError && _booking == null) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: _loadBooking,
            );
          }

          if (_booking == null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons.error_outline,
                    size: 64,
                    color: AppColors.error,
                  ),
                  const SizedBox(height: 16),
                  const Text(
                    'Booking not found',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Booking ID: ${widget.bookingId}',
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 24),
                  CustomButton(
                    text: 'Retry',
                    onPressed: _loadBooking,
                    width: 150,
                  ),
                ],
              ),
            );
          }

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Map Preview
                SizedBox(
                  height: 200,
                  child: GoogleMap(
                    initialCameraPosition: CameraPosition(
                      target: LatLng(
                        _booking!.pickupLatitude,
                        _booking!.pickupLongitude,
                      ),
                      zoom: 12,
                    ),
                    markers: {
                      Marker(
                        markerId: const MarkerId('pickup'),
                        position: LatLng(
                          _booking!.pickupLatitude,
                          _booking!.pickupLongitude,
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueGreen,
                        ),
                      ),
                      Marker(
                        markerId: const MarkerId('drop'),
                        position: LatLng(
                          _booking!.dropLatitude,
                          _booking!.dropLongitude,
                        ),
                        icon: BitmapDescriptor.defaultMarkerWithHue(
                          BitmapDescriptor.hueRed,
                        ),
                      ),
                    },
                    polylines: {
                      Polyline(
                        polylineId: const PolylineId('route'),
                        points: [
                          LatLng(
                            _booking!.pickupLatitude,
                            _booking!.pickupLongitude,
                          ),
                          LatLng(
                            _booking!.dropLatitude,
                            _booking!.dropLongitude,
                          ),
                        ],
                        color: AppColors.primary,
                        width: 3,
                      ),
                    },
                  ),
                ),

                // Details
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Status
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            AppStrings.status,
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          StatusChip(status: _booking!.status),
                        ],
                      ),
                      const SizedBox(height: 24),

                      // Pickup Location
                      _buildDetailSection(
                        icon: Icons.location_on,
                        title: AppStrings.pickupLocation,
                        value: _booking!.pickupLocation,
                        color: AppColors.success,
                      ),
                      const SizedBox(height: 16),

                      // Drop Location
                      _buildDetailSection(
                        icon: Icons.location_off,
                        title: AppStrings.dropLocation,
                        value: _booking!.dropLocation,
                        color: AppColors.error,
                      ),
                      const SizedBox(height: 16),

                      // Date & Time
                      _buildDetailSection(
                        icon: Icons.calendar_today,
                        title: AppStrings.dateTime,
                        value: DateFormatter.formatDateTime(_booking!.dateTime),
                        color: AppColors.primary,
                      ),
                      const SizedBox(height: 16),

                      // Notes
                      if (_booking!.notes != null && _booking!.notes!.isNotEmpty)
                        _buildDetailSection(
                          icon: Icons.note,
                          title: AppStrings.notes,
                          value: _booking!.notes!,
                          color: AppColors.textSecondary,
                        ),

                      const SizedBox(height: 16),

                      // Change Status Button
                      CustomButton(
                        text: AppStrings.changeStatus,
                        onPressed: _showStatusDialog,
                        isOutlined: true,
                      ),
                      const SizedBox(height: 12),

                      // Start Tracking Button
                      CustomButton(
                        text: AppStrings.startTracking,
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => TrackingPage(
                                pickupLocation: LatLng(
                                  _booking!.pickupLatitude,
                                  _booking!.pickupLongitude,
                                ),
                                dropLocation: LatLng(
                                  _booking!.dropLatitude,
                                  _booking!.dropLongitude,
                                ),
                                pickupAddress: _booking!.pickupLocation,
                                dropAddress: _booking!.dropLocation,
                              ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildDetailSection({
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: color.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, color: color, size: 24),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  fontSize: 12,
                  color: AppColors.textSecondary,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

