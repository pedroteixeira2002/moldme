import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:front_end_moldme/models/company.dart';
import 'package:front_end_moldme/models/subscriptionPlan.dart';
import 'package:front_end_moldme/screens/register/checkEmailScreen.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class CheckOutScreen extends StatefulWidget {
  final Company company;
  final double planPrice;

  const CheckOutScreen(
      {super.key, required this.company, required this.planPrice});

  @override
  _CheckOutScreenState createState() => _CheckOutScreenState();
}

class _CheckOutScreenState extends State<CheckOutScreen> {
Future<void> initiatePayPalPayment(BuildContext context) async {
  const String clientId = 'Aam9--W1eErGEHOOk4QgvOdxkLpkECTs3J88-4aNvl7SeANFiLl0rg3c52NV5usNfnyS16zBB2r01hVw';
  const String secret = 'EAytscREWJZEbOMHQ1MP-0Syp3O4ATU-yjn8TMmLEhc3B2Tdl7ufC_2fpYpHtA97V59eX1WxhEzwrOJf';
  const String sandboxUrl = 'https://api-m.sandbox.paypal.com';

  try {
    // 1. Obtenha o token de acesso
    final authResponse = await http.post(
      Uri.parse('$sandboxUrl/v1/oauth2/token'),
      headers: {
        'Authorization': 'Basic ${base64Encode(utf8.encode('$clientId:$secret'))}',
        'Content-Type': 'application/x-www-form-urlencoded',
      },
      body: {'grant_type': 'client_credentials'},
    );

    if (authResponse.statusCode == 200) {
      final authData = jsonDecode(authResponse.body);
      final accessToken = authData['access_token'];

      // 2. Crie o pagamento usando o token gerado
      final double planPrice;
      switch (widget.company.plan) {
        case SubscriptionPlan.Basic:
          planPrice = 9.99 * 1.05;
          break;
        case SubscriptionPlan.Pro:
          planPrice = 19.99 * 1.05;
          break;
        case SubscriptionPlan.Premium:
          planPrice = 29.99 * 1.05;
          break;
        default:
          throw Exception("Plano inválido.");
      }

      final paymentResponse = await http.post(
        Uri.parse('$sandboxUrl/v2/checkout/orders'),
        headers: {
          'Authorization': 'Bearer $accessToken',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "intent": "CAPTURE",
          "purchase_units": [
            {
              "amount": {"currency_code": "USD", "value": planPrice.toStringAsFixed(2)}
            }
          ],
          "application_context": {
            "return_url": "https://www.paypal.com/pt/home",
            "cancel_url": "myapp://cancel",
          }
        }),
      );

      if (paymentResponse.statusCode == 201) {
        final paymentData = jsonDecode(paymentResponse.body);
        final approvalUrl = paymentData['links']
            .firstWhere((link) => link['rel'] == 'approve')['href'];

        // 3. Redirecione o usuário para o PayPal
        if (await canLaunchUrl(Uri.parse(approvalUrl))) {
          await launchUrl(Uri.parse(approvalUrl));
           // Após o pagamento bem-sucedido, redirecionar para checkEmailScreen
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) => CheckEmailScreen(company: widget.company),
              ),
            );
            print('Pagamento bem-sucedido');
        } else {
          throw Exception('Não foi possível abrir o PayPal.');
        }
      } else {
        throw Exception('Erro ao criar pagamento: ${paymentResponse.body}');
      }
    } else {
      throw Exception('Erro ao autenticar: ${authResponse.body}');
    }
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('Erro: $e')),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEEEE),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Coluna de pagamento
              Expanded(
                flex: 2,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Payment',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    const SizedBox(height: 5),
                    const Text('All transactions are secure and encrypted'),
                    const SizedBox(height: 20),
                      Container(
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        padding: const EdgeInsets.all(10),
                        child: Row(
                          children: [
                            Radio(
                              value: true,
                              groupValue: true,
                              onChanged: (value) {},
                            ),
                            const Text('PayPal', style: TextStyle(fontSize: 16)),
                            const Spacer(),
                            Image.asset(
                              'lib/images/paypal.png',
                              height: 30,
                            ),
                          ],
                        ),
                      ),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        initiatePayPalPayment(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        padding: const EdgeInsets.symmetric(vertical: 15),
                        minimumSize: const Size(double.infinity, 50),
                      ),
                      child: const Text('Pay with PayPal',
                          style: TextStyle(fontSize: 16)),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 20),
              // Resumo do pedido
              Expanded(
                flex: 1,
                child: Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade300,
                        blurRadius: 10,
                        offset: const Offset(0, 5),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${widget.company.plan.name} Plan',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text('Subtotal', style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 5),
                      Text(
                        '\$${widget.planPrice.toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 16, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 10),
                      const Text('Estimated taxes',
                          style: TextStyle(fontSize: 16)),
                      const SizedBox(height: 5),
                      Text(
                        '\$${(widget.planPrice * 0.05).toStringAsFixed(2)}',
                        style: const TextStyle(fontSize: 16),
                      ),
                      const Divider(),
                      const Text('Total',
                          style: TextStyle(
                              fontSize: 18, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(
                        '\$${(widget.planPrice * 1.05).toStringAsFixed(2)}',
                        style: const TextStyle(
                            fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      const SizedBox(height: 5),
                      Text(
                        'Including \$${(widget.planPrice * 0.05).toStringAsFixed(2)} in taxes',
                        style: const TextStyle(color: Colors.grey),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
