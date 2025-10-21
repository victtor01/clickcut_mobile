import 'package:clickcut_mobile/core/models/business_address.dart';
import 'package:clickcut_mobile/features/auth/domain/entities/user.dart';

class Business {
  final String id;
  final String name;
  final BusinessAddress? address;
  final String? bannerUrl;
  final String? logoUrl;
  final bool hasPassword;
  final User? owner;
  // final List<Service>? services;
  // final List<User>? members;

  Business({
    required this.id,
    required this.name,
    this.address,
    this.bannerUrl,
				this.owner,
    this.logoUrl,
    this.hasPassword = false,
  });

  factory Business.fromJson(Map<String, dynamic> json) {
    bool passwordCheck = false;
    if (json['hasPassword'] != null) {
      if (json['hasPassword'] is bool) {
        passwordCheck = json['hasPassword'];
      } else if (json['hasPassword'] is num) {
        passwordCheck = (json['hasPassword'] as num) != 0;
      }
    }

    // PASSO 3: Verifique se o endereço existe ANTES de tentar ler
    final addressData = json['address'] as Map<String, dynamic>?;

    return Business(
      id: json['id'] as String,
      name: json['name'] as String,
      // PASSO 4: Use a variável verificada
      address: addressData != null ? BusinessAddress.fromJson(addressData) : null,
      bannerUrl: json['bannerUrl'] as String?,
      logoUrl: json['logoUrl'] as String?,
      hasPassword: passwordCheck,
    );
  }
}