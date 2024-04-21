class MyUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final bool isAdmin;
  final String? profilePic;

  MyUser(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.isAdmin,
      this.profilePic});

  Map<String, dynamic> toJson() => {
        'id': id,
        'firstName': firstName,
        'lastName': lastName,
        'email': email,
        'isAdmin': isAdmin,
        'profilePic': profilePic ?? '',
      };

  factory MyUser.fromJson(Map<String, dynamic> json) => MyUser(
        id: json['id'] as String,
        firstName: json['firstName'] as String,
        lastName: json['lastName'] as String,
        email: json['email'] as String,
        isAdmin: json['isAdmin'] as bool,
        profilePic: json['profilePic'] as String?,
      );
}
