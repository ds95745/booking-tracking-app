import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:intl/intl.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/widgets/custom_button.dart';
import '../../../../core/widgets/custom_text_field.dart';
import '../../../../core/utils/validators.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import '../../domain/entities/booking.dart';
import 'location_picker_page.dart';

class CreateBookingPage extends StatefulWidget {
  const CreateBookingPage({super.key});

  @override
  State<CreateBookingPage> createState() => _CreateBookingPageState();
}

class _CreateBookingPageState extends State<CreateBookingPage> {
  final _formKey = GlobalKey<FormState>();
  final _notesController = TextEditingController();
  DateTime? _selectedDateTime;
  LatLng? _pickupLocation;
  LatLng? _dropLocation;
  String? _pickupAddress;
  String? _dropAddress;

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _selectDateTime() async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (pickedDate != null) {
      final TimeOfDay? pickedTime = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.now(),
      );

      if (pickedTime != null) {
        setState(() {
          _selectedDateTime = DateTime(
            pickedDate.year,
            pickedDate.month,
            pickedDate.day,
            pickedTime.hour,
            pickedTime.minute,
          );
        });
      }
    }
  }

  Future<void> _selectPickupLocation() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationPickerPage(
          title: AppStrings.selectPickup,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _pickupLocation = result['location'] as LatLng;
        _pickupAddress = result['address'] as String?;
      });
    }
  }

  Future<void> _selectDropLocation() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(
        builder: (context) => const LocationPickerPage(
          title: AppStrings.selectDrop,
        ),
      ),
    );

    if (result != null) {
      setState(() {
        _dropLocation = result['location'] as LatLng;
        _dropAddress = result['address'] as String?;
      });
    }
  }

  void _handleSubmit() {
    if (_formKey.currentState!.validate()) {
      if (_pickupLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select pickup location'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (_dropLocation == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select drop location'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      if (_selectedDateTime == null) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select date and time'),
            backgroundColor: AppColors.error,
          ),
        );
        return;
      }

      final booking = Booking(
        id: '',
        pickupLocation: _pickupAddress ?? 'Pickup Location',
        pickupLatitude: _pickupLocation!.latitude,
        pickupLongitude: _pickupLocation!.longitude,
        dropLocation: _dropAddress ?? 'Drop Location',
        dropLatitude: _dropLocation!.latitude,
        dropLongitude: _dropLocation!.longitude,
        dateTime: _selectedDateTime!,
        notes: _notesController.text.trim().isEmpty
            ? null
            : _notesController.text.trim(),
        status: AppConstants.statusPending,
        createdAt: DateTime.now(),
      );

      context.read<BookingBloc>().add(CreateBookingRequested(booking));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.createBooking),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
      ),
      body: BlocConsumer<BookingBloc, BookingState>(
        listener: (context, state) {
          if (state is BookingCreated) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text(AppStrings.bookingCreated),
                backgroundColor: AppColors.success,
              ),
            );
            Navigator.pop(context, true);
          } else if (state is BookingError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: AppColors.error,
              ),
            );
          }
        },
        builder: (context, state) {
          final isLoading = state is BookingLoading;

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  // Pickup Location
                  _buildLocationCard(
                    title: AppStrings.pickupLocation,
                    address: _pickupAddress,
                    onTap: _selectPickupLocation,
                    icon: Icons.location_on,
                  ),
                  const SizedBox(height: 16),

                  // Drop Location
                  _buildLocationCard(
                    title: AppStrings.dropLocation,
                    address: _dropAddress,
                    onTap: _selectDropLocation,
                    icon: Icons.location_off,
                  ),
                  const SizedBox(height: 16),

                  // Date & Time
                  _buildDateTimeCard(),
                  const SizedBox(height: 16),

                  // Notes
                  CustomTextField(
                    label: AppStrings.notes,
                    hint: AppStrings.notesHint,
                    controller: _notesController,
                    maxLines: 4,
                  ),
                  const SizedBox(height: 32),

                  // Submit Button
                  CustomButton(
                    text: AppStrings.createBooking,
                    onPressed: isLoading ? null : _handleSubmit,
                    isLoading: isLoading,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildLocationCard({
    required String title,
    required String? address,
    required VoidCallback onTap,
    required IconData icon,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              Icon(icon, color: AppColors.primary, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      address ?? 'Tap to select location',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: address != null
                            ? AppColors.textPrimary
                            : AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDateTimeCard() {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      child: InkWell(
        onTap: _selectDateTime,
        borderRadius: BorderRadius.circular(8),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Row(
            children: [
              const Icon(Icons.calendar_today, color: AppColors.primary, size: 24),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      AppStrings.dateTime,
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _selectedDateTime != null
                          ? DateFormat('MMM dd, yyyy • HH:mm')
                              .format(_selectedDateTime!)
                          : 'Tap to select date & time',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: _selectedDateTime != null
                            ? AppColors.textPrimary
                            : AppColors.textDisabled,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(Icons.chevron_right, color: AppColors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}

