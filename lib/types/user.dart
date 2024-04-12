class MyUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;

  MyUser({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
      };

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
      );
}
