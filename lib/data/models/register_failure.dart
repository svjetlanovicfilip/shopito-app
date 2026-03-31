class RegisterFailure {
  final String message;

  RegisterFailure({required this.message});

  factory RegisterFailure.fromJson(Map<String, dynamic> json) {
    return RegisterFailure(message: json['message']);
  }
}
