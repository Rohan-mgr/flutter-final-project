import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_final_project/helper/storage.dart';

class BlogView extends StatefulWidget {
  const BlogView({super.key});

  @override
  State<BlogView> createState() => _BlogViewState();
}

class _BlogViewState extends State<BlogView> {
  bool isLiked = false;
  dynamic loggedInUser;
  @override
  void initState() {
    super.initState();
  }

  Future<void> getUser() async {
    dynamic user = await Storage.getUser("user");
    setState(() {
      loggedInUser = user;
    });
  }

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;

    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          ListView(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Image.network(
                      data["imgUrl"],
                      width: 400,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Container(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      padding: EdgeInsets.only(right: 10, top: 10),
                      child: Wrap(
                        children: [
                          Expanded(
                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  vertical: 10, horizontal: 20),
                              width: 500,
                              child: Text(
                                data["title"],
                                style: TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                                maxLines: 3,
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                        height: 60,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(children: [
                              Container(
                                width: 50,
                                height: 50,
                                clipBehavior: Clip.antiAlias,
                                decoration:
                                    BoxDecoration(shape: BoxShape.circle),
                                child: Image.network(data["profileImgUrl"],
                                    fit: BoxFit.cover),
                              ),
                              SizedBox(
                                width: 10,
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    data["author"],
                                    style: TextStyle(
                                      fontWeight: FontWeight.w500,
                                      fontSize: 14,
                                    ),
                                  ),
                                  Text(data["date"],
                                      style: TextStyle(
                                          fontWeight: FontWeight.w300,
                                          fontSize: 12))
                                ],
                              ),
                            ]),
                          ],
                        )),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: Wrap(
                    children: [
                      Text(
                        data["content"],
                        style: TextStyle(fontSize: 15),
                      )
                    ],
                  ),
                ),
              )
            ],
          ),
          // Positioned(
          //     top: 280,
          //     left: 0,
          //     right: 0,
          //     child: Container(
          //       decoration: BoxDecoration(
          //         borderRadius: BorderRadius.only(
          //             topLeft: Radius.circular(50),
          //             topRight: Radius.circular(50)),
          //         color: Colors.red,
          //       ),
          //       height: 30,
          //     ))
        ],
      ),
    );
  }
}
