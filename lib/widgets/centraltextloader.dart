import 'package:flutter/material.dart';
import 'package:flutter_final_project/widgets/circularPainter.dart';

class CenterTextCircularProgressIndicator extends StatefulWidget {
  final double value;
  final String text;
  final Color backgroundColor;
  final Color progressColor;
  final double stokeWidth;

  const CenterTextCircularProgressIndicator({
    Key? key,
    required this.value,
    required this.text,
    this.backgroundColor = Colors.deepPurple,
    this.progressColor = Colors.blue,
    this.stokeWidth = 8.0,
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
        CustomPaint(
          painter: CirclePainter(
              progress: widget.value,
              progressColor: widget.backgroundColor,
              strokeWidth: widget.stokeWidth,
              backgroundColor: widget.progressColor),
          child: SizedBox(
            width: 100,
            height: 100,
          ),
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
