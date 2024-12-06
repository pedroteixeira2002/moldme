import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/review_dto.dart';

class ReviewService {
  final String baseUrl = "http://localhost:5213/api/Review";
  final String authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiIxQHN0cmluZy5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJDb21wYW55IiwiZXhwIjoxNzM1MDc1NDk3LCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMifQ.ZvbITiUC64dCLOCFiBYmIvO5z9cIR7vWZMtahOmfkpU";
  
  /// Add a review
  Future<void> addReview(
      String reviewerId, String reviewedId, String comment, int stars) async {
    final url = Uri.parse(
        '$baseUrl/addReview?reviewerId=$reviewerId&reviewedId=$reviewedId');

    final response = await http.post(
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
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization':
              'Bearer $authToken', // Incluindo o token de autenticação
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