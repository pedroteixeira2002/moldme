import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front_end_moldme/services/review_service.dart';
import 'package:front_end_moldme/dtos/review_dto.dart';
import 'package:mockito/annotations.dart';
import 'review_service_test.mocks.dart';

// Mock http.Client using Mockito
@GenerateMocks([http.Client])
void main() {
  late ReviewService reviewService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    reviewService = ReviewService(client: mockClient);
  });

  test('addReview adds a review successfully', () async {
    const reviewerId = 'reviewerId';
    const reviewedId = 'reviewedId';
    final reviewDto = ReviewDto(
      comment: 'Great job!',
      stars: 5,
      reviewerId: reviewerId,
      reviewedId: reviewedId,
      date: DateTime.now(),
    );

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse('http://localhost:5213/api/Review/addReview?reviewerId=$reviewerId&reviewedId=$reviewedId'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Review added successfully', 200));

    // Perform the service call
    await reviewService.addReview(reviewDto, reviewerId, reviewedId);

    // Verify the call
    verify(mockClient.post(
      Uri.parse('http://localhost:5213/api/Review/addReview?reviewerId=$reviewerId&reviewedId=$reviewedId'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).called(1);
  });

test('addReview throws exception on failure', () async {
    const reviewerId = 'reviewerId';
    const reviewedId = 'reviewedId';
    final reviewDto = ReviewDto(
      comment: 'Great job!',
      stars: 5,
      reviewerId: reviewerId,
      reviewedId: reviewedId,
      date: DateTime.now(),
    );

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse('http://localhost:5213/api/Review/addReview?reviewerId=$reviewerId&reviewedId=$reviewedId'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Internal Server Error', 500));

    // Perform the service call and expect an exception
    expect(() async => await reviewService.addReview(reviewDto, reviewerId, reviewedId), throwsException);
  });

  test('getReviews returns a list of ReviewDto on success', () async {
    const employeeId = 'employeeId';
    final mockResponse = [
      {
        "reviewerId": "reviewerId",
        "reviewedId": employeeId,
        "comment": "Great job!",
        "stars": 5,
        "date": "2023-10-01T00:00:00Z",
      },
      {
        "reviewerId": "reviewerId",
        "reviewedId": employeeId,
        "comment": "Needs improvement.",
        "stars": 3,
        "date": "2023-10-02T00:00:00Z",
      },
    ];

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Review/getReviews?employeeId=$employeeId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    // Perform the service call
    final result = await reviewService.getReviews(employeeId);

    // Assertions
    expect(result, isA<List<ReviewDto>>());
    expect(result.length, 2);
    expect(result.first.comment, "Great job!");
  });

  test('getReviews throws exception on failure', () async {
    const employeeId = 'employeeId';

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Review/getReviews?employeeId=$employeeId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Not Found', 404));

    // Perform the service call and expect an exception
    expect(() async => await reviewService.getReviews(employeeId), throwsException);
  });

test('getReviews returns empty list when no reviews found', () async {
    const employeeId = 'employeeId';
    final mockResponse = [];

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Review/getReviews?employeeId=$employeeId'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    // Perform the service call
    final result = await reviewService.getReviews(employeeId);

    // Assertions
    expect(result, isA<List<ReviewDto>>());
    expect(result.length, 0);
  });
}