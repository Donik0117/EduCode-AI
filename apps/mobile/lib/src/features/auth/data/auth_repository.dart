import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

import '../data/models/auth_user.dart';

abstract interface class AuthRepository {
  Future<AuthUser?> currentUser();

  Future<AuthUser> signIn({
    required String email,
    required String password,
  });

  Future<AuthUser> signUp({
    required String email,
    required String password,
    required String fullName,
  });

  Future<void> signOut();
}

class ApiAuthRepository implements AuthRepository {
  ApiAuthRepository(this._dio, this._storage);

  static const _tokenKey = 'educode_access_token';

  final Dio _dio;
  final FlutterSecureStorage _storage;

  @override
  Future<AuthUser?> currentUser() async {
    final token = await _storage.read(key: _tokenKey);
    if (token == null || token.isEmpty) return null;

    final response = await _dio.get<Map<String, dynamic>>(
      '/auth/me',
      options: Options(headers: {'Authorization': 'Bearer $token'}),
    );
    final data = response.data;
    if (data == null) {
      throw const FormatException('Server bo‘sh javob qaytardi.');
    }
    return AuthUser.fromJson(data);
  }

  @override
  Future<AuthUser> signIn({
    required String email,
    required String password,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/login',
      data: {'email': email.trim(), 'password': password},
    );
    return _saveAuthResponse(response.data);
  }

  @override
  Future<AuthUser> signUp({
    required String email,
    required String password,
    required String fullName,
  }) async {
    final response = await _dio.post<Map<String, dynamic>>(
      '/auth/register',
      data: {
        'email': email.trim(),
        'password': password,
        'full_name': fullName.trim(),
      },
    );
    return _saveAuthResponse(response.data);
  }

  Future<AuthUser> _saveAuthResponse(Map<String, dynamic>? data) async {
    if (data == null || data['access_token'] is! String) {
      throw const FormatException('Server autentifikatsiya tokenini qaytarmadi.');
    }
    final token = data['access_token'] as String;
    final userData = data['user'];
    if (userData is! Map<String, dynamic>) {
      throw const FormatException('Server foydalanuvchi ma’lumotini qaytarmadi.');
    }

    await _storage.write(key: _tokenKey, value: token);
    return AuthUser.fromJson(userData);
  }

  @override
  Future<void> signOut() => _storage.delete(key: _tokenKey);
}
