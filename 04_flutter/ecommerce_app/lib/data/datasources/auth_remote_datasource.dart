import 'dart:convert';

import '../../core/constants/env.dart';

class AuthRemoteDatasource {
  const AuthRemoteDatasource();

  Future<Map<String, dynamic>?> login(String email, String password) async {
    final url = Uri.parse('$authUrl/token?grant_type=password');
    final response = await http.post(
      url,
      headers: {'apikey': apiKey, 'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    }

    return null;
  }

  Future<bool> signup(String email, String password) async {
    final url = Uri.parse('$authUrl/signup');
    final response = await http.post(
      url,
      headers: {'apikey': apiKey, 'Content-Type': 'application/json'},
      body: jsonEncode({'email': email, 'password': password}),
    );

    return response.statusCode == 200 || response.statusCode == 201;
  }
}
