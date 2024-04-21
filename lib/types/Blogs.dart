import 'package:cloud_firestore/cloud_firestore.dart';

class Blog {
  String title;
  String content;
  String imgUrl;
  String user; //email
  Timestamp createdOn;
  List likedBy;
  int likes = 0;
  Blog(
      {required this.title,
      required this.content,
      required this.imgUrl,
      required this.user,
      required this.createdOn,
      this.likedBy = const []});

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'imgUrl': imgUrl,
        'user': user,
        'likes': likes,
        'likedBy': likedBy,
        'createdOn': createdOn
      };
}
