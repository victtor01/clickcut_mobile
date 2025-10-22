class User {
  final String? id;
  final String username;
  final String email;
  final String? photoUrl;

  const User({
    this.id,
    this.photoUrl,
    required this.username,
    required this.email,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      email: json['email'] ?? '',
      username: json['username'] ?? '',
      id: json['id'] ?? '',
      photoUrl: json['photoUrl'] ?? '',
    );
  }
}
