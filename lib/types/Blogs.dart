class Blog {
  String title;
  String content;
  String imgUrl;
  String user; //email
  int likes = 0;
  Blog(
      {required this.title,
      required this.content,
      required this.imgUrl,
      required this.user});

  Map<String, dynamic> toJson() => {
        'title': title,
        'content': content,
        'imgUrl': imgUrl,
        'user': user,
        'likes': likes
      };
}
