import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/types/profile.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:flutter_final_project/widgets/changePasswordModal.dart';
import 'package:flutter_final_project/widgets/editNameModal.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:flutter_final_project/widgets/popUpMenu.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  MyUser? user;
  String userProfileUrl = "";
  String updatedUserName = "";
  bool _isProfileUpdating = false;
  bool _isLoading = false;
  int downloadCount = 0;
  List<dynamic> favourites = [];
  File? profilePicFile;
  List<dynamic> selectedItems = [];

  @override
  void initState() {
    super.initState();
    loadUserFromLocalStorage();
  }

  Future<void> loadUserFromLocalStorage() async {
    try {
      final loggedUser = await Storage.getUser("user");
      if (loggedUser != null) {
        setState(() {
          user = loggedUser;
          userProfileUrl = loggedUser.profilePic!;
        });
        await getFavoritesList();
        await getDownloadCount();
      }
    } catch (error) {
      print('Error retrieving user: $error');
    }
  }

  Future<void> loadUserProfileUrl() async {
    try {
      final loggedUser = await Storage.getUser("user");
      if (loggedUser != null) {
        setState(() {
          userProfileUrl = loggedUser.profilePic!;
        });
      }
    } catch (error) {
      print('Error retrieving user profile url: $error');
    }
  }

  Future<void> loadNewUserName() async {
    try {
      final loggedUser = await Storage.getUser("user");
      if (loggedUser != null) {
        setState(() {
          updatedUserName = loggedUser.firstName + " " + loggedUser.lastName;
        });
      }
    } catch (error) {
      print('Error retrieving user profile url: $error');
    }
  }

  Future<void> getFavoritesList() async {
    print("logged user  = ${user.toString()}");
    if (user == null) return;
    try {
      setState(() {
        _isLoading = true;
      });
      final favouritesList =
          await FirebaseAuthService().listFavouriteFiles(user?.id);
      setState(() {
        favourites = favouritesList;
        _isLoading = false;
      });
    } catch (e) {
      print('Error getting favorites: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<void> getDownloadCount() async {
    if (user == null) return;
    try {
      setState(() {
        _isLoading = true;
      });
      final userDownloadCount =
          await FirebaseAuthService().getUserDownloadCount(user?.id);
      setState(() {
        downloadCount = userDownloadCount;
        _isLoading = false;
      });
    } catch (e) {
      print('Error getting download count: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  void handleProfilePicSelection() async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['jpg', 'jpeg', 'png'],
      );

      if (result != null) {
        setState(() {
          profilePicFile = File(result.files.single.path!);
        });
        setState(() {
          _isProfileUpdating = true;
        });
        UserProfile? userProfile = await FirebaseAuthService()
            .uploadFileToFirebase(profilePicFile!, "profile", true);
        if (userProfile == null) {
          throw "Error uploading profile picture";
        }
        MyUser? userData = await FirebaseAuthService()
            .updateUserProfilePicture(user?.id, userProfile);

        await Storage.setUser("user", userData!);
        await loadUserProfileUrl();
        setState(() {
          _isProfileUpdating = false;
        });
      } else {
        setState(() {
          _isProfileUpdating = false;
        });
        // User canceled the picker
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select photo to upload.'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isProfileUpdating = false;
      });
      throw e;
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
                    Text('Removing favourite file... Please wait.'),
                  ],
                ),
              ),
            );
          });
      for (dynamic file in selectedItems) {
        print("favourite file =>>>>>>>>>>> ${file?.toString()}");
        await FirebaseAuthService()
            .removeFilesFromFavouriteList(file?['documentId']);
      }
      setState(() {
        selectedItems = [];
      });
      Navigator.of(context).pop();
      getFavoritesList();
    } catch (e) {
      print("Error deleting favourite files: $e");
      throw e;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 320,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 270,
                        decoration: BoxDecoration(
                          color: Colors.deepPurple,
                        ),
                        child: Stack(
                          children: [
                            Positioned(
                              top: 5,
                              right: 0,
                              child: OutlinedButton(
                                onPressed: () async {
                                  await Storage.remove('user');
                                  await GoogleSignIn().signOut();
                                  Navigator.popAndPushNamed(context, "/login");
                                },
                                style: OutlinedButton.styleFrom(
                                  shape: CircleBorder(),
                                  padding: EdgeInsets.all(5),
                                  side: BorderSide(
                                      color: Colors.white,
                                      width: 2), // Adjust width as needed
                                ),
                                child: Icon(
                                  Icons.logout,
                                  size: 22,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Stack(
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(top: 25.0),
                                        child: ClipOval(
                                          child: userProfileUrl == ""
                                              ? Icon(
                                                  Icons.account_circle_rounded,
                                                  color: Colors.white,
                                                  size: 120,
                                                )
                                              : Image.network(
                                                  userProfileUrl,
                                                  width: 120.0,
                                                  height: 120.0,
                                                  fit: BoxFit.cover,
                                                ),
                                        ),
                                      ),

                                      // Edit button positioned on bottom right of profile picture
                                      Positioned(
                                        bottom: 0.0,
                                        right: -10.0,
                                        child: ElevatedButton(
                                          onPressed: handleProfilePicSelection,
                                          child: !_isProfileUpdating
                                              ? Icon(Icons.camera_alt)
                                              : Loader(
                                                  size: 20,
                                                  color: Colors.deepPurple),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(8.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Container(
                                        margin: EdgeInsets.only(
                                          left: !_isProfileUpdating ? 70 : 0,
                                        ),
                                        child: Text(
                                          // "${user?.firstName} ${user?.lastName}",
                                          '${updatedUserName != '' ? updatedUserName : '${user?.firstName} ${user?.lastName}'}',
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontWeight: FontWeight.bold,
                                              fontSize: 22),
                                        ),
                                      ),
                                      if (!_isProfileUpdating)
                                        ElevatedButton(
                                          onPressed: () {
                                            print("edit icon click");
                                            showDialog(
                                                context: context,
                                                builder: (context) =>
                                                    EditProfileDialog(
                                                      user: user!,
                                                      refreshLocalStorage:
                                                          loadNewUserName,
                                                    ));
                                          },
                                          child: Icon(Icons.edit,
                                              size: 20, color: Colors.white),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            backgroundColor: Colors.transparent,
                                            shadowColor: Colors.transparent,
                                          ),
                                        ),
                                    ],
                                  ),
                                  Text(
                                    "${user?.email}",
                                    style: TextStyle(
                                      color: Color.fromARGB(255, 204, 197, 197),
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 215,
                    left: 30,
                    right: 30,
                    child: Center(
                      child: Container(
                        height: 90,
                        width: 350,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                            boxShadow: [
                              BoxShadow(
                                  color: Color.fromARGB(255, 189, 179, 206),
                                  offset: Offset(0, 6),
                                  blurRadius: 10,
                                  spreadRadius: 4)
                            ]),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              child: Container(
                                width: double.maxFinite,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _isLoading
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15.0),
                                            child: Center(
                                                child: Loader(
                                              size: 25,
                                              color: Colors.deepPurple,
                                            )),
                                          )
                                        : Text(
                                            downloadCount.toString(),
                                            style: TextStyle(
                                                color: Colors.deepPurple,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    Text(
                                      "Downloads",
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Container(
                              height: 55.0,
                              width: 2,
                              color: Colors.grey[400],
                            ),
                            Expanded(
                              child: Container(
                                width: double.maxFinite,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    _isLoading
                                        ? Padding(
                                            padding: const EdgeInsets.only(
                                                bottom: 15.0),
                                            child: Center(
                                                child: Loader(
                                              size: 25,
                                              color: Colors.deepPurple,
                                            )),
                                          )
                                        : Text(
                                            favourites.length.toString(),
                                            style: TextStyle(
                                                color: Colors.deepPurple,
                                                fontSize: 30,
                                                fontWeight: FontWeight.bold),
                                          ),
                                    Text(
                                      "Favourites",
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  InkWell(
                    child: Container(
                      margin: EdgeInsets.only(left: 5, right: 5, bottom: 10),
                      padding: const EdgeInsets.all(5.0),
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5.0),
                        border: Border.all(
                          color: Colors.deepPurple,
                          width: 2.0,
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock_outline_rounded,
                            color: Colors.deepPurple,
                            size: 24,
                          ),
                          SizedBox(width: 5),
                          Text(
                            "Change Password",
                            style: TextStyle(
                                color: Colors.deepPurple,
                                fontSize: 16,
                                fontWeight: FontWeight.bold),
                          )
                        ],
                      ),
                    ),
                    onTap: () {
                      showDialog(
                          context: context,
                          builder: (context) =>
                              ChangePasswordDialog(user: user!));
                    },
                  ),
                  Row(
                    children: [
                      SizedBox(
                        width: 5,
                      ),
                      Icon(
                        Icons.favorite_outline_rounded,
                        color: Colors.deepPurple,
                        size: 24,
                      ),
                      SizedBox(width: 6),
                      Text(
                        "Favourites",
                        style: TextStyle(
                            fontSize: 18,
                            color: Colors.deepPurple,
                            fontWeight: FontWeight.bold),
                      ),
                      Expanded(
                        child: Container(
                            margin: EdgeInsets.only(left: 5, top: 3),
                            width: 2,
                            height: 2,
                            color: Colors.deepPurple),
                      )
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (favourites.length > 0)
                        Row(
                          children: [
                            SizedBox(width: 5),
                            Checkbox(
                              visualDensity: VisualDensity.compact,
                              value: selectedItems.length == favourites.length
                                  ? true
                                  : false,
                              onChanged: (bool? value) {
                                setState(() {
                                  if (value!) {
                                    setState(() {
                                      selectedItems = [...favourites];
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
                              width: 100,
                              height: 30,
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                  padding: EdgeInsets.symmetric(horizontal: 10),
                                  backgroundColor: Colors.red[400],
                                  foregroundColor: Colors.white,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  side:
                                      BorderSide(color: Colors.red, width: 0.0),
                                ),
                                onPressed: handleSelectedItem,
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.heart_broken_outlined,
                                      size: 16,
                                      color: Colors.white,
                                    ),
                                    const SizedBox(width: 5),
                                    Text("Remove"),
                                  ],
                                ),
                              ),
                            )
                          : Container(),
                      SizedBox(width: 10),
                    ],
                  ),
                  _isLoading
                      ? Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                            child: Loader(
                              size: 35,
                              color: Colors.deepPurple,
                            ),
                          ),
                        )
                      : Container(
                          height: 298,
                          child: favourites.length != 0
                              ? ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    dynamic item = favourites[index];
                                    bool isSelected =
                                        selectedItems.contains(item);

                                    return Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 5, right: 0, bottom: 2),
                                          color:
                                              Color.fromRGBO(240, 238, 247, 1),
                                          child: ListTile(
                                            contentPadding: EdgeInsets.zero,
                                            leading: Checkbox(
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
                                            ),
                                            title: Transform.translate(
                                              offset: Offset(-22, 0),
                                              child: Row(
                                                children: [
                                                  getCustomIcon(
                                                      item['mimeType']),
                                                  Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    children: [
                                                      Container(
                                                        child: Text(
                                                          truncateFilename(
                                                              item['name']),
                                                        ),
                                                      ),
                                                      Row(
                                                        children: [
                                                          Icon(
                                                              Icons
                                                                  .cloud_done_outlined,
                                                              size: 17,
                                                              color:
                                                                  Colors.grey),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Text(
                                                              item['size'],
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Icon(
                                                              Icons
                                                                  .access_time_sharp,
                                                              size: 16,
                                                              color:
                                                                  Colors.grey),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Text(
                                                              item['createdAt'],
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                          SizedBox(width: 5),
                                                          Icon(
                                                              Icons
                                                                  .person_2_outlined,
                                                              size: 16,
                                                              color:
                                                                  Colors.grey),
                                                          Padding(
                                                            padding:
                                                                EdgeInsets.only(
                                                                    left: 5),
                                                            child: Text(
                                                              item[
                                                                  'uploadedBy'],
                                                              style: TextStyle(
                                                                  fontSize: 12,
                                                                  color: Colors
                                                                      .grey),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                  Spacer(),
                                                  PopUpMenu(
                                                    file: item,
                                                    breadCrumbs: [],
                                                    isProfileSection: true,
                                                  )
                                                ],
                                              ),
                                            ),
                                            onTap: () async {
                                              handlePreviewFile(context, item);
                                            },
                                          ),
                                        ),
                                      ],
                                    );
                                  },
                                  itemCount: favourites.length,
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  physics: ClampingScrollPhysics(),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text("There is no favourite files yet"),
                                  ],
                                ),
                        )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
