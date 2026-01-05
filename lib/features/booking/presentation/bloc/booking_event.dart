import 'package:equatable/equatable.dart';
import '../../domain/entities/booking.dart';

abstract class BookingEvent extends Equatable {
  const BookingEvent();

  @override
  List<Object?> get props => [];
}

class CreateBookingRequested extends BookingEvent {
  final Booking booking;

  const CreateBookingRequested(this.booking);

  @override
  List<Object?> get props => [booking];
}

class GetBookingsRequested extends BookingEvent {
  final String? statusFilter;

  const GetBookingsRequested({this.statusFilter});

  @override
  List<Object?> get props => [statusFilter];
}

class UpdateBookingStatusRequested extends BookingEvent {
  final String bookingId;
  final String status;

  const UpdateBookingStatusRequested({
    required this.bookingId,
    required this.status,
  });

  @override
  List<Object?> get props => [bookingId, status];
}

class RefreshBookings extends BookingEvent {
  const RefreshBookings();
}

