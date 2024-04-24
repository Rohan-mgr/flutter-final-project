import 'package:flutter/material.dart';
import 'package:flutter_final_project/helper/storage.dart';
import 'package:flutter_final_project/screens/blogs_screen.dart';
import 'package:flutter_final_project/screens/notes_screen.dart';
import 'package:flutter_final_project/screens/profile_screen.dart';
import 'package:flutter_final_project/screens/questions_screen.dart';
import 'package:flutter_final_project/types/user.dart';
import 'package:flutter_final_project/widgets/loader.dart';
import 'package:google_sign_in/google_sign_in.dart';

class Home extends StatefulWidget {
  final List<String>? initialBreadCrumbs;
  final int? bottomNavigationIndex;
  const Home({super.key, this.initialBreadCrumbs, this.bottomNavigationIndex});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  MyUser? user;
  int? _currentPageIndex = 0;
  List<String> breadCrumbs = [];
  String userProfileUrl = "";
  bool _isProfileUpdating = false;
  String updatedUserName = "";

  @override
  void initState() {
    super.initState();
    loadUserFromLocalStorage();

    _currentPageIndex = widget.bottomNavigationIndex;
    if (widget.initialBreadCrumbs != null) {
      breadCrumbs = List<String>.from(widget.initialBreadCrumbs!);
    }
  }

  Future<void> loadUserFromLocalStorage() async {
    try {
      final loggedUser = await Storage.getUser("user");
      if (loggedUser != null) {
        setState(() {
          user = loggedUser;
          userProfileUrl = loggedUser.profilePic!;
        });
      }
    } catch (error) {
      print('Error retrieving user: $error');
    }
  }

  Future<void> loadUserProfileUrl() async {
    try {
      setState(() {
        _isProfileUpdating = true;
      });
      final loggedUser = await Storage.getUser("user");
      if (loggedUser != null) {
        setState(() {
          userProfileUrl = loggedUser.profilePic!;
        });
      }
      setState(() {
        _isProfileUpdating = false;
      });
    } catch (error) {
      setState(() {
        _isProfileUpdating = false;
      });
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

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
      breadCrumbs = [];
    });
    loadUserProfileUrl();
    loadNewUserName();
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Notes(initialBreadCrumbs: breadCrumbs),
      Questions(initialBreadCrumbs: breadCrumbs),
      Blogs(),
      Profile(),
    ];

    return Scaffold(
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (_currentPageIndex != 3)
              Container(
                height: 130,
                padding: EdgeInsetsDirectional.symmetric(
                    horizontal: 10, vertical: 30),
                decoration: BoxDecoration(
                  color: Colors.deepPurple,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(25.0),
                    bottomRight: Radius.circular(25.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          userProfileUrl == ""
                              ? Icon(
                                  Icons.account_circle_rounded,
                                  color: Colors.white,
                                  size: 60,
                                )
                              : _isProfileUpdating
                                  ? Loader(size: 40, color: Colors.deepPurple)
                                  : ClipOval(
                                      child: Image.network(
                                      userProfileUrl,
                                      width: 60,
                                      height: 60,
                                      fit: BoxFit.cover,
                                    )),
                          SizedBox(width: 5),
                          Container(
                            margin: EdgeInsets.only(top: 7),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("Welcome, ",
                                    style: TextStyle(color: Colors.white)),
                                Text(
                                    '${updatedUserName != '' ? updatedUserName : '${user?.firstName} ${user?.lastName}'}',
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold)),
                              ],
                            ),
                          ),
                        ]),
                    OutlinedButton(
                      onPressed: () async {
                        await Storage.remove('user');
                        await GoogleSignIn().signOut();
                        Navigator.popAndPushNamed(context, "/");
                      },
                      style: OutlinedButton.styleFrom(
                        shape: CircleBorder(),
                        padding: EdgeInsets.all(10),
                        side: BorderSide(
                            color: Colors.white,
                            width: 2), // Adjust width as needed
                      ),
                      child: Icon(
                        Icons.logout,
                        size: 30,
                        color: Colors.white,
                      ),
                    )
                  ],
                ),
              ),
            Expanded(
                child: Center(
                    child: _widgetOptions.elementAt(_currentPageIndex!))),
          ],
        ),
      ),
      bottomNavigationBar: NavigationBar(
        height: 70,
        onDestinationSelected: _onItemTapped,
        indicatorColor: Colors.deepPurple,
        selectedIndex: _currentPageIndex!,
        destinations: const <Widget>[
          NavigationDestination(
            selectedIcon: Icon(
              Icons.paste_rounded,
              size: 27,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.paste_rounded,
              size: 27,
            ),
            label: 'Notes',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.text_snippet_rounded,
              size: 27,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.text_snippet_rounded,
              size: 27,
            ),
            label: 'Questions',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.travel_explore_rounded,
              size: 27,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.travel_explore_rounded,
              size: 27,
            ),
            label: 'Blogs',
          ),
          NavigationDestination(
            selectedIcon: Icon(
              Icons.account_circle_rounded,
              size: 27,
              color: Colors.white,
            ),
            icon: Icon(
              Icons.account_circle_rounded,
              size: 27,
            ),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
