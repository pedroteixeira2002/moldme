import 'dart:convert';
import 'package:front_end_moldme/services/authentication_service.dart';
import 'package:http/http.dart' as http;
import '../dtos/review_dto.dart';

class ReviewService {
  final String baseUrl = "http://localhost:5213/api/Review";
  final AuthenticationService _authenticationService = AuthenticationService();
  
  /// Add a review
  Future<void> addReview(ReviewDto reviewDto, String reviewerId, String reviewedId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/addReview?reviewerId=$reviewerId&reviewedId=$reviewedId');
    try {
      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
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
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/getReviews?employeeId=$employeeId');
    try {
      final response = await http.get(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token', // Include the authorization token
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