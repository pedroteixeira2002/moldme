import 'dart:convert';
import 'package:http/http.dart' as http;

class CompanyService {
  final String baseUrl = "http://localhost:5213/api/Company";
  static const String token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9..."
      "AhLZw4rh0_qJ9WLBRx3CjGCe4ja5Thv8r4LfxknFVGc";

  /// Add a new project
  Future<String> addProject(Map<String, dynamic> project, String companyId) async {
    final url = Uri.parse('$baseUrl/addProject/$companyId');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(project),
    );

    if (response.statusCode == 200) {
      return "Project added successfully";
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to add project");
    }
  }

  /// List payment history
  Future<List<dynamic>> listPaymentHistory(String companyId) async {
    final url = Uri.parse('$baseUrl/$companyId/listPaymentHistory');
    final response = await http.get(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return json.decode(response.body) as List<dynamic>;
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to fetch payment history");
    }
  }

  /// Upgrade subscription plan
  Future<String> upgradePlan(String companyId, String subscriptionPlan) async {
    final url = Uri.parse('$baseUrl/$companyId/upgradePlan');
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({"plan": subscriptionPlan}),
    );

    if (response.statusCode == 200) {
      return "Plan upgraded successfully";
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to upgrade plan");
    }
  }

  /// Subscribe to a plan
  Future<String> subscribePlan(String companyId, String subscriptionPlan) async {
    final url = Uri.parse('$baseUrl/$companyId/subscribePlan');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode({"plan": subscriptionPlan}),
    );

    if (response.statusCode == 200) {
      return "Plan subscription successful";
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to subscribe to plan");
    }
  }

  /// Cancel subscription
  Future<String> cancelSubscription(String companyId) async {
    final url = Uri.parse('$baseUrl/$companyId/cancelSubscription');
    final response = await http.put(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      return "Subscription cancelled successfully";
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to cancel subscription");
    }
  }

  /// Register a company
  Future<String> registerCompany(Map<String, dynamic> companyDto) async {
    final url = Uri.parse('$baseUrl/register');
    final response = await http.post(
      url,
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $token",
      },
      body: json.encode(companyDto),
    );

    if (response.statusCode == 200) {
      final responseBody = json.decode(response.body);
      return responseBody['message'] ?? "Company registered successfully";
    } else {
      final Map<String, dynamic> errorResponse = json.decode(response.body);
      throw Exception(errorResponse['message'] ?? "Failed to register company");
    }
  }
}
