import 'package:flutter/material.dart';
import 'package:flutter_final_project/screens/blogs_screen.dart';
import 'package:flutter_final_project/screens/notes_screen.dart';
import 'package:flutter_final_project/screens/questions_screen.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentPageIndex = 0;

  List<Widget> _widgetOptions = <Widget>[Notes(), Questions(), Blogs()];

  void _onItemTapped(int index) {
    setState(() {
      _currentPageIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("We Share"),
      ),
      body: Center(child: _widgetOptions.elementAt(_currentPageIndex)),
      bottomNavigationBar: NavigationBar(
        onDestinationSelected: _onItemTapped,
        indicatorColor: Colors.amber,
        selectedIndex: _currentPageIndex,
        destinations: const <Widget>[
          NavigationDestination(
            icon: Icon(
              Icons.paste_rounded,
              size: 27,
            ),
            label: 'Notes',
          ),
          NavigationDestination(
            icon: Icon(
              Icons.text_snippet_rounded,
              size: 27,
            ),
            label: 'Questions',
          ),
          NavigationDestination(
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
