import 'dart:convert';
import 'package:front_end_moldme/dtos/company_dto.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class AuthenticationService {
  final String _baseUrl = "https://moldme-ghh9b5b9c6azgfb8.canadacentral-01.azurewebsites.net/api";
  final FlutterSecureStorage _secureStorage = FlutterSecureStorage();
  late final http.Client client;
  
  /// Logs in the user and saves the token
  Future<void> login(String email, String password) async {
    final url = Uri.parse("$_baseUrl/login");
    final response = await client.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    print("Response status: ${response.statusCode}"); // Log do status da resposta
    print("Response body: ${response.body}");

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

  // Decode token and check role if company or employee
  Future<String> checkRole() async {
    // Obtém o token JWT
    final token = await getToken();
    // Divide o token em partes (cabeçalho, payload, assinatura)
    final parts = token!.split('.');
    // Decodifica o payload de Base64URL para UTF-8
    final payload = parts[1];
    final String decoded = utf8.decode(base64Url.decode(base64Url.normalize(payload)));
    // Converte a string decodificada para um mapa
    final Map<String, dynamic> payloadMap = json.decode(decoded);
    // Extrai o valor do papel (role) do mapa
    final String role = payloadMap["http://schemas.microsoft.com/ws/2008/06/identity/claims/role"];
    // Retorna o papel ou seja se é empresa ou funcionário
    return role;
  }

  Future<CompanyDto> getCompanyById(String companyId) async {
    final url = Uri.parse("$_baseUrl/company/$companyId");
    final response = await http.get(url, headers: {"Authorization": "Bearer ${await getToken()}"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return CompanyDto.fromJson(data);
    } else {
      throw Exception("Failed to fetch company details");
    }
  }
}