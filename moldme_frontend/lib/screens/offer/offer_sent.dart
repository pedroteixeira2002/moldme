import 'package:flutter/material.dart';
import 'package:front_end_moldme/services/offer_service.dart';
import 'package:front_end_moldme/dtos/offer_dto.dart';

class SentOffersPage extends StatefulWidget {
  final String companyId;

  const SentOffersPage({Key? key, required this.companyId}) : super(key: key);

  @override
  State<SentOffersPage> createState() => _SentOffersPageState();
}

class _SentOffersPageState extends State<SentOffersPage> {
  final OfferService _offerService = OfferService();
  late Future<List<OfferDto>> _sentOffers;

  @override
  void initState() {
    super.initState();
    _fetchOffers();
  }

  void _fetchOffers() {
    setState(() {
      _sentOffers = _offerService.getOffers(widget.companyId);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Sent Offers"),
      ),
      body: FutureBuilder<List<OfferDto>>(
        future: _sentOffers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Error: ${snapshot.error}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(color: Colors.red, fontSize: 16),
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: _fetchOffers,
                    child: const Text("Retry"),
                  ),
                ],
              ),
            );
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(
              child: Text(
                'No sent offers.',
                style: TextStyle(fontSize: 16),
              ),
            );
          }

          final offers = snapshot.data!;

          return ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];
              return Card(
                margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                elevation: 3,
                child: ListTile(
                  title: Text(
                    offer.description,
                    style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 8),
                      Text("Date: ${offer.date.toIso8601String()}"),
                      Text("Status: ${offer.status}"),
                    ],
                  ),
                  onTap: () {
                    // Add navigation or actions here if needed
                  },
                ),
              );
            },
          );
        },
      ),
    );
  }
}