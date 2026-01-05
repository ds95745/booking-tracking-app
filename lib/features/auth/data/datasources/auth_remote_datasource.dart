import '../models/user_model.dart';

abstract class AuthRemoteDataSource {
  Future<UserModel> login(String email, String password);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  @override
  Future<UserModel> login(String email, String password) async {
    // Simulate API delay
    await Future.delayed(const Duration(seconds: 1));

    // Mock authentication - accept any email/password for demo
    // In production, this would make an actual API call
    if (email.isEmpty || password.isEmpty) {
      throw Exception('Email and password are required');
    }

    // Mock successful login
    return UserModel(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      email: email,
      name: email.split('@').first,
    );
  }
}

