import 'package:flutter/material.dart';
import 'package:flutter_final_project/widgets/blogcard.dart';

class Blogs extends StatefulWidget {
  const Blogs({super.key});

  @override
  State<Blogs> createState() => _BlogsState();
}

class _BlogsState extends State<Blogs> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlogCard(),
    );
  }
}
