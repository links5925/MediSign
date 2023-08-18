import 'package:flutter/material.dart';

class Default_Logo extends StatelessWidget {
  const Default_Logo({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Column(
      children: [
        Transform.translate(
          offset: Offset(-20, 0),
          child: Container(
              height: screenHeight * 0.05,
              child: Row(
                children: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Icon(Icons.arrow_left_sharp)),
                  Image(
                      image:
                          AssetImage('assets/image/White on Transparent.png')),
                ],
              )),
        ),
      ],
    );
  }
}
