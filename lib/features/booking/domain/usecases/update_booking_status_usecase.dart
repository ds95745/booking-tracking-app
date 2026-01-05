import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class UpdateBookingStatusUseCase {
  final BookingRepository repository;

  UpdateBookingStatusUseCase(this.repository);

  Future<Booking> call(String bookingId, String status) {
    return repository.updateBookingStatus(bookingId, status);
  }
}

