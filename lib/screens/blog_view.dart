import 'package:flutter/material.dart';

class BlogView extends StatelessWidget {
  const BlogView({super.key});

  @override
  Widget build(BuildContext context) {
    final data = ModalRoute.of(context)!.settings.arguments as Map;
    return Scaffold(
      appBar: AppBar(),
      body: Stack(
        children: [
          Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: Image.network(
                      data["imgUrl"],
                      width: 400,
                      height: 300,
                      fit: BoxFit.cover,
                    ),
                  ),
                ],
              ),
              Expanded(
                  child: Container(
                      // color: Colors.red,
                      ))
            ],
          ),
          Positioned(
              top: 280,
              left: 0,
              right: 0,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(50),
                      topRight: Radius.circular(50)),
                  color: Colors.white,
                ),
                height: 30,
              ))
        ],
      ),
    );
  }
}
