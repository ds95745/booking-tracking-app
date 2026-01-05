import '../../domain/entities/user.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_remote_datasource.dart';
import '../models/user_model.dart';
import '../../../../core/services/storage_service.dart';
import '../../../../core/constants/app_constants.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final StorageService? storageService;

  AuthRepositoryImpl(this.remoteDataSource, {this.storageService});

  @override
  Future<User> login(String email, String password) async {
    try {
      final userModel = await remoteDataSource.login(email, password);
      
      // Save auth token (mock)
      final storageService = this.storageService;
      if (storageService != null) {
        await storageService.saveString(
          AppConstants.keyAuthToken,
          'mock_token_${userModel.id}',
        );
        await storageService.saveString(
          AppConstants.keyUserId,
          userModel.id,
        );
      }

      return userModel;
    } catch (e) {
      throw Exception('Login failed: ${e.toString()}');
    }
  }

  @override
  Future<void> logout() async {
    final storageService = this.storageService;
    if (storageService != null) {
      await storageService.remove(AppConstants.keyAuthToken);
      await storageService.remove(AppConstants.keyUserId);
    }
  }

  @override
  Future<User?> getCurrentUser() async {
    try {
      final userId = storageService != null
          ? await storageService?.getString(AppConstants.keyUserId)
          : null;
      
      if (userId == null) return null;

      // Return mock user - in production, fetch from API
      return UserModel(
        id: userId,
        email: 'user@example.com',
        name: 'User',
      );
    } catch (e) {
      return null;
    }
  }
}

