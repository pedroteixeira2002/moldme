import 'dart:convert';
import 'package:front_end_moldme/dtos/project_dto.dart';
import 'package:front_end_moldme/services/authentication_service.dart';
import 'package:http/http.dart' as http;
import 'package:front_end_moldme/dtos/offer_dto.dart';

class OfferService {
  // URL base da API
  final String baseUrl = "https://moldme-ghh9b5b9c6azgfb8.canadacentral-01.azurewebsites.net/api/offer";
  final AuthenticationService _authenticationService = AuthenticationService();

  // Enviar uma oferta
  Future<String> sendOffer(Map<String, dynamic> offerJson, String companyId, String projectId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/sendOffer?companyId=$companyId&projectId=$projectId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Usa o token obtido
      },
      body: jsonEncode(offerJson), // Enviar diretamente o mapa com os dados
    );

    if (response.statusCode == 200) {
      return "Offer sent successfully";
    } else {
      throw Exception('Failed to send offer: ${response.body}');
    }
  }

  // Aceitar uma oferta
  Future<String> acceptOffer(String companyId, String projectId, String offerId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/acceptOffer/$offerId?companyId=$companyId&projectId=$projectId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Usa o token obtido
      },
    );

    if (response.statusCode == 200) {
      return "Offer accepted successfully";
    } else {
      throw Exception('Failed to accept offer: ${response.body}');
    }
  }

  // Rejeitar uma oferta
  Future<String> rejectOffer(String companyId, String projectId, String offerId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/rejectOffer/$offerId?companyId=$companyId&projectId=$projectId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Usa o token obtido
      },
    );

    if (response.statusCode == 200) {
      return "Offer rejected successfully";
    } else {
      throw Exception('Failed to reject offer: ${response.body}');
    }
  }

  // Obter todas as ofertas de uma empresa
  Future<List<OfferDto>> getOffers(String companyId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/getOffers/$companyId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Usa o token obtido
      },
    );

    if (response.statusCode == 200) {
      // Decodifica a resposta JSON e mapeia para uma lista de OfferDto
      var offersList = jsonDecode(response.body) as List;
      return offersList.map((offer) => OfferDto.fromJson(offer)).toList();
    } else {
      throw Exception('Failed to fetch offers: ${response.body}');
    }
  }

  // Obter ofertas recebidas por uma empresa
  Future<List<OfferDto>> getReceivedOffers(String companyId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/receivedOffers/$companyId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Usa o token obtido
      },
    );

    if (response.statusCode == 200) {
      // Decodifica a resposta JSON e mapeia para uma lista de OfferDto
      var offersList = jsonDecode(response.body) as List;
      return offersList.map((offer) => OfferDto.fromJson(offer)).toList();
    } else {
      throw Exception('Failed to fetch received offers: ${response.body}');
    }
  }
  
  Future<List<ProjectDto>> getAcceptedProjectsByOffers(String companyId) async {
    final String? token = await _authenticationService.getToken();

    if (token == null) {
      throw Exception("Token not found");
    }

    final url = Uri.parse('$baseUrl/company/$companyId/accepted-offer-projects');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token', // Usa o token obtido
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((project) => ProjectDto.fromJson(project)).toList();
    } else {
      throw Exception('Failed to fetch accepted projects: ${response.body}');
    }
  }
}