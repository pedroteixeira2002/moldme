class PaymentDto {
  final String paymentId;
  final String companyId;
  final DateTime date;
  final double value;
  final int plan;

  PaymentDto({
    required this.paymentId,
    required this.companyId,
    required this.date,
    required this.value,
    required this.plan,
  });

  factory PaymentDto.fromJson(Map<String, dynamic> json) {
    return PaymentDto(
      paymentId: json['paymentId'],
      companyId: json['companyId'],
      date: DateTime.parse(json['date']),
      value: json['value'].toDouble(),
      plan: json['plan'],
    );
  }
}
