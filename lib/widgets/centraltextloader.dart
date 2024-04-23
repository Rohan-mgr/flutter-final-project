import 'package:flutter/material.dart';
import 'package:flutter_final_project/widgets/loader.dart';

class CenterTextCircularProgressIndicator extends StatefulWidget {
  final String text;

  const CenterTextCircularProgressIndicator({
    Key? key,
    required this.text,
  }) : super(key: key);

  @override
  State<CenterTextCircularProgressIndicator> createState() =>
      _CenterTextCircularProgressIndicatorState();
}

class _CenterTextCircularProgressIndicatorState
    extends State<CenterTextCircularProgressIndicator> {
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Container(
          width: 100,
          height: 100,
          child: Loader(size: 50, color: Colors.deepPurple),
        ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          bottom: 0,
          child: Center(
            child: Text(
              widget.text,
              style: TextStyle(
                fontSize: 16.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
