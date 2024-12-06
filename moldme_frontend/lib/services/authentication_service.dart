import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService {
  final String _baseUrl = "http://localhost:5213/api";
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();

  /// Logs in the user and saves the token
  Future<void> login(String email, String password) async {
    final url = Uri.parse("$_baseUrl/login");
    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final token = data["access_token"]; // Verifique a chave correta do token
      final userId = data["user_id"];

      if (token != null && userId != null) {
        // Store the token and user ID securely
        await storeToken(token);
        await storeUserId(userId);
        print("Logged in successfully");
      } else {
        throw Exception("Token or user ID not found in response.");
      }
    } else if (response.statusCode == 401) {
      throw Exception("Invalid credentials.");
    } else {
      throw Exception("Failed to login: ${response.body}");
    }
  }

  /// Retrieves the stored token
  Future<String?> getToken() async {
    return await _secureStorage.read(key: "access_token");
  }

  /// Retrieves the stored user ID
  Future<String?> getUserId() async {
    return await _secureStorage.read(key: "user_id");
  }

  /// Logs out the user by deleting the token
  Future<void> logout() async {
    await _secureStorage.delete(key: "access_token");
  }

  /// Stores the token securely
  Future<void> storeToken(String token) async {
    await _secureStorage.write(key: "access_token", value: token);
  }

  /// Stores the user ID securely
  Future<void> storeUserId(String userId) async {
    await _secureStorage.write(key: "user_id", value: userId);
  }
}
