import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'core/constants/app_colors.dart';
import 'core/di/injection_container.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';
import 'features/auth/presentation/bloc/auth_event.dart';
import 'features/auth/presentation/bloc/auth_state.dart';
import 'features/auth/presentation/pages/login_page.dart';
import 'features/home/presentation/pages/home_page.dart';
import 'features/booking/presentation/bloc/booking_bloc.dart';
import 'features/tracking/presentation/bloc/tracking_bloc.dart';
import 'features/booking/presentation/pages/booking_history_page.dart';
import 'features/booking/presentation/pages/create_booking_page.dart';
import 'features/booking/presentation/pages/booking_details_page.dart';
import 'features/tracking/presentation/pages/tracking_page.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await setupDependencyInjection();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AuthBloc>(
          create: (context) => getIt<AuthBloc>(),
        ),
        BlocProvider<BookingBloc>(
          create: (context) => getIt<BookingBloc>(),
        ),
        BlocProvider<TrackingBloc>(
          create: (context) => getIt<TrackingBloc>(),
        ),
      ],
      child: MaterialApp.router(
        title: 'Booking & Tracking App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: AppColors.primary,
            brightness: Brightness.light,
          ),
          useMaterial3: true,
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor: AppColors.primary,
            foregroundColor: Colors.white,
            elevation: 0,
          ),

        ),
        routerConfig: _router,
      ),
    );
  }
}

final GoRouter _router = GoRouter(
  initialLocation: '/',
  redirect: (context, state) {
    final authBloc = getIt<AuthBloc>();
    final authState = authBloc.state;

    final isLoggedIn = authState is AuthAuthenticated;
    final isLoginPage = state.matchedLocation == '/login';

    if (!isLoggedIn && !isLoginPage) {
      return '/login';
    }

    if (isLoggedIn && isLoginPage) {
      return '/';
    }

    return null;
  },
  routes: [
    GoRoute(
      path: '/login',
      builder: (context, state) => const LoginPage(),
    ),
    GoRoute(
      path: '/',
      builder: (context, state) => const HomePage(),
    ),
    GoRoute(
      path: '/bookings',
      builder: (context, state) => const BookingHistoryPage(),
    ),
    GoRoute(
      path: '/bookings/create',
      builder: (context, state) => const CreateBookingPage(),
    ),
    GoRoute(
      path: '/bookings/:id',
      builder: (context, state) {
        final bookingId = state.pathParameters['id']!;
        return BookingDetailsPage(bookingId: bookingId);
      },
    ),
    GoRoute(
      path: '/tracking',
      builder: (context, state) {
        final extra = state.extra as Map<String, dynamic>?;
        if (extra == null) {
          return const HomePage();
        }
        return TrackingPage(
          pickupLocation: extra['pickupLocation'] as LatLng,
          dropLocation: extra['dropLocation'] as LatLng,
          pickupAddress: extra['pickupAddress'] as String,
          dropAddress: extra['dropAddress'] as String,
        );
      },
    ),
  ],
);

