import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/create_booking_usecase.dart';
import '../../domain/usecases/get_bookings_usecase.dart';
import '../../domain/usecases/update_booking_status_usecase.dart';
import 'booking_event.dart';
import 'booking_state.dart';

class BookingBloc extends Bloc<BookingEvent, BookingState> {
  final CreateBookingUseCase createBookingUseCase;
  final GetBookingsUseCase getBookingsUseCase;
  final UpdateBookingStatusUseCase updateBookingStatusUseCase;

  BookingBloc(
    this.createBookingUseCase,
    this.getBookingsUseCase,
    this.updateBookingStatusUseCase,
  ) : super(BookingInitial()) {
    on<CreateBookingRequested>(_onCreateBookingRequested);
    on<GetBookingsRequested>(_onGetBookingsRequested);
    on<UpdateBookingStatusRequested>(_onUpdateBookingStatusRequested);
    on<RefreshBookings>(_onRefreshBookings);
  }

  Future<void> _onCreateBookingRequested(
    CreateBookingRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final booking = await createBookingUseCase(event.booking);
      emit(BookingCreated(booking));
      // Refresh bookings list
      add(const GetBookingsRequested());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onGetBookingsRequested(
    GetBookingsRequested event,
    Emitter<BookingState> emit,
  ) async {
    emit(BookingLoading());
    try {
      final bookings = await getBookingsUseCase(status: event.statusFilter);
      emit(BookingLoaded(
        bookings: bookings,
        statusFilter: event.statusFilter,
      ));
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onUpdateBookingStatusRequested(
    UpdateBookingStatusRequested event,
    Emitter<BookingState> emit,
  ) async {
    try {
      final booking = await updateBookingStatusUseCase(
        event.bookingId,
        event.status,
      );
      emit(BookingStatusUpdated(booking));
      // Refresh bookings list
      add(const GetBookingsRequested());
    } catch (e) {
      emit(BookingError(e.toString()));
    }
  }

  Future<void> _onRefreshBookings(
    RefreshBookings event,
    Emitter<BookingState> emit,
  ) async {
    final currentState = state;
    if (currentState is BookingLoaded) {
      add(GetBookingsRequested(statusFilter: currentState.statusFilter));
    } else {
      add(const GetBookingsRequested());
    }
  }
}

