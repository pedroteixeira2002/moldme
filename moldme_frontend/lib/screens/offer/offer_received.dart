import 'package:flutter/material.dart';
import 'package:front_end_moldme/services/offer_service.dart';
import 'package:front_end_moldme/dtos/offer_dto.dart';

class ReceivedOffersPage extends StatefulWidget {
  final String companyId;

  const ReceivedOffersPage({Key? key, required this.companyId})
      : super(key: key);

  @override
  _ReceivedOffersPageState createState() => _ReceivedOffersPageState();
}

class _ReceivedOffersPageState extends State<ReceivedOffersPage> {
  final OfferService _offerService = OfferService();
  late Future<List<OfferDto>> _receivedOffers;

  @override
  void initState() {
    super.initState();
    _receivedOffers = _offerService.getReceivedOffers(widget.companyId);
  }

  String mapStatus(int status) {
    switch (status) {
      case 0:
        return "NEW";
      case 1:
        return "IN PROGRESS";
      case 2:
        return "DONE";
      case 3:
        return "CLOSED";
      case 4:
        return "CANCELED";
      case 5:
        return "PENDING";
      case 6:
        return "ACCEPTED";
      case 7:
        return "DENIED";
      default:
        return "UNKNOWN";
    }
  }

  Future<void> _handleOfferAction(
      String projectId, String offerId, bool accept) async {
    try {
      final message = accept
          ? await _offerService.acceptOffer(
              widget.companyId, projectId, offerId)
          : await _offerService.rejectOffer(
              widget.companyId, projectId, offerId);
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(message)));
      setState(() {
        _receivedOffers = _offerService.getReceivedOffers(widget.companyId);
      });
    } catch (e) {
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text('Error: $e')));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Received Offers"),
      ),
      body: FutureBuilder<List<OfferDto>>(
        future: _receivedOffers,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No received offers.'));
          }

          final offers = snapshot.data!;

          return ListView.builder(
            itemCount: offers.length,
            itemBuilder: (context, index) {
              final offer = offers[index];

              final description =
                  offer.description ?? 'No description available';
              final status = offer.status != null
                  ? mapStatus(offer.status as int)
                  : 'UNKNOWN';
              final date = offer.date != null
                  ? offer.date.toIso8601String()
                  : 'Unknown date';

              return Card(
                child: ListTile(
                  title: Text(description),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Date: $date"),
                      Text("Status: $status"),
                    ],
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.check, color: Colors.green),
                        onPressed: () => _handleOfferAction(
                            offer.projectId, offer.offerId, true),
                      ),
                      IconButton(
                        icon: const Icon(Icons.close, color: Colors.red),
                        onPressed: () => _handleOfferAction(
                            offer.projectId, offer.offerId, false),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
