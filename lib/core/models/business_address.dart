class BusinessAddress {
  final String street;
  final String number;
  final String neighborhood;
  final String city;
  final String state;
  final String postalCode;
  final String? complement;

  BusinessAddress({
    required this.street,
    required this.number,
    required this.neighborhood,
    required this.city,
    required this.state,
    required this.postalCode,
    this.complement,
  });

  factory BusinessAddress.fromJson(Map<String, dynamic> json) {
    return BusinessAddress(
      street: json['street'] as String,
      number: json['number'] as String,
      neighborhood: json['neighborhood'] as String,
      city: json['city'] as String,
      state: json['state'] as String,
      postalCode: json['postalCode'] as String,
      complement: json['complement'] as String?,
    );
  }
}
