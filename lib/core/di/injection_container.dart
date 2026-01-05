import 'package:get_it/get_it.dart';
import '../../features/auth/presentation/bloc/auth_event.dart';
import '../services/storage_service.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/auth/domain/usecases/login_usecase.dart';
import '../../features/auth/presentation/bloc/auth_bloc.dart';
import '../../features/booking/data/datasources/booking_local_datasource.dart';
import '../../features/booking/data/repositories/booking_repository_impl.dart';
import '../../features/booking/domain/repositories/booking_repository.dart';
import '../../features/booking/domain/usecases/create_booking_usecase.dart';
import '../../features/booking/domain/usecases/get_bookings_usecase.dart';
import '../../features/booking/domain/usecases/update_booking_status_usecase.dart';
import '../../features/booking/presentation/bloc/booking_bloc.dart';
import '../../features/tracking/presentation/bloc/tracking_bloc.dart';

final getIt = GetIt.instance;

Future<void> setupDependencyInjection() async {
  // Services
  getIt.registerLazySingleton<StorageService>(() => StorageServiceImpl());

  // Auth
  getIt.registerLazySingleton<AuthRemoteDataSource>(
    () => AuthRemoteDataSourceImpl(),
  );
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      getIt<AuthRemoteDataSource>(),
      storageService: getIt<StorageService>(),
    ),
  );
  getIt.registerLazySingleton<LoginUseCase>(
    () => LoginUseCase(getIt<AuthRepository>()),
  );
  getIt.registerLazySingleton<AuthBloc>(
    () => AuthBloc(
      getIt<LoginUseCase>(),
      authRepository: getIt<AuthRepository>(),
    )..add(const CheckAuthStatus()),
  );

  // Booking
  getIt.registerLazySingleton<BookingLocalDataSource>(
    () => BookingLocalDataSourceImpl(getIt<StorageService>()),
  );
  getIt.registerLazySingleton<BookingRepository>(
    () => BookingRepositoryImpl(getIt<BookingLocalDataSource>()),
  );
  getIt.registerLazySingleton<CreateBookingUseCase>(
    () => CreateBookingUseCase(getIt<BookingRepository>()),
  );
  getIt.registerLazySingleton<GetBookingsUseCase>(
    () => GetBookingsUseCase(getIt<BookingRepository>()),
  );
  getIt.registerLazySingleton<UpdateBookingStatusUseCase>(
    () => UpdateBookingStatusUseCase(getIt<BookingRepository>()),
  );
  getIt.registerFactory<BookingBloc>(
    () => BookingBloc(
      getIt<CreateBookingUseCase>(),
      getIt<GetBookingsUseCase>(),
      getIt<UpdateBookingStatusUseCase>(),
    ),
  );

  // Tracking
  getIt.registerFactory<TrackingBloc>(
    () => TrackingBloc(),
  );
}

