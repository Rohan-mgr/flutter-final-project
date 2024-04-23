import 'dart:io';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:flutter_final_project/screens/home_screen.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:form_validator/form_validator.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';

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
  File? filePath = null;
  String? fileName = null;
  bool isFileSelected = false;
  bool isSubmitting = false;

  void handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        title = titleController.text;
        content = contentController.text;
        isSubmitting = true;
      });
      try {
        await FirebaseAuthService().uploadBlogToFirebase(
            filepath: filePath!,
            title: title,
            content: content,
            fileName: fileName!);

        setState(() {
          isSubmitting = false;
        });

        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              initialBreadCrumbs: [],
              bottomNavigationIndex: getSeletedTabIndex("Blogs"),
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } catch (err) {
        print(err);
      }
    }
  }

  void ThumbnailPicker() async {
    try {
      FilePickerResult? result = await FilePicker.platform
          .pickFiles(type: FileType.custom, allowedExtensions: [
        "png",
        "jpeg",
        "jpg",
      ]);
      if (result == null) return;
      File file = File(result.files.single.path!);

      setState(() {
        filePath = file;
        isFileSelected = true;
        fileName = result.files.single.name;
      });
      print(filePath);
    } catch (error) {
      print(error);
    }
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
                    Row(
                      children: [
                        Text(
                          "Thumbnail*:",
                          style: TextStyle(fontSize: 18),
                        ),
                        SizedBox(
                          width: 20,
                        ),
                        isFileSelected
                            ? Expanded(
                                child: OutlinedButton(
                                  style: OutlinedButton.styleFrom(
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 10),
                                    backgroundColor: Colors.red[500],
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                  ),
                                  onPressed: () {
                                    setState(() {
                                      isFileSelected = false;
                                      filePath = null;
                                    });
                                  },
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          fileName!,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      Icon(Icons.backspace_sharp)
                                    ],
                                  ),
                                ),
                              )
                            : OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  backgroundColor: Colors.deepPurple,
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                ),
                                onPressed: ThumbnailPicker,
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
                    Text('Title*:'),
                    TextFormField(
                      controller: titleController,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                      validator: ValidationBuilder().required().build(),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Text('Content*:'),
                    TextFormField(
                      keyboardType: TextInputType.multiline,
                      maxLines: null,
                      minLines: 9,
                      controller: contentController,
                      validator: ValidationBuilder().required().build(),
                      decoration: InputDecoration(
                        border: OutlineInputBorder(),
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ElevatedButton(
                      onPressed: () {
                        !isSubmitting ? handleSubmit() : "";
                      },
                      child: isSubmitting
                          ? Loader(
                              size: 30,
                              color: Colors.black,
                            )
                          : Text(
                              "UPLOAD",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 18),
                            ),
                      style: ButtonStyle(
                          shape: MaterialStatePropertyAll(
                              RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(15))),
                          backgroundColor:
                              MaterialStatePropertyAll(Colors.deepPurple),
                          padding:
                              MaterialStatePropertyAll(EdgeInsets.all(20))),
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
