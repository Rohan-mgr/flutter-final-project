class UserProfile {
  final String downloadUrl;
  final String fullStoragePath;

  UserProfile({required this.downloadUrl, required this.fullStoragePath});

  Map<String, dynamic> toJson() => {
        'downloadUrl': downloadUrl,
        'fullStoragePath': fullStoragePath,
      };

  factory UserProfile.fromJson(Map<String, dynamic> json) => UserProfile(
        downloadUrl: json['downloadUrl'] as String,
        fullStoragePath: json['fullStoragePath'] as String,
      );
}
