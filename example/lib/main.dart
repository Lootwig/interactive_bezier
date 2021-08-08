import 'package:flutter/material.dart';
import 'package:interactive_bezier/interactive_bezier.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData.dark(),
      home: Scaffold(
        body: LayoutBuilder(builder: (_, constraints) {
          return BezierDrawer(
            width: constraints.maxWidth,
            height: constraints.maxHeight,
            color: Colors.amber,
            startFraction: 0.6,
            endFraction: 0.4,
            firstStopRelativeOffset: Offset(0.3, 0.1),
            secondStopRelativeOffset: Offset(0.3, 0.12),
            firstControlRelativeOffset: Offset(0.5, -.5),
            secondControlRelativeOffset: Offset(0.5, 1.1),
            lastControlRelativeOffset: Offset(0.5, 1.5),
          );
        }),
      ),
    );
  }
}
