import 'package:flutter/material.dart';
import 'package:front_end_moldme/dtos/payment_dto.dart';
import 'package:front_end_moldme/services/payment_service.dart';

void main() {
  runApp(MaterialApp(
    title: 'MoldMe Payments',
    theme: ThemeData(
      primarySwatch: Colors.blue,
      visualDensity: VisualDensity.adaptivePlatformDensity,
    ),
    home: const PaymentsScreen(companyId: 'bf498b3e-74df-4a7c-ac5a-b9b00d097498'),
  ));
}

class PaymentsScreen extends StatefulWidget {
  final String companyId;
  const PaymentsScreen({super.key, required this.companyId});

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  late Future<List<PaymentDto>> _paymentsFuture;

  @override
  void initState() {
    super.initState();
    _paymentsFuture = _fetchPayments();
  }

  Future<List<PaymentDto>> _fetchPayments() async {
    return await PaymentService().listPaymentHistory(widget.companyId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment History'),
      ),
      body: FutureBuilder<List<PaymentDto>>(
        future: _paymentsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            final payments = snapshot.data!;
            return ListView.builder(
              padding: const EdgeInsets.all(16.0),
              itemCount: payments.length,
              itemBuilder: (context, index) {
                final payment = payments[index];
                return Card(
                  margin: const EdgeInsets.symmetric(vertical: 8.0),
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  child: ListTile(
                    contentPadding: const EdgeInsets.all(16.0),
                    leading: Icon(
                      Icons.payment,
                      color: Colors.blue.shade700,
                      size: 40.0,
                    ),
                    title: Text(
                      'Plan: ${payment.plan}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue.shade900,
                      ),
                    ),
                    subtitle: Text(
                      'Date: ${payment.date.toLocal()}',
                      style: TextStyle(
                        fontSize: 16.0,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    trailing: Text(
                      '\$${payment.value.toStringAsFixed(2)}',
                      style: TextStyle(
                        fontSize: 18.0,
                        fontWeight: FontWeight.bold,
                        color: Colors.green.shade700,
                      ),
                    ),
                  ),
                );
              },
            );
          } else {
            return const Center(child: Text('No payment history found'));
          }
        },
      ),
    );
  }
}