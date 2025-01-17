import 'dart:convert';
import 'package:http/http.dart' as http;
import '../dtos/review_dto.dart';

class ReviewService {
  final String baseUrl = "http://localhost:5213/api/Review";
  final String authToken = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiIxQHN0cmluZy5jb20iLCJodHRwOi8vc2NoZW1hcy5taWNyb3NvZnQuY29tL3dzLzIwMDgvMDYvaWRlbnRpdHkvY2xhaW1zL3JvbGUiOiJDb21wYW55IiwiZXhwIjoxNzM1MDc1NDk3LCJpc3MiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMiLCJhdWQiOiJodHRwOi8vbG9jYWxob3N0OjUyMTMifQ.ZvbITiUC64dCLOCFiBYmIvO5z9cIR7vWZMtahOmfkpU";
  
  /// Add a review
  Future<void> addReview(ReviewDto reviewDto, String reviewerId, String reviewedId) async {
    final url = Uri.parse('$baseUrl/addReview?reviewerId=$reviewerId&reviewedId=$reviewedId');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken',
        },
        body: jsonEncode({
          'comment': reviewDto.comment,
          'stars': reviewDto.stars,
        }),
      );

      if (response.statusCode == 200) {
        print("Review added successfully");
      } else {
        throw Exception('Failed to add review: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while adding review: $e');
    }
  }

  /// Get all reviews for an employee
  Future<List<ReviewDto>> getReviews(String employeeId) async {
    final url = Uri.parse('$baseUrl/getReviews?employeeId=$employeeId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $authToken', // Include the authorization token
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> json = jsonDecode(response.body);
        return json.map((e) => ReviewDto.fromJson(e)).toList();
      } else {
        throw Exception('Failed to get reviews: ${response.body}');
      }
    } catch (e) {
      throw Exception('Error occurred while getting reviews: $e');
    }
  }
}