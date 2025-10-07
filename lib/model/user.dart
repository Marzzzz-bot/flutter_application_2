class User {
  final String id;
  final String nama;
  final String email;
  final String role; // contoh: "admin" atau "staff"

  User({
    required this.id,
    required this.nama,
    required this.email,
    required this.role,
  });

  // Dari JSON ke User
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      nama: json['nama'],
      email: json['email'],
      role: json['role'],
    );
  }

  // Dari User ke JSON
  Map<String, dynamic> toJson() {
    return {'id': id, 'nama': nama, 'email': email, 'role': role};
  }
}
