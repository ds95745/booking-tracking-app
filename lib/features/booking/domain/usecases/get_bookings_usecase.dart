import '../entities/booking.dart';
import '../repositories/booking_repository.dart';

class GetBookingsUseCase {
  final BookingRepository repository;

  GetBookingsUseCase(this.repository);

  Future<List<Booking>> call({String? status}) {
    if (status != null && status.isNotEmpty) {
      return repository.getBookingsByStatus(status);
    }
    return repository.getBookings();
  }
}

