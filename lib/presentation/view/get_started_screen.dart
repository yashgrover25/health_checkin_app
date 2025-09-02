import 'package:flutter/material.dart';

import 'login_screen.dart';

class GetStartedScreen extends StatelessWidget {
  const GetStartedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [Colors.green, Colors.white],
              ),
            ),
          ),
          Center(
            child: Container(
              width: MediaQuery.of(context).size.width / 1.2,
              height: MediaQuery.of(context).size.height / 1.2,
              decoration: BoxDecoration(
                image: DecorationImage(
                  fit: BoxFit.contain,
                  image: AssetImage('assets/images/starting_image.png',),
                ),
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: MediaQuery.of(context).size.width,
              height: MediaQuery.of(context).size.height / 3,
              decoration: ShapeDecoration(
                shape: _GetStartedShape(),
                color: Colors.white,
                shadows: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.5),
                    spreadRadius: 5,
                  ),
                ],
              ),
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Welcome',
                      style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text('Are you ready for a Health Check-In?'),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => LoginScreen()),
          );
        },
        shape: CircleBorder(),
        isExtended: true,
        backgroundColor: Colors.black,
        child: Icon(Icons.login, color: Colors.greenAccent),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }
}

class _GetStartedShape extends ShapeBorder {
  const _GetStartedShape();
  final double borderRadius = 60;

  @override
  EdgeInsetsGeometry get dimensions => EdgeInsets.zero;

  @override
  Path getOuterPath(Rect rect, {TextDirection? textDirection}) {
    final path = Path();
    const halfWidth = 12.5;
    final oneThirdHeight = rect.height / 3;

    // Start at the top-left corner of the rectangle.
    path
      ..moveTo(rect.left, rect.top)
      // Draw a line to a point slightly to the right and down,
      // creating the top-left curve's starting point.
      ..lineTo(rect.left, rect.top + oneThirdHeight - borderRadius)
      // Draw a quadratic Bezier curve to create the rounded top-left corner.
      // The control point is at (rect.left + halfWidth, rect.top + oneThirdHeight),
      // and the end point is at (rect.left + halfWidth + borderRadius, rect.top + oneThirdHeight).
      ..quadraticBezierTo(
        rect.left + halfWidth,
        rect.top + oneThirdHeight,
        rect.left + halfWidth + borderRadius,
        rect.top + oneThirdHeight,
      )
      // Draw a horizontal line to the starting point of the top-right curve.
      ..lineTo(rect.right - borderRadius, rect.top + oneThirdHeight)
      // Draw a quadratic Bezier curve to create the rounded top-right corner.
      // The control point is at (rect.right, rect.top + oneThirdHeight),
      // and the end point is at (rect.right, rect.top + oneThirdHeight + borderRadius).
      ..quadraticBezierTo(
        rect.right,
        rect.top + oneThirdHeight,
        rect.right,
        rect.top + oneThirdHeight + borderRadius,
      )
      // Draw a vertical line to the bottom-right corner of the rectangle.
      ..lineTo(rect.right, rect.bottom)
      // Draw a horizontal line to the bottom-left corner of the rectangle.
      ..lineTo(rect.left, rect.bottom)
      // Draw a vertical line back to the top-left corner of the rectangle.
      ..lineTo(rect.left, rect.top)
      // Close the path to complete the shape.
      ..close();
    return path;
  }

  @override
  Path getInnerPath(Rect rect, {TextDirection? textDirection}) {
    return getOuterPath(rect, textDirection: textDirection);
  }

  @override
  void paint(Canvas canvas, Rect rect, {TextDirection? textDirection}) {}

  @override
  ShapeBorder scale(double t) => this;
}
