import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class CreateBookingUseCase {
  final BookingRepository repository;

  CreateBookingUseCase(this.repository);

  Future<Booking> call(Booking booking) {
    return repository.createBooking(booking);
  }
}

