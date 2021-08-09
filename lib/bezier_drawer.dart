import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import 'bezier_background_paint.dart';

class BezierDrawer extends StatefulWidget {
  final width;
  final height;

  /// The starting point's vertical position as a fraction of the widget's height
  final startFraction;

  /// The end point's vertical position as a fraction of the widget's height
  final endFraction;

  /// Relative position of the first stop on the screen from top left
  final Offset firstStopRelativeOffset;

  /// Relative position of the second stop on the screen from top left
  final Offset secondStopRelativeOffset;

  /// The relative position of the first control point between the start and the first stop. Defaults to Offset(.5, .5).
  final Offset firstControlRelativeOffset;

  /// The relative position of the second control point between the first and second stop. Defaults to Offset(.5, .5).
  final Offset secondControlRelativeOffset;

  /// The relative position of the last control point between the second stop and the end stop. Defaults to Offset(.5, .5).
  final Offset lastControlRelativeOffset;

  /// Enables controls for manipulating the bezier curve.
  final bool interactiveMode;

  final Color? color;

  BezierDrawer({
    Key? key,
    required this.width,
    required this.height,
    this.interactiveMode = true,
    this.color,
    this.startFraction = .6,
    this.endFraction = .3,
    this.firstStopRelativeOffset = const Offset(.3, .05),
    this.secondStopRelativeOffset = const Offset(.4, .1),
    this.firstControlRelativeOffset = const Offset(.5, -1.5),
    this.secondControlRelativeOffset = const Offset(.5, -.5),
    this.lastControlRelativeOffset = const Offset(.5, 1.5),
  }) : super(key: key);

  @override
  _BezierDrawerState createState() => _BezierDrawerState();
}

class _BezierDrawerState extends State<BezierDrawer> {
  final _stackKey = GlobalKey();
  late Offset _firstStopOffset;
  late Offset _secondStopOffset;
  late Offset _startOffset;
  late Offset _lastStopOffset;
  late Offset _firstControlOffset;
  late Offset _secondControlOffset;
  late Offset _lastControlOffset;

  @override
  void initState() {
    super.initState();
    _startOffset = Offset(0, widget.height * widget.startFraction);
    _firstStopOffset =
        widget.firstStopRelativeOffset.scale(widget.width, -widget.height) +
            _startOffset;
    _secondStopOffset =
        widget.secondStopRelativeOffset.scale(widget.width, widget.height) +
            _firstStopOffset;
    _lastStopOffset = Offset(widget.width, widget.height * widget.endFraction);
    _firstControlOffset = _startOffset +
        widget.firstControlRelativeOffset
            .scale(_firstStopOffset.dx, (_firstStopOffset - _startOffset).dy);
    _secondControlOffset = _firstStopOffset +
        (_secondStopOffset - _firstStopOffset).scale(
            widget.secondControlRelativeOffset.dx,
            widget.secondControlRelativeOffset.dy);
    _lastControlOffset = _secondStopOffset +
        (_lastStopOffset - _secondStopOffset).scale(
            widget.lastControlRelativeOffset.dx,
            widget.lastControlRelativeOffset.dy);
  }

  void _outputConfiguration() {
    final inverseWidth = 1 / widget.width;
    final inverseHeight = 1 / widget.height;
    final startFraction = _startOffset.dy * inverseHeight;
    final endFraction = _lastStopOffset.dy * inverseHeight;
    final firstStop = _firstStopOffset.scale(inverseWidth, inverseHeight);
    final secondStop = _secondStopOffset.scale(inverseWidth, inverseHeight);
    final firstControl = Offset(
        _firstControlOffset.dx / _firstStopOffset.dx,
        (_firstControlOffset - _startOffset).dy /
            (_firstStopOffset.dy - _startOffset.dy));
    final firstToSecondVector = _secondStopOffset - _firstStopOffset;
    final secondControl = (_secondControlOffset - _firstStopOffset)
        .scale(1 / firstToSecondVector.dx, 1 / firstToSecondVector.dy);
    final secondToLastVector = _lastStopOffset - _secondStopOffset;
    final lastControl = (_lastControlOffset - _secondStopOffset)
        .scale(1 / secondToLastVector.dx, 1 / secondToLastVector.dy);
    print('''
Use the following widget in your app as a layer of a Stack:    
    
LayoutBuilder(builder: (_, constraints) {
    return BezierDrawer(
      width: constraints.maxWidth,
      height: constraints.maxHeight,${widget.color != null ? '''
      color: ${widget.color},''' : ''}
      startFraction: $startFraction,
      endFraction: $endFraction,
      firstStopRelativeOffset: $firstStop,
      secondStopRelativeOffset: $secondStop,
      firstControlRelativeOffset: $firstControl,
      secondControlRelativeOffset: $secondControl,
      lastControlRelativeOffset: $lastControl,
    );
  })
''');
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      key: _stackKey,
      children: [
        SizedBox.expand(
          child: CustomPaint(
            painter: BezierBackgroundPaint(
              _startOffset,
              _firstStopOffset,
              _secondStopOffset,
              _lastStopOffset,
              _firstControlOffset,
              _secondControlOffset,
              _lastControlOffset,
              widget.color ?? Colors.grey[700]!,
              widget.interactiveMode,
            ),
          ),
        ),
        if (widget.interactiveMode)
          ...<Offset, Function(Offset)>{
            _startOffset: (value) => _startOffset = Offset(0, value.dy),
            _firstStopOffset: (value) => _firstStopOffset = value,
            _secondStopOffset: (value) => _secondStopOffset = value,
            _lastStopOffset: (value) =>
                _lastStopOffset = Offset(widget.width, value.dy),
            _firstControlOffset: (value) => _firstControlOffset = value,
            _secondControlOffset: (value) => _secondControlOffset = value,
            _lastControlOffset: (value) => _lastControlOffset = value,
          }.entries.map((entry) {
            return Handle(
              offset: entry.key,
              setter: entry.value,
              update: (data, setter) =>
                  setState(() => setter(_transformOffset(data))),
            );
          }),
        if (widget.interactiveMode)
          Positioned(
            top: 15,
            left: 0,
            right: 0,
            child: SafeArea(
              child: Center(
                child: ElevatedButton(
                  onPressed: _outputConfiguration,
                  child: Text('GENERATE WIDGET CODE ON CONSOLE'),
                ),
              ),
            ),
          ),
      ],
    );
  }

  Offset _transformOffset(DragUpdateDetails data) {
    return data.globalPosition -
        (_stackKey.currentContext?.findRenderObject() as RenderBox)
            .localToGlobal(Offset.zero);
  }
}

class Handle extends StatelessWidget {
  final Offset offset;
  final Function(DragUpdateDetails, Function(Offset)) update;
  final Function(Offset) setter;

  const Handle({
    Key? key,
    required this.offset,
    required this.update,
    required this.setter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: offset.dy - 12.5,
      left: offset.dx - 12.5,
      child: GestureDetector(
        onPanUpdate: (data) => update(data, setter),
        child: Container(
          width: 25,
          height: 25,
          color: Colors.transparent,
        ),
      ),
    );
  }
}
