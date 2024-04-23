import 'package:flutter/material.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';

class BlogCard extends StatefulWidget {
  final blogDetail;
  const BlogCard({super.key, required this.blogDetail});
  @override
  State<BlogCard> createState() => _BlogCardState();
}

class _BlogCardState extends State<BlogCard> {
  bool isLiked = false;
  dynamic loggedInUser;
  dynamic likes;
  dynamic blog;
  String date = "";
  String author = "";
  String profileImgUrl = "";

  @override
  void initState() {
    super.initState();
    setState(() {
      blog = widget.blogDetail;
    });
    getAuthorNameAndProfile(email: blog["email"]);
    //set likes
    print("author and profile " + " " + author + " " + profileImgUrl);
    setState(() {
      likes = blog["likes"];
      blog["author"] = author;
      blog["profileImg"] = profileImgUrl;
    });
    print(blog);
    setState(() {
      date = trimDate();
      blog["date"] = date;
    });
    checkIfLiked();
  }

  void getAuthorNameAndProfile({required String email}) async {
    final authorNameAndProfile = await FirebaseAuthService()
        .getCorrespondingNameAndProfile(email: email);
    print('Mingma ' + authorNameAndProfile["name"]);
  }

  void checkIfLiked() async {
    await getUser();
    setState(() {
      isLiked = blog["likedBy"]?.contains(loggedInUser!.email) ? true : false;
      blog["isLiked"] = isLiked;
    });
  }

  void handleLike() async {
    setState(() {
      isLiked = !isLiked;
      likes = isLiked ? likes + 1 : likes - 1;
      blog["isLiked"] = isLiked;
    });
    FirebaseAuthService().LikeBlog(
        blogId: blog["id"],
        email: loggedInUser.email,
        likes: likes,
        isLiked: isLiked);
  }

  Future<void> getUser() async {
    dynamic user = await Storage.getUser("user");
    setState(() {
      loggedInUser = user;
    });
  }

  String trimDate() {
    dynamic time = blog["createdOn"].toDate().toString();
    String year, month, date;
    List timeArr = time.split(" ")[0].split("-").toList();
    year = timeArr[0];
    switch (timeArr[1]) {
      case '01':
        month = "Jan";
        break;
      case '02':
        month = "Feb";
        break;

      case '03':
        month = "Mar";
        break;

      case '04':
        month = "Apr";
        break;

      case '05':
        month = "May";
        break;

      case '06':
        month = "June";
        break;

      case '07':
        month = "July";
        break;

      case '08':
        month = "Aug";
        break;
      case '09':
        month = "Sep";
        break;

      case '10':
        month = "Oct";
        break;

      case '11':
        month = "Nov";
        break;

      case '12':
        month = "Dec";
        break;
      default:
        month = "";
        break;
    }

    return month + " " + timeArr[2] + "," + year;
  }

  @override
  Widget build(BuildContext context) {
    return Card(
        margin: EdgeInsets.all(10),
        // color: Colors.grey,
        child: Container(
          height: 220,
          padding: EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  Image.asset(
                    "assets/logo.png",
                    width: 30,
                    height: 30,
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  Text("$author"),
                  SizedBox(
                    width: 5,
                  ),
                  Icon(
                    Icons.date_range,
                    size: 15,
                    color: Colors.grey[700],
                  ),
                  Text(
                    date,
                    style: TextStyle(
                      color: Colors.grey[700],
                    ),
                  )
                ],
              ),
              SizedBox(
                height: 10,
              ),
              GestureDetector(
                onTap: () {
                  Navigator.pushNamed(context, "/blog-view", arguments: blog);
                },
                child: Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.fromLTRB(0, 20, 0, 0),
                        height: 100,
                        // color: Colors.red,
                        child: Text(
                          blog["title"],
                          style: TextStyle(
                            fontSize: 16.0,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ),
                    Image.network(
                      'assets/logo.png',
                      width: 150,
                      height: 100,
                      fit: BoxFit.cover,
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      GestureDetector(
                        onTap: handleLike,
                        child: Icon(
                          Icons.thumb_up_alt,
                          color: isLiked ? Colors.blueAccent : Colors.grey,
                          size: 26,
                        ),
                      ),
                      SizedBox(
                        width: 5,
                      ),
                      Text(
                        "$likes",
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 18),
                      ),
                    ],
                  ),
                  // Icon(Icons.more_horiz)
                ],
              )
            ],
          ),
        ));
  }
}
