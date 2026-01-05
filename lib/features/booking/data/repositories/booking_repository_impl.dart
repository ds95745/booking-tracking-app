import '../../domain/entities/booking.dart';
import '../../domain/repositories/booking_repository.dart';
import '../datasources/booking_local_datasource.dart';
import '../models/booking_model.dart';

class BookingRepositoryImpl implements BookingRepository {
  final BookingLocalDataSource localDataSource;

  BookingRepositoryImpl(this.localDataSource);

  @override
  Future<Booking> createBooking(Booking booking) async {
    try {
      final bookingModel = BookingModel(
        id: booking.id,
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

      return await localDataSource.createBooking(bookingModel);
    } catch (e) {
      throw Exception('Failed to create booking: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getBookings() async {
    try {
      return await localDataSource.getBookings();
    } catch (e) {
      throw Exception('Failed to get bookings: ${e.toString()}');
    }
  }

  @override
  Future<List<Booking>> getBookingsByStatus(String status) async {
    try {
      return await localDataSource.getBookingsByStatus(status);
    } catch (e) {
      throw Exception('Failed to get bookings by status: ${e.toString()}');
    }
  }

  @override
  Future<Booking> updateBookingStatus(String bookingId, String status) async {
    try {
      return await localDataSource.updateBookingStatus(bookingId, status);
    } catch (e) {
      throw Exception('Failed to update booking status: ${e.toString()}');
    }
  }

  @override
  Future<Booking?> getBookingById(String bookingId) async {
    try {
      return await localDataSource.getBookingById(bookingId);
    } catch (e) {
      return null;
    }
  }
}

