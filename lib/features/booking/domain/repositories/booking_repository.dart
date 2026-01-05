import '../entities/booking.dart';

abstract class BookingRepository {
  Future<Booking> createBooking(Booking booking);
  Future<List<Booking>> getBookings();
  Future<List<Booking>> getBookingsByStatus(String status);
  Future<Booking> updateBookingStatus(String bookingId, String status);
  Future<Booking?> getBookingById(String bookingId);
}

