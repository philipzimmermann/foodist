import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class StartAnimation extends StatefulWidget {
  const StartAnimation({Key? key}) : super(key: key);

  @override
  _StartAnimationState createState() => _StartAnimationState();
}

class _StartAnimationState extends State<StartAnimation>
    with SingleTickerProviderStateMixin {
  double _fraction = 0.0;
  late Animation<double> _animation;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
        duration: const Duration(milliseconds: 4000), vsync: this);

    _animation = Tween(begin: 0.0, end: 1.0).animate(_controller)
      ..addListener(() {
        setState(() {
          _fraction = _animation.value;
        });
      });

    _controller.forward();
    _controller.addListener(() {
      if (_controller.isCompleted) {
        _controller.repeat();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AspectRatio(
        aspectRatio: 1.0,
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: CustomPaint(
            painter: CirclePainter(fraction: _fraction),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class CirclePainter extends CustomPainter {
  final double fraction;

  CirclePainter({required this.fraction});

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawColor(Colors.white, BlendMode.src);
    const icons = [
      Icons.lunch_dining_outlined,
      Icons.ramen_dining_outlined,
      Icons.local_pizza_outlined
    ];
    TextPainter textPainter = TextPainter(textDirection: TextDirection.rtl);
    var iconStyle = TextStyle(
        fontSize: 40.0, fontFamily: icons[0].fontFamily, color: Colors.black);
    //center element
    textPainter.text = TextSpan(
        text: String.fromCharCode(Icons.self_improvement_outlined.codePoint),
        style: iconStyle);
    textPainter.layout();
    Offset center = Offset((size.width - textPainter.width) / 2,
        (size.height - textPainter.height) / 2);
    textPainter.paint(canvas, center);
    //circle elements
    for (int i = 0; i < icons.length; i++) {
      textPainter.text = TextSpan(
          text: String.fromCharCode(icons[i].codePoint), style: iconStyle);
      textPainter.layout();
      var radius = min(size.width, size.height) / 3;
      Offset center = Offset((size.width - textPainter.width) / 2,
          (size.height - textPainter.height) / 2);
      Offset offset = Offset(
          center.dx + sin(pi * 2 * (fraction + 1 / icons.length * i)) * radius,
          center.dy + cos(pi * 2 * (fraction + 1 / icons.length * i)) * radius);
      textPainter.paint(canvas, offset);
    }
  }

  @override
  bool shouldRepaint(CirclePainter oldDelegate) {
    return oldDelegate.fraction != fraction;
  }
}
