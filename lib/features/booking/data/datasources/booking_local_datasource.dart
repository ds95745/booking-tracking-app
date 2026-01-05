import 'dart:convert';
import '../models/booking_model.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/constants/app_constants.dart';
import 'package:uuid/uuid.dart';

abstract class BookingLocalDataSource {
  Future<BookingModel> createBooking(BookingModel booking);
  Future<List<BookingModel>> getBookings();
  Future<List<BookingModel>> getBookingsByStatus(String status);
  Future<BookingModel> updateBookingStatus(String bookingId, String status);
  Future<BookingModel?> getBookingById(String bookingId);
}

class BookingLocalDataSourceImpl implements BookingLocalDataSource {
  final StorageService storageService;
  final Uuid uuid = const Uuid();

  BookingLocalDataSourceImpl(this.storageService);

  @override
  Future<BookingModel> createBooking(BookingModel booking) async {
    final bookings = await getBookings();
    final newBooking = BookingModel(
      id: booking.id.isEmpty ? uuid.v4() : booking.id,
      pickupLocation: booking.pickupLocation,
      pickupLatitude: booking.pickupLatitude,
      pickupLongitude: booking.pickupLongitude,
      dropLocation: booking.dropLocation,
      dropLatitude: booking.dropLatitude,
      dropLongitude: booking.dropLongitude,
      dateTime: booking.dateTime,
      notes: booking.notes,
      status: booking.status,
      createdAt: booking.createdAt,
    );

    bookings.add(newBooking);
    await _saveBookings(bookings);
    return newBooking;
  }

  @override
  Future<List<BookingModel>> getBookings() async {
    final bookingsJson = await storageService.getString(AppConstants.keyBookings);
    if (bookingsJson == null || bookingsJson.isEmpty) {
      return [];
    }

    try {
      final List<dynamic> jsonList = jsonDecode(bookingsJson);
      return jsonList
          .map((json) => BookingModel.fromJson(json as Map<String, dynamic>))
          .toList();
    } catch (e) {
      return [];
    }
  }

  @override
  Future<List<BookingModel>> getBookingsByStatus(String status) async {
    final bookings = await getBookings();
    return bookings.where((booking) => booking.status == status).toList();
  }

  @override
  Future<BookingModel> updateBookingStatus(
    String bookingId,
    String status,
  ) async {
    final bookings = await getBookings();
    final index = bookings.indexWhere((b) => b.id == bookingId);

    if (index == -1) {
      throw Exception('Booking not found');
    }

    final updatedBooking = BookingModel(
      id: bookings[index].id,
      pickupLocation: bookings[index].pickupLocation,
      pickupLatitude: bookings[index].pickupLatitude,
      pickupLongitude: bookings[index].pickupLongitude,
      dropLocation: bookings[index].dropLocation,
      dropLatitude: bookings[index].dropLatitude,
      dropLongitude: bookings[index].dropLongitude,
      dateTime: bookings[index].dateTime,
      notes: bookings[index].notes,
      status: status,
      createdAt: bookings[index].createdAt,
    );

    bookings[index] = updatedBooking;
    await _saveBookings(bookings);
    return updatedBooking;
  }

  @override
  Future<BookingModel?> getBookingById(String bookingId) async {
    final bookings = await getBookings();
    try {
      return bookings.firstWhere((b) => b.id == bookingId);
    } catch (e) {
      return null;
    }
  }

  Future<void> _saveBookings(List<BookingModel> bookings) async {
    final jsonList = bookings.map((b) => b.toJson()).toList();
    await storageService.saveString(
      AppConstants.keyBookings,
      jsonEncode(jsonList),
    );
  }
}

