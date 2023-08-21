import 'package:flutter/material.dart';

class Default_Logo extends StatelessWidget {
  const Default_Logo({super.key});

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Padding(
      padding: const EdgeInsets.only(top: 20, bottom: 10),
      child: Transform.translate(
        offset: Offset(screenWidth * 0.12, 0),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Transform.translate(
                offset: Offset(-20, 0),
                child: Container(
                    height: screenHeight * 0.05,
                    child: Row(
                      children: [
                        TextButton(
                            onPressed: () {},
                            child: Icon(Icons.arrow_left_sharp)),
                        Image(
                            image: AssetImage(
                                'assets/image/White on Transparent.png')),
                      ],
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
