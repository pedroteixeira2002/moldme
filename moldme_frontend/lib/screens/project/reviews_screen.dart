import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/review_dto.dart';
import '../../widgets/review_cart.dart';


void main(){
  runApp(MaterialApp(
    home: ReviewsScreen(
      userReviews: [
        ReviewDto(
          reviewerId: '675943a6-6a50-40b9-a1c3-168b9dfc87a9',
          comment: 'espetaculo',
          date: DateTime.now(),
          stars: 5,
          reviewedId: '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08',
        ),
        ReviewDto(
          reviewerId: '675943a6-6a50-40b9-a1c3-168b9dfc87a9',
          comment: 'espetaculo',
          date: DateTime.now(),
          stars: 4,
          reviewedId: '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08',
        ),
        ReviewDto(
          reviewerId: '675943a6-6a50-40b9-a1c3-168b9dfc87a9',
          comment: 'espetaculo',
          date: DateTime.now(),
          stars: 3,
          reviewedId: '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08',
        ),
        ReviewDto(
          reviewerId: '675943a6-6a50-40b9-a1c3-168b9dfc87a9',
          comment: 'espetaculo',
          date: DateTime.now(),
          stars: 2,
          reviewedId: '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08',
        ),
        ReviewDto(
          reviewerId: '675943a6-6a50-40b9-a1c3-168b9dfc87a9',
          comment: 'espetaculo',
          date: DateTime.now(),
          stars: 1,
          reviewedId: '014e3239-c98f-4ce4-b4e9-1a4d0cdfcd08',
        ),
      ],
    ),
  ));
}
class ReviewsScreen extends StatelessWidget {
  final List<ReviewDto> userReviews;

  ReviewsScreen({required this.userReviews});

  @override
  Widget build(BuildContext context) {
    Map<int, int> starCounts = _calculateStarCounts(userReviews);
    int totalReviews = userReviews.length;
    double averageRating = userReviews.isNotEmpty
        ? userReviews.map((r) => r.stars).reduce((a, b) => a + b) / totalReviews
        : 0.0;

    return Scaffold(
      appBar: AppBar(
        title: const Text('User Reviews'),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Container(
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12.0),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      averageRating.toStringAsFixed(1),
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < averageRating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 32,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "($totalReviews Reviews)",
                      style: TextStyle(color: Colors.grey.shade600),
                    ),
                    const SizedBox(height: 16),
                    _buildReviewRow("5 stars", starCounts[5] ?? 0, totalReviews),
                    _buildReviewRow("4 stars", starCounts[4] ?? 0, totalReviews),
                    _buildReviewRow("3 stars", starCounts[3] ?? 0, totalReviews),
                    _buildReviewRow("2 stars", starCounts[2] ?? 0, totalReviews),
                    _buildReviewRow("1 star", starCounts[1] ?? 0, totalReviews),
                  ],
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: userReviews.length,
              itemBuilder: (context, index) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
                  child: ReviewCard(review: userReviews[index]),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Map<int, int> _calculateStarCounts(List<ReviewDto> reviews) {
    Map<int, int> starCounts = {1: 0, 2: 0, 3: 0, 4: 0, 5: 0};

    for (var review in reviews) {
      if (starCounts.containsKey(review.stars)) {
        starCounts[review.stars] = starCounts[review.stars]! + 1;
      }
    }

    return starCounts;
  }

  Widget _buildReviewRow(String label, int count, int totalReviews) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(label, style: const TextStyle(color: Colors.black87)),
          ),
          Expanded(
            flex: 1,
            child: Text("($count)", style: const TextStyle(color: Colors.black54)),
          ),
          Expanded(
            flex: 5,
            child: LinearProgressIndicator(
              value: totalReviews > 0 ? count / totalReviews : 0,
              backgroundColor: Colors.grey.shade300,
              color: Colors.amber,
            ),
          ),
        ],
      ),
    );
  }
}