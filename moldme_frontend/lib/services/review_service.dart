import 'dart:convert';
import 'package:front_end_moldme/services/authentication_service.dart';
import 'package:http/http.dart' as http;
import '../dtos/review_dto.dart';

class ReviewService {
  final String baseUrl = "https://moldme-ghh9b5b9c6azgfb8.canadacentral-01.azurewebsites.net/api/Review";
  final AuthenticationService _authenticationService = AuthenticationService();
  final http.Client client;

  ReviewService({http.Client? client}) : client = client ?? http.Client();

  /// Add a review
  Future<void> addReview(
      String reviewerId, String reviewedId, String comment, int stars) async {
    final url = Uri.parse(
        '$baseUrl/addReview?reviewerId=$reviewerId&reviewedId=$reviewedId');

    final response = await client.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiIxQHN0cmluZy5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJDb21wYW55IiwiZXhwIjoxNzM1MDc1NDk3LCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMifQ.ZvbITiUC64dCLOCFiBYmIvO5z9cIR7vWZMtahOmfkpU',
      },
      body: json.encode({
        'comment': comment,
        'stars': stars,
      }),
    );

    if (response.statusCode == 200) {
      print("Review added successfully");
    } else {
      throw Exception('Failed to add review: ${response.body}');
    }
  }

  /// Get all reviews for an employee
  Future<List<ReviewDto>> getReviews(String employeeId) async {
    final url = Uri.parse(
        '$baseUrl/getReviews?employeeId=$employeeId'); // Certifique-se de passar o parâmetro na query string.

    try {
      final authToken = await _authenticationService.getToken();
      final response = await client.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Incluindo o token de autenticação
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        return json
            .map((e) => ReviewDto.fromJson(e))
            .toList(); // Convertendo a resposta para um objeto ReviewDto
      } else {
        throw Exception('Failed to get reviews: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while getting reviews: $e');
    }
  }
}