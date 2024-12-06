import 'dart:convert';
import 'package:front_end_moldme/dtos/project_dto.dart';
import 'package:http/http.dart' as http;
import 'package:front_end_moldme/dtos/offer_dto.dart';

class OfferService {
  // URL base da API
  final String baseUrl = "http://localhost:5213/api/offer";

  // Enviar uma oferta
  Future<String> sendOffer(Map<String, dynamic> offerJson, String companyId,
      String projectId) async {
    final url = Uri.parse(
        '$baseUrl/sendOffer?companyId=$companyId&projectId=$projectId');

    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization':
            'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiIxQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IkNvbXBhbnkiLCJleHAiOjE3MzUxNjc5MzQsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTIxMyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTIxMyJ9.7PwdTYUBjXHzMwa_UB4amJumPi-hs4ypNYaW-pK2I24',
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
  Future<String> acceptOffer(
      String companyId, String projectId, String offerId) async {
    final url = Uri.parse(
        '$baseUrl/acceptOffer/$offerId?companyId=$companyId&projectId=$projectId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer seu_token_aqui',
      },
    );

    if (response.statusCode == 200) {
      return "Offer accepted successfully";
    } else {
      throw Exception('Failed to accept offer: ${response.body}');
    }
  }

  // Rejeitar uma oferta
  Future<String> rejectOffer(
      String companyId, String projectId, String offerId) async {
    final url = Uri.parse(
        '$baseUrl/rejectOffer/$offerId?companyId=$companyId&projectId=$projectId');

    final response = await http.put(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer seu_token_aqui',
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

    final url = Uri.parse('$baseUrl/getOffers/$companyId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        // 'Authorization': 'Bearer seu_token_aqui',
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
    final url = Uri.parse('$baseUrl/receivedOffers/$companyId');

    final response = await http.get(
      url,
      headers: {
        'Content-Type': 'application/json',
        'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiIxQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IkNvbXBhbnkiLCJleHAiOjE3MzUxODg0NTYsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTIxMyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTIxMyJ9.8fQRSAlws_jP2qvOZvDIFFL7tIHcuANhsKz7WHnMhkM',
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
    final url = Uri.parse('$baseUrl/company/$companyId/accepted-offer-projects');

    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJodHRwOi8vc2NoZW1hcy54bWxzb2FwLm9yZy93cy8yMDA1LzA1L2lkZW50aXR5L2NsYWltcy9lbWFpbGFkZHJlc3MiOiIxQGdtYWlsLmNvbSIsImh0dHA6Ly9zY2hlbWFzLm1pY3Jvc29mdC5jb20vd3MvMjAwOC8wNi9pZGVudGl0eS9jbGFpbXMvcm9sZSI6IkNvbXBhbnkiLCJleHAiOjE3MzUxODg0NTYsImlzcyI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTIxMyIsImF1ZCI6Imh0dHA6Ly9sb2NhbGhvc3Q6NTIxMyJ9.8fQRSAlws_jP2qvOZvDIFFL7tIHcuANhsKz7WHnMhkM',
    });

    if (response.statusCode == 200) {
      List<dynamic> data = jsonDecode(response.body);
      return data.map((project) => ProjectDto.fromJson(project)).toList();
    } else {
      throw Exception('Failed to fetch accepted projects: ${response.body}');
    }
  }
}