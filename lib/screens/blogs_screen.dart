import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/widgets/blogcard.dart';
import 'package:flutter_final_project/widgets/loader.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key});

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  List<Map> data = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    loadBlogs();
  }

  Future<void> loadBlogs() async {
    dynamic response = await FirebaseAuthService().getBlogs();
    setState(() {
      data = response;
      _isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: RefreshIndicator(
          onRefresh: () async {
            setState(() {
              _isLoading = true;
            });
            await loadBlogs();
          },
          child: _isLoading
              ? Center(
                  child: Loader(
                    size: 30,
                    color: Colors.deepPurple,
                  ),
                )
              : Column(
                  children: [
                    Container(
                        height: 600,
                        child: ListView.builder(
                          itemCount: data.length,
                          itemBuilder: (context, index) {
                            return BlogCard(
                              blogDetail: data[index],
                            );
                          },
                        ))
                  ],
                ),
        ),
        floatingActionButton: ElevatedButton(
          child: Icon(Icons.edit),
          onPressed: () {
            Navigator.pushNamed(context, "/upload-blog");
          },
        ));
  }
}
