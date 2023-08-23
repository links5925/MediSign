// ignore_for_file: sized_box_for_whitespace, file_names, camel_case_types
import 'package:flutter/material.dart';
import '../Icon/custom_icon.dart';

class Custom_Appbar extends StatefulWidget {
  const Custom_Appbar({super.key});

  @override
  State<Custom_Appbar> createState() => _Custom_AppbarState();
}

class _Custom_AppbarState extends State<Custom_Appbar> {
  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Padding(
      padding: EdgeInsets.only(
          top: screenHeight * 0.03,
          left: screenWidth * 0.02,
          right: screenWidth * 0.04),
      child: Row(
        children: [
          IconButton(
            onPressed: () {
              Scaffold.of(context).openDrawer();
            },
            icon: Icon(Custom_Icons.list),
            iconSize: 16,
            color: Colors.white,
          ),
          SizedBox(
            width: screenWidth * 0.22,
          ),
          Transform.translate(
            offset: Offset(-20, 0),
            child: Container(
                width: screenHeight * 0.18,
                child: Image(
                    image:
                        AssetImage('assets/image/White on Transparent.png'))),
          ),
          Spacer(),
          Transform.translate(
            offset: Offset(0, -3),
            child: IconButton(
              onPressed: () {
                Navigator.pushNamed(context, '/All_Alarm');
              },
              icon: Icon(
                Custom_Icons.bell,
                size: 25,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
