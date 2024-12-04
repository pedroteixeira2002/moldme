import 'package:flutter/material.dart';
import 'package:front_end_moldme/models/company.dart';
import 'package:front_end_moldme/models/subscriptionPlan.dart';
import 'package:front_end_moldme/screens/register/checkEmailScreen.dart';
import 'package:front_end_moldme/screens/register/checkOutScreen.dart';

class PlanSelectionScreen extends StatefulWidget {
  final Company company;

  const PlanSelectionScreen({super.key, required this.company});

  @override
  _PlanSelectionScreenState createState() => _PlanSelectionScreenState();
}

class _PlanSelectionScreenState extends State<PlanSelectionScreen> {
  final _formKey = GlobalKey<FormState>();

  // Handle plan selection
  Future<void> _selectPlan(BuildContext context, String plan) async {
    double planPrice;

    switch (plan) {
      case 'Free':
        widget.company.plan = SubscriptionPlan.Free; // Ajuste conforme o tipo do atributo `plan` no modelo Company.
        planPrice = 0.00;
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CheckEmailScreen(company: widget.company)),
        );
        break;

      case 'Basic':
        widget.company.plan = SubscriptionPlan.Basic; // Ou 0, dependendo do tipo do atributo `plan`.
        planPrice = 9.99;
        // TODO: Redirecionar para página de pagamento no futuro.
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CheckOutScreen(company: widget.company, planPrice: planPrice)),
        );
        break;

      case 'Pro':
        widget.company.plan = SubscriptionPlan.Pro; // Ou 1, dependendo do tipo do atributo `plan`.
        planPrice = 19.99;
        // TODO: Redirecionar para página de pagamento no futuro.
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CheckOutScreen(company: widget.company, planPrice: planPrice,)),
        );
        break;

      case 'Premium':
        widget.company.plan = SubscriptionPlan.Premium; // Ou 2, dependendo do tipo do atributo `plan`.
        planPrice = 29.99;
        // TODO: Redirecionar para página de pagamento no futuro.
         Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CheckOutScreen(company: widget.company, planPrice: planPrice)),
        );
        break;

      default:
        throw Exception("Plano inválido selecionado");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 32),
              const Text(
                "PRICING",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.blueGrey,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "Simple, transparent pricing",
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                "Lorem ipsum dolor sit amet consectetur adipiscing elit dolor posuere vel venenatis eu sit massa volutpat.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 32),
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    PricingCard(
                      title: "Free",
                      price: "\$0.00",
                      description: "For individuals",
                      features: const [
                        "All analytics features",
                        "Up to 100,000 tracked visits",
                        "Standard support",
                        "1 team member",
                      ],
                      isPopular: false,
                      buttonColor: Colors.blue,
                      onPressed: () => _selectPlan(context, SubscriptionPlan.Free.name),
                    ),
                    const SizedBox(width: 16),
                    PricingCard(
                      title: "Basic",
                      price: "\$9.99",
                      description: "For individuals",
                      features: const [
                        "All analytics features",
                        "Up to 250,000 tracked visits",
                        "Standard support",
                        "Up to 3 team members",
                      ],
                      isPopular: false,
                      buttonColor: Colors.blue,
                      onPressed: () => _selectPlan(context, SubscriptionPlan.Basic.name),
                    ),
                    const SizedBox(width: 16),
                    PricingCard(
                      title: "Pro",
                      price: "\$19.99",
                      description: "For startups",
                      features: const [
                        "All analytics features",
                        "Up to 1,000,000 tracked visits",
                        "Premium support",
                        "Up to 10 team members",
                      ],
                      isPopular: true,
                      buttonColor: Colors.purple,
                      onPressed: () => _selectPlan(context, SubscriptionPlan.Pro.name),
                    ),
                    const SizedBox(width: 16),
                    PricingCard(
                      title: "Premium",
                      price: "\$29.99",
                      description: "For large companies",
                      features: const [
                        "All analytics features",
                        "Up to 5,000,000 tracked visits",
                        "Dedicated support",
                        "Up to 50 team members",
                      ],
                      isPopular: false,
                      buttonColor: Colors.blue,
                      onPressed: () => _selectPlan(context, SubscriptionPlan.Premium.name),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PricingCard extends StatelessWidget {
  final String title;
  final String price;
  final String description;
  final List<String> features;
  final bool isPopular;
  final Color buttonColor;
  final VoidCallback onPressed;

  const PricingCard({
    super.key,
    required this.title,
    required this.price,
    required this.description,
    required this.features,
    required this.isPopular,
    required this.buttonColor,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: isPopular ? Colors.purple.withOpacity(0.1) : Colors.white,
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (isPopular)
                Center(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: Colors.purple,
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: const Text(
                      "Popular",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              const SizedBox(height: 8),
              Text(
                description,
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                price,
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text("What's included"),
              const SizedBox(height: 16),
              ...features.map(
                (feature) => Row(
                  children: [
                    const Icon(Icons.check, color: Colors.blue, size: 16),
                    const SizedBox(width: 8),
                    Text(
                      feature,
                      style: const TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),
              const Spacer(),
              Center(
                child: ElevatedButton(
                  onPressed: onPressed,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: buttonColor,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    "Select Plan",
                    style: TextStyle(color: Colors.white),
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
