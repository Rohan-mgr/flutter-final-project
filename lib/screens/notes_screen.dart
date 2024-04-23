import 'package:flutter/material.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/screens/home_screen.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:flutter_final_project/widgets/Modal.dart';
import 'package:flutter_final_project/widgets/breadcrumbs.dart';
import 'package:file_picker/file_picker.dart';
import "dart:io";
import 'package:flutter_final_project/widgets/centraltextloader.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:flutter_final_project/widgets/popUpMenu.dart';

class Notes extends StatefulWidget {
  final List<String>? initialBreadCrumbs;
  const Notes({super.key, this.initialBreadCrumbs});

  @override
  State<Notes> createState() => _NotesState();
}

class _NotesState extends State<Notes> {
  List<dynamic> folders = [];
  List<String> breadCrumbs = [];
  bool _isLoading = false;
  List<dynamic> selectedItems = [];
  MyUser? user;

  @override
  void initState() {
    super.initState();
    if (widget.initialBreadCrumbs != null) {
      breadCrumbs = List<String>.from(widget.initialBreadCrumbs!);
    }
    loadUserFromLocalStorage();
    getFilesAndFolders("Notes");
  }

  Future<void> loadUserFromLocalStorage() async {
    try {
      final loggedUser = await Storage.getUser("user");
      if (loggedUser != null) {
        setState(() {
          user = loggedUser;
        });
      }
    } catch (error) {
      print('Error retrieving user: $error');
    }
  }

  Future<void> getFilesAndFolders(String folderName) async {
    try {
      setState(() {
        _isLoading = true;
      });
      // initially add Notes to the breadcrumbs
      if (breadCrumbs.length < 1) {
        breadCrumbs.add(folderName);
      }

      final folderPath = breadCrumbs.join("/");
      final foldersName =
          await FirebaseAuthService().listFoldersAndFiles(folderPath);
      setState(() {
        folders = foldersName;
        _isLoading = false;
      });
    } catch (error) {
      print("Error getting files: $error");
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleFileSelection() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.custom,
      allowedExtensions: [
        'pdf',
        'doc',
        'jpg',
        'docx',
        'ppt',
        'pptx',
        'jpeg',
        'txt',
        'mp3',
        'mp4',
        'png'
      ],
    );

    if (result != null) {
      List<File> files = result.files.map((file) => File(file.path!)).toList();

      bool allUploadsSuccessful = true; // Flag to track upload status
      int uploadedFiles = 0;
      int totalFiles = files.length;

      for (File file in files) {
        try {
          showDialog(
            context: context,
            barrierDismissible:
                false, // Prevent user from dismissing the dialog by tapping outside
            builder: (context) {
              return Center(
                child: Container(
                  padding: EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize
                        .min, // Prevent dialog from expanding unnecessarily
                    children: [
                      CenterTextCircularProgressIndicator(
                        value: uploadedFiles / totalFiles,
                        text: '$uploadedFiles/$totalFiles',
                        progressColor: const Color.fromARGB(255, 230, 223, 223),
                      ),
                      const SizedBox(height: 10), // Add some spacing
                      Text('Uploading files... Please wait.',
                          style: TextStyle(color: Colors.black)),
                    ],
                  ),
                ),
              );
            },
          );

          String folderPath = breadCrumbs.join("/");
          await FirebaseAuthService().uploadFileToFirebase(file, folderPath);
          uploadedFiles++;
          Navigator.of(context).pop();
        } catch (error) {
          print('Error uploading file "${file.path.split('/').last}": $error');
          allUploadsSuccessful = false; // Mark upload failure
          break; // Exit the loop on error to prevent unnecessary attempts
        }
      }

      if (allUploadsSuccessful) {
        // All files uploaded successfully, navigate to Home route
        Navigator.pop(context);
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => Home(
              initialBreadCrumbs: breadCrumbs,
              bottomNavigationIndex: getSeletedTabIndex(breadCrumbs[0]),
            ),
          ),
          (Route<dynamic> route) => false,
        );
      } else {
        // Inform the user about upload failures
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Some files failed to upload.'),
          ),
        );
      }
    } else {
      // User canceled the picker
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Please select atleast 1 file'),
      ));
    }
  }

  void handleSelectedItem() async {
    try {
      showDialog(
          context: context,
          barrierDismissible: false,
          builder: (context) {
            return Center(
              child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                padding: EdgeInsets.symmetric(horizontal: 20, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Loader(size: 30, color: Colors.red),
                    SizedBox(height: 20),
                    Text('Removing file... Please wait.'),
                  ],
                ),
              ),
            );
          });
      for (dynamic file in selectedItems) {
        String fileType = file?['type'];
        String filePath = file?['fullPath'];
        if (fileType == 'folder') {
          await FirebaseAuthService().deleteFolder(filePath);
        } else {
          await FirebaseAuthService().deleteFile(filePath);
        }
      }
      setState(() {
        selectedItems = [];
      });
      Navigator.of(context).pop();
      getFilesAndFolders("Notes");
    } catch (e) {
      print("Error deleting files: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              padding: EdgeInsets.only(top: 15, bottom: 0, left: 15, right: 15),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(horizontal: 10),
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                    ),
                    onPressed: handleFileSelection,
                    child: Row(
                      children: [
                        Icon(
                          Icons.upload_sharp,
                          size: 20,
                          color: Colors.white,
                        ),
                        const SizedBox(width: 5),
                        Text("Upload file"),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) => Modal(
                          breadCrumbs: breadCrumbs,
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.create_new_folder_rounded,
                      size: 40,
                      color: Colors.deepPurple,
                    ),
                  ),
                ],
              ),
            ),
            Breadcrumbs(
              breadCrumbs: breadCrumbs,
              onBreadcrumbTap: (index) {
                int removeIndex = index;
                breadCrumbs.removeRange(removeIndex + 1, breadCrumbs.length);
                getFilesAndFolders(breadCrumbs[index]);
              },
            ),
            if (user != null && user!.isAdmin)
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(
                    width: 5,
                  ),
                  if (folders.length > 0)
                    Row(
                      children: [
                        Checkbox(
                          visualDensity: VisualDensity.compact,
                          value: selectedItems.length == folders.length
                              ? true
                              : false,
                          onChanged: (bool? value) {
                            setState(() {
                              if (value!) {
                                setState(() {
                                  selectedItems = [...folders];
                                });
                              } else {
                                setState(() {
                                  selectedItems = [];
                                });
                              }
                            });
                          },
                        ),
                        Text(
                          "Select All",
                          style: TextStyle(
                              fontSize: 15,
                              color: Color.fromARGB(255, 80, 79, 79)),
                        ),
                      ],
                    ),
                  Spacer(),
                  selectedItems.length > 0
                      ? SizedBox(
                          width: 90,
                          child: OutlinedButton(
                            style: OutlinedButton.styleFrom(
                              padding: EdgeInsets.symmetric(horizontal: 10),
                              backgroundColor: Colors.red[400],
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(4),
                              ),
                              side: BorderSide(color: Colors.red, width: 0.0),
                            ),
                            onPressed: handleSelectedItem,
                            child: Row(
                              children: [
                                Icon(
                                  Icons.delete,
                                  size: 20,
                                  color: Colors.white,
                                ),
                                const SizedBox(width: 5),
                                Text("Delete"),
                              ],
                            ),
                          ),
                        )
                      : Container(),
                  SizedBox(width: 10),
                ],
              ),
            _isLoading
                ? Positioned(
                    top: 50,
                    child: Center(
                      child: Loader(
                        size: 35,
                        color: Colors.deepPurple,
                      ),
                    ),
                  )
                : Expanded(
                    child: folders.length != 0
                        ? ListView.builder(
                            itemBuilder: (BuildContext context, int index) {
                              dynamic item = folders[index];
                              bool isSelected = selectedItems.contains(item);
                              return Column(
                                children: [
                                  Container(
                                    // padding: EdgeInsets.all(0),
                                    margin: EdgeInsets.only(
                                        left: 5, right: 5, top: 2, bottom: 2),
                                    color: Color.fromRGBO(240, 238, 247, 1),
                                    child: ListTile(
                                      contentPadding: EdgeInsets.zero,
                                      leading: user!.isAdmin
                                          ? Checkbox(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              value: isSelected,
                                              onChanged: (bool? value) {
                                                setState(() {
                                                  if (value!) {
                                                    selectedItems.add(item);
                                                  } else {
                                                    selectedItems.remove(item);
                                                  }
                                                });
                                              },
                                            )
                                          : null,
                                      title: Transform.translate(
                                        offset: user!.isAdmin
                                            ? Offset(-20, 0)
                                            : Offset(10, 0),
                                        child: Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          children: [
                                            (item['type'] == 'folder')
                                                ? Container(
                                                    margin: EdgeInsets.only(
                                                        right: 10),
                                                    child: Icon(
                                                      Icons.folder,
                                                      color: Colors.deepPurple,
                                                      size: 32,
                                                    ),
                                                  )
                                                : getCustomIcon(
                                                    item['mimeType']),
                                            // Container(
                                            //     margin: EdgeInsets.only(
                                            //         right: 10),
                                            //     child: Icon(
                                            //       Icons.insert_drive_file,
                                            //       color: Colors.deepPurple,
                                            //       size: 32,
                                            //     ),
                                            //   ),
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Container(
                                                  child: Text(
                                                    truncateFilename(
                                                        item['name']),
                                                  ),
                                                ),
                                                if (item['type'] == 'file')
                                                  Row(
                                                    children: [
                                                      Icon(
                                                          Icons
                                                              .cloud_done_outlined,
                                                          size: 17,
                                                          color: Colors.grey),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Text(
                                                          item['fileSize'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Icon(
                                                          Icons
                                                              .access_time_sharp,
                                                          size: 16,
                                                          color: Colors.grey),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Text(
                                                          item['createdAt'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                      SizedBox(width: 5),
                                                      Icon(
                                                          Icons
                                                              .person_2_outlined,
                                                          size: 16,
                                                          color: Colors.grey),
                                                      Padding(
                                                        padding:
                                                            EdgeInsets.only(
                                                                left: 5),
                                                        child: Text(
                                                          item['uploadedBy'],
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                              ],
                                            ),
                                            Spacer(),
                                            if (item['type'] == 'file')
                                              PopUpMenu(
                                                file: item,
                                                breadCrumbs: breadCrumbs,
                                              ),
                                          ],
                                        ),
                                      ),
                                      onTap: () async {
                                        if (item['type'] == 'folder') {
                                          breadCrumbs.add(item['name']);
                                          setState(() {});
                                          await getFilesAndFolders(
                                              item['name']);
                                          setState(() {});
                                        } else {
                                          // Handle file tap
                                          handlePreviewFile(context, item);
                                        }
                                      },
                                    ),
                                  ),
                                ],
                              );
                            },
                            itemCount: folders.length,
                            shrinkWrap: true,
                            scrollDirection: Axis.vertical,
                            physics: ClampingScrollPhysics())
                        : Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Text("There is no files here yet"),
                            ],
                          ),
                  ),
          ],
        ),
      ),
    );
  }
}
