import 'package:flutter/material.dart';

class PlanSelectionScreen extends StatelessWidget {
  const PlanSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Título principal
              const Text(
                'Simple, transparent pricing',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              // Subtítulo
              Text(
                'Lorem ipsum dolor sit amet consectetur adipiscing elit dolor posuere vel venenatis eu sit massa volutpat.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.grey[600],
                ),
              ),
              const SizedBox(height: 32),

              // Cards de preços
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Card 1: Basic
                  PricingCard(
                    planType: 'For individuals',
                    planName: 'Basic',
                    price: '\$99',
                    description: 'Lorem ipsum dolor sit amet',
                    features: const [
                      'All analytics features',
                      'Up to 250,000 tracked visits',
                      'Normal support',
                      'Up to 3 team members',
                    ],
                    buttonText: 'Get started',
                    isPopular: false,
                  ),
                  const SizedBox(width: 16),
                  // Card 2: Pro (Popular)
                  PricingCard(
                    planType: 'For startups',
                    planName: 'Pro',
                    price: '\$199',
                    description: 'Lorem ipsum dolor sit amet',
                    features: const [
                      'All analytics features',
                      'Up to 1,000,000 tracked visits',
                      'Premium support',
                      'Up to 10 team members',
                    ],
                    buttonText: 'Get started',
                    isPopular: true,
                  ),
                  const SizedBox(width: 16),
                  // Card 3: Enterprise
                  PricingCard(
                    planType: 'For big companies',
                    planName: 'Enterprise',
                    price: '\$399',
                    description: 'Lorem ipsum dolor sit amet',
                    features: const [
                      'All analytics features',
                      'Up to 5,000,000 tracked visits',
                      'Dedicated support',
                      'Up to 50 team members',
                    ],
                    buttonText: 'Get started',
                    isPopular: false,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class PricingCard extends StatelessWidget {
  final String planType;
  final String planName;
  final String price;
  final String description;
  final List<String> features;
  final String buttonText;
  final bool isPopular;

  const PricingCard({super.key, 
    required this.planType,
    required this.planName,
    required this.price,
    required this.description,
    required this.features,
    required this.buttonText,
    this.isPopular = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          color: isPopular ? Colors.blue[50] : Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isPopular ? Colors.blue : Colors.grey.shade300,
            width: isPopular ? 2 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.grey.shade200,
              blurRadius: 8,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tag de "Popular" (apenas para o plano Pro)
            if (isPopular)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Popular',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            const SizedBox(height: 8),

            // Informações do plano
            Text(
              planType,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            Text(
              planName,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              description,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Preço
            Text(
              price,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              '/monthly',
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey[600],
              ),
            ),
            const SizedBox(height: 16),

            // Lista de features
            ...features.map(
              (feature) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4.0),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.blue,
                      size: 20,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        feature,
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Botão
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  buttonText,
                  style: const TextStyle(fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}