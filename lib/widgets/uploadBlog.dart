import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class UploadBlog extends StatefulWidget {
  const UploadBlog({super.key});

  @override
  State<UploadBlog> createState() => _UploadBlogState();
}

class _UploadBlogState extends State<UploadBlog> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();

  String title = "";
  String content = "";

  void handleSubmit() {
    print(titleController.value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
          child: Container(
        padding: EdgeInsets.all(20),
        // color: Colors.green,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              "UPLOAD BLOG",
              textAlign: TextAlign.center,
              style: TextStyle(fontWeight: FontWeight.w500, fontSize: 30),
            ),
            SizedBox(
              height: 30,
            ),
            Expanded(
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [
                    SizedBox(
                      height: 10,
                    ),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Title*"),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    Row(
                      children: [
                        Text(
                          "Thumbnail*:",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        OutlinedButton(
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(horizontal: 10),
                            // backgroundColor: Colors.deepPurple,
                            // foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(4),
                            ),
                          ),
                          onPressed: () {},
                          child: Row(
                            children: [
                              Icon(
                                Icons.upload_sharp,
                                size: 20,
                                color: Colors.white,
                              ),
                              const SizedBox(width: 5),
                              Text("Upload Thumbnail"),
                            ],
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 10,
                      controller: contentController,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(), labelText: "Content*"),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    ElevatedButton(
                      onPressed: handleSubmit,
                      child: Text(
                        "UPLOAD",
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          // backgroundColor:
                          // MaterialStatePropertyAll(Colors.deepPurple),
                          padding:
                              MaterialStatePropertyAll(EdgeInsets.all(25))),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }
}
