class ReviewDto {
  final String? reviewId;
  final String comment;
  final DateTime? date;
  final int stars;
  final String? reviewerId;
  final String? reviewedId;

  ReviewDto({
    this.reviewId,
    required this.comment,
    this.date,
    required this.stars,
    this.reviewerId,
    this.reviewedId,
  });

  /// Factory constructor for creating a `ReviewDto` from JSON
  factory ReviewDto.fromJson(Map<String, dynamic> json) {
    return ReviewDto(
      reviewId: json['reviewId'],
      comment: json['comment'],
      date: DateTime.parse(json['date']),
      stars: json['stars'],
      reviewerId: json['reviewerId'],
      reviewedId: json['reviewedId'],
    );
  }

  /// Convert `ReviewDto` to JSON
  Map<String, dynamic> toJson() {
    return {
      'comment': comment,
      'stars': stars,
    };
  }
}
