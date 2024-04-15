import 'package:flutter/material.dart';
import 'package:flutter_final_project/screens/blogs_screen.dart';
import 'package:flutter_final_project/screens/notes_screen.dart';
import 'package:flutter_final_project/screens/questions_screen.dart';

class Home extends StatefulWidget {
  final List<String>? initialBreadCrumbs;
  const Home({super.key, this.initialBreadCrumbs});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPageIndex = 0;
  List<String> breadCrumbs = [];

  @override
  void initState() {
    super.initState();
    if (widget.initialBreadCrumbs != null) {
      breadCrumbs = List<String>.from(widget.initialBreadCrumbs!);
    }
  }

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
      breadCrumbs = [];
    });
  }

  @override
  Widget build(BuildContext context) {
    List<Widget> _widgetOptions = <Widget>[
      Notes(initialBreadCrumbs: breadCrumbs),
      Questions(),
      Blogs()
    ];

    return Scaffold(
      appBar: AppBar(
        title: Text("We Share"),
      ),
      body: Center(child: _widgetOptions.elementAt(_currentPageIndex)),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        indicatorColor: Colors.deepPurple,
        selectedIndex: _currentPageIndex,
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
        ],
      ),
    );
  }
}
