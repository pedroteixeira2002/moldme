/// Data Transfer Object (DTO) for an offer.
class OfferDto {
  final DateTime date;
  final String status;
  final String description;

  OfferDto({
    required this.date,
    required this.status,
    required this.description,
  });

  // Converts a JSON map into an OfferDto.
  factory OfferDto.fromJson(Map<String, dynamic> json) {
    return OfferDto(
      date: DateTime.parse(json['date']),
      status: json['status'],
      description: json['description'],
    );
  }

  // Converts OfferDto to a JSON map for API requests.
  Map<String, dynamic> toJson() {
    return {
      'date': date.toIso8601String(),
      'status': status,
      'description': description,
    };
  }
}
