import 'package:flutter/material.dart';

/// Represents a data transfer object for a company.
class CompanyDTO {
  final String name;
  final int taxId;
  final String address;
  final int contact;
  final String email;
  final String sector;
  final String plan; // SubscriptionPlan será representado como string (ou enum futuramente)
  final String password;

  CompanyDTO({
    required this.name,
    required this.taxId,
    required this.address,
    required this.contact,
    required this.email,
    required this.sector,
    required this.plan,
    required this.password,
  });

  /// Factory para criar o DTO a partir de um JSON.
  factory CompanyDTO.fromJson(Map<String, dynamic> json) {
    return CompanyDTO(
      name: json['name'],
      taxId: json['taxId'],
      address: json['address'],
      contact: json['contact'],
      email: json['email'],
      sector: json['sector'],
      plan: json['plan'], // 'plan' pode ser string ou enum
      password: json['password'],
    );
  }

  /// Método para converter o DTO para JSON.
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'taxId': taxId,
      'address': address,
      'contact': contact,
      'email': email,
      'sector': sector,
      'plan': plan,
      'password': password,
    };
  }
/*
  /// Validações simples para os campos do DTO.
  bool validate() {
    return name.isNotEmpty &&
        taxId.toString().length == 9 &&
        address.isNotEmpty &&
        contact.toString().length == 9 &&
        email.contains('@') &&
        sector.isNotEmpty &&
        password.length >= 8; // Exemplo de validação para password
  }
  */
}


