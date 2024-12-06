import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/review_dto.dart';

class ReviewCard extends StatelessWidget {
  final ReviewDto review;
  ReviewCard({required this.review});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: ListTile(
        title: Text(review.comment),
        subtitle: Row(
          children: [
            ...List.generate(
                review.stars, (index) => Icon(Icons.star, color: Colors.amber)),
          ],
        ),
        trailing: Text(review.date?.toString() ?? 'No date'),
      ),
    );
  }
}
