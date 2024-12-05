import 'package:flutter_test/flutter_test.dart';
import 'package:front_end_moldme/models/subscriptionPlan.dart';
import 'package:mockito/mockito.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:front_end_moldme/services/payment_service.dart';
import 'package:front_end_moldme/dtos/payment_dto.dart';
import 'package:mockito/annotations.dart';
import 'payment_service_test.mocks.dart';

// Mock http.Client using Mockito
@GenerateMocks([http.Client])
void main() {
  late PaymentService paymentService;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    paymentService = PaymentService(client: mockClient);
  });

  test('listPaymentHistory returns a list of PaymentDto on success', () async {
    const companyId = 'bf498b3e-74df-4a7c-ac5a-b9b00d097498';
    final mockResponse = [
      {
        "paymentId": "",
        "companyId": companyId,
        "date": "2023-10-01T00:00:00Z",
        "project": "",
        "value": 100.0,
        "plan": 1,
      },
      {
        "paymentId": "",
        "companyId": companyId,
        "date": "2023-10-02T00:00:00Z",
        "project": "",
        "value": 200.0,
        "plan": 1,
      },
    ];

    // Mock the HTTP GET request
    when(mockClient.get(
      Uri.parse('http://localhost:5213/api/Company/$companyId/listPaymentHistory'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response(jsonEncode(mockResponse), 200));

    // Perform the service call
    final result = await paymentService.listPaymentHistory(companyId);

    // Assertions
    expect(result, isA<List<PaymentDto>>());
    expect(result.length, 2);
    expect(result.first.value, 100.0);
  });

  test('upgradePlan returns success message on success', () async {
    const companyId = 'bf498b3e-74df-4a7c-ac5a-b9b00d097498';
    const subscriptionPlan = SubscriptionPlan.Basic;

    // Mock the HTTP PUT request
    when(mockClient.put(
      Uri.parse('http://localhost:5213/api/Company/$companyId/upgradePlan'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Plan upgraded successfully', 200));

    // Perform the service call
    final result = await paymentService.upgradePlan(companyId, subscriptionPlan);

    // Assertions
    expect(result, 'Plan upgraded successfully');
  });

  test('subscribePlan returns success message on success', () async {
    const companyId = 'bf498b3e-74df-4a7c-ac5a-b9b00d097498';
    const subscriptionPlan = SubscriptionPlan.Premium;

    // Mock the HTTP POST request
    when(mockClient.post(
      Uri.parse('http://localhost:5213/api/Company/$companyId/subscribePlan'),
      headers: anyNamed('headers'),
      body: anyNamed('body'),
    )).thenAnswer((_) async => http.Response('Subscribed to plan successfully', 200));

    // Perform the service call
    final result = await paymentService.subscribePlan(companyId, subscriptionPlan);

    // Assertions
    expect(result, 'Subscribed to plan successfully');
  });

  test('cancelSubscription returns success message on success', () async {
    const companyId = 'bf498b3e-74df-4a7c-ac5a-b9b00d097498';

    // Mock the HTTP PUT request
    when(mockClient.put(
      Uri.parse('http://localhost:5213/api/Company/$companyId/cancelSubscription'),
      headers: anyNamed('headers'),
    )).thenAnswer((_) async => http.Response('Subscription cancelled successfully', 200));

    // Perform the service call
    final result = await paymentService.cancelSubscription(companyId);

    // Assertions
    expect(result, 'Subscription cancelled successfully');
  });
}