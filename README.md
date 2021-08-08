# interactive_bezier

Draw a wavy bezier background on-device and generate reusable widget code for your project.

## Getting Started

Embed the `BezierDrawer` widget into your app, like this:

```[dart]
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
          );
        }),
      ),
    );
  }
}
```

This will provide you with an interactive version of the widget, letting you adjust the anchor points to your design's needs.

Once you're satisfied with the result, generate the code for the widget you designed by pressing the provided button.