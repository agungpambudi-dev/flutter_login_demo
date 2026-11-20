import 'dart:convert';
import 'package:http/http.dart' as http;

import '../models/user_model.dart';

class AuthService {
  static const String baseUrl = 'https://dummyjson.com';

  /// Login ke API dan mengembalikan access token
  Future<String> login({
    required String username,
    required String password,
  }) async {
    final url = Uri.parse('$baseUrl/auth/login');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: jsonEncode({
        'username': username,
        'password': password,
        'expiresInMins': 30,
      }),
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Mengambil access token dari response API
      return data['accessToken'];
    } else {
      throw Exception(
        data['message'] ?? 'Login gagal',
      );
    }
  }

  /// Mengambil data user yang sedang login
  /// menggunakan access token
  Future<UserModel> getCurrentUser(String accessToken) async {
    final url = Uri.parse('$baseUrl/auth/me');

    final response = await http.get(
      url,
      headers: {
        'Authorization': 'Bearer $accessToken',
      },
    );

    final data = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return UserModel.fromJson(data);
    } else {
      throw Exception(
        data['message'] ?? 'Gagal mengambil data user',
      );
    }
  }
}