class User {
  final String? id;
  final String name;
  final String email;

  const User({
    this.id,
    required this.name,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        email: json['email'] ?? '',
        name: json['name'] ?? '',
        id: json['id'] ?? '');
  }
}
