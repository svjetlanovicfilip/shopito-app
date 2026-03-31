class User {
  final int? id;
  final String email;
  final String? password;
  final String fullname;
  final String phone;
  final String? role;

  User({
    this.id,
    required this.email,
    this.password,
    required this.fullname,
    required this.phone,
    this.role,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
      fullname: json['fullname'],
      phone: json['phoneNumber'],
      role: json['roleName'] ?? Map<String, dynamic>.from(json['role'])['name'],
    );
  }

  factory User.fromJsonAdmin(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      fullname: json['fullname'],
      phone: json['phoneNumber'],
      role: json['roleName'] ?? Map<String, dynamic>.from(json['role'])['name'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'fullname': fullname,
      'phoneNumber': phone,
    };
  }
}
