import 'package:equatable/equatable.dart';
import '../../domain/entities/booking.dart';

abstract class BookingState extends Equatable {
  const BookingState();

  @override
  List<Object?> get props => [];
}

class BookingInitial extends BookingState {}

class BookingLoading extends BookingState {}

class BookingLoaded extends BookingState {
  final List<Booking> bookings;
  final String? statusFilter;

  const BookingLoaded({
    required this.bookings,
    this.statusFilter,
  });

  @override
  List<Object?> get props => [
        bookings,
        statusFilter,
      ];
}

class BookingCreated extends BookingState {
  final Booking booking;

  const BookingCreated(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingStatusUpdated extends BookingState {
  final Booking booking;

  const BookingStatusUpdated(this.booking);

  @override
  List<Object?> get props => [booking];
}

class BookingError extends BookingState {
  final String message;

  const BookingError(this.message);

  @override
  List<Object?> get props => [message];
}

