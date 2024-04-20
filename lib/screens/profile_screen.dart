import 'package:flutter/material.dart';
import 'package:flutter_final_project/helper/helper.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/services/firebase_auth_service.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:flutter_final_project/widgets/popUpMenu.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  State<Profile> createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  MyUser? user;
  bool _isLoading = false;
  int downloadCount = 0;
  List<dynamic> favourites = [];

  @override
  void initState() {
    super.initState();
    loadUserFromLocalStorage();
  }

  Future<void> loadUserFromLocalStorage() async {
    try {
      final loggedUser = await Storage.getUser("user");
      print('loggeduser id = ${loggedUser?.id}');
      if (loggedUser != null) {
        setState(() {
          user = loggedUser;
        });
        await getFavoritesList();
        await getDownloadCount();
      }
    } catch (error) {
      print('Error retrieving user: $error');
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverToBoxAdapter(
            child: SizedBox(
              height: 370,
              child: Stack(
                children: [
                  Column(
                    children: [
                      Container(
                        width: double.infinity,
                        height: 300,
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
                                  Navigator.popAndPushNamed(context, "/");
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
                                        margin: EdgeInsets.only(top: 40.0),
                                        child: ClipOval(
                                          child: Icon(
                                            Icons.account_circle_rounded,
                                            color: Colors.white,
                                            size: 120,
                                          ),
                                          // Image.asset(
                                          //   "assets/logo.png",
                                          //   width: 120.0,
                                          //   height: 120.0,
                                          //   fit: BoxFit.cover,
                                          // ),
                                        ),
                                      ),

                                      // Edit button positioned on bottom right of profile picture
                                      Positioned(
                                        bottom: 0.0,
                                        right: 0.0,
                                        child: ElevatedButton(
                                          onPressed: () {
                                            // Handle edit button press (e.g., navigate to edit screen)
                                            print("Edit icon clicked");
                                          },
                                          child: Icon(Icons.edit),
                                          style: ElevatedButton.styleFrom(
                                            shape: CircleBorder(),
                                            padding: EdgeInsets.all(8.0),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                  Text(
                                    "${user?.firstName} ${user?.lastName}",
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 22),
                                  ),
                                  Text("${user?.email}",
                                      style: TextStyle(
                                          color: Color.fromARGB(
                                              255, 204, 197, 197))),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                  Positioned(
                    top: 230,
                    left: 30,
                    right: 30,
                    child: Center(
                      child: Container(
                        height: 120,
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
                          height: 340,
                          child: favourites.length != 0
                              ? ListView.builder(
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    dynamic item = favourites[index];
                                    return Column(
                                      children: [
                                        Container(
                                          margin: EdgeInsets.only(
                                              left: 5,
                                              right: 5,
                                              top: 2,
                                              bottom: 2),
                                          color:
                                              Color.fromRGBO(240, 238, 247, 1),
                                          child: ListTile(
                                            contentPadding:
                                                EdgeInsets.only(left: 5),
                                            title: Row(
                                              children: [
                                                getCustomIcon(item['mimeType']),
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
                                                            color: Colors.grey),
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
                                                            color: Colors.grey),
                                                        Padding(
                                                          padding:
                                                              EdgeInsets.only(
                                                                  left: 5),
                                                          child: Text(
                                                            item['uploadedBy'],
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
