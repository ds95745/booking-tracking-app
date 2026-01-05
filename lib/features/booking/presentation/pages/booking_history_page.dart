import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_strings.dart';
import '../../../../core/constants/app_constants.dart';
import '../../../../core/utils/date_formatter.dart';
import '../../../../core/widgets/status_chip.dart';
import '../../../../core/widgets/loading_widget.dart';
import '../../../../core/widgets/error_widget.dart';
import '../bloc/booking_bloc.dart';
import '../bloc/booking_event.dart';
import '../bloc/booking_state.dart';
import 'booking_details_page.dart';
import 'create_booking_page.dart';

class BookingHistoryPage extends StatefulWidget {
  const BookingHistoryPage({super.key});

  @override
  State<BookingHistoryPage> createState() => _BookingHistoryPageState();
}

class _BookingHistoryPageState extends State<BookingHistoryPage> {
  String? _selectedStatusFilter;

  @override
  void initState() {
    super.initState();
    context.read<BookingBloc>().add(const GetBookingsRequested());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(AppStrings.bookingHistory),
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        actions: [
          PopupMenuButton<String>(
            icon: const Icon(Icons.filter_list),
            onSelected: (value) {
              setState(() {
                _selectedStatusFilter = value == 'All' ? null : value;
              });
              context.read<BookingBloc>().add(
                    GetBookingsRequested(
                      statusFilter: _selectedStatusFilter,
                    ),
                  );
            },
            itemBuilder: (context) => [
              const PopupMenuItem(
                value: 'All',
                child: Text('All'),
              ),
              const PopupMenuItem(
                value: AppConstants.statusPending,
                child: Text(AppConstants.statusPending),
              ),
              const PopupMenuItem(
                value: AppConstants.statusAccepted,
                child: Text(AppConstants.statusAccepted),
              ),
              const PopupMenuItem(
                value: AppConstants.statusOnTheWay,
                child: Text(AppConstants.statusOnTheWay),
              ),
              const PopupMenuItem(
                value: AppConstants.statusCompleted,
                child: Text(AppConstants.statusCompleted),
              ),
            ],
          ),
        ],
      ),
      body: BlocBuilder<BookingBloc, BookingState>(
        builder: (context, state) {
          if (state is BookingLoading) {
            return const LoadingWidget();
          }

          if (state is BookingError) {
            return ErrorDisplayWidget(
              message: state.message,
              onRetry: () {
                context.read<BookingBloc>().add(
                      GetBookingsRequested(statusFilter: _selectedStatusFilter),
                    );
              },
            );
          }

          if (state is BookingLoaded) {
            if (state.bookings.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.inbox_outlined,
                      size: 64,
                      color: AppColors.textDisabled,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      AppStrings.noBookings,
                      style: const TextStyle(
                        fontSize: 18,
                        color: AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              );
            }

            return RefreshIndicator(
              onRefresh: () async {
                context.read<BookingBloc>().add(
                      GetBookingsRequested(statusFilter: _selectedStatusFilter),
                    );
              },
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: state.bookings.length,
                itemBuilder: (context, index) {
                  final booking = state.bookings[index];
                  return _BookingCard(booking: booking);
                },
              ),
            );
          }

          return const SizedBox.shrink();
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () async {
          final result = await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const CreateBookingPage(),
            ),
          );
          if (result == true) {
            context.read<BookingBloc>().add(
                  GetBookingsRequested(statusFilter: _selectedStatusFilter),
                );
          }
        },
        backgroundColor: AppColors.primary,
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          AppStrings.createBooking,
          style: TextStyle(color: Colors.white),
        ),
      ),
    );
  }
}

class _BookingCard extends StatelessWidget {
  final dynamic booking;

  const _BookingCard({required this.booking});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => BookingDetailsPage(bookingId: booking.id),
            ),
          );
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          booking.pickupLocation,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(
                              Icons.arrow_downward,
                              size: 16,
                              color: AppColors.textSecondary,
                            ),
                            const SizedBox(width: 4),
                            Expanded(
                              child: Text(
                                booking.dropLocation,
                                style: const TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                  StatusChip(status: booking.status),
                ],
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Icon(
                    Icons.access_time,
                    size: 16,
                    color: AppColors.textSecondary,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    DateFormatter.formatDateTime(booking.dateTime),
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

