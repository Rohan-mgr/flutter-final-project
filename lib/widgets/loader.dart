import 'package:flutter/material.dart';

class Loader extends StatelessWidget {
  final double size;

  const Loader({super.key, this.size = 25.0});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: size, // Adjust height as needed
      width: size,
      child: CircularProgressIndicator(),
    );
  }
}
