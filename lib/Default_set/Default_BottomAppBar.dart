import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Default_bottomAppBar extends StatefulWidget {
  const Default_bottomAppBar({
    super.key,
  });

  @override
  State<Default_bottomAppBar> createState() => _Default_bottomAppBarState();
}

class _Default_bottomAppBarState extends State<Default_bottomAppBar> {
  void _savelength(double width, double height) async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setInt('Width', width.toInt());
    user_info.setInt('Height', height.toInt());
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return BottomAppBar(
      elevation: 0,
      color: Colors.white.withOpacity(0.55),
      shape: CircularNotchedRectangle(),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          IconButton(
            icon: Icon(
              Icons.home,
            ),
            onPressed: () {
              Navigator.pushNamed(context, '/');
            },
          ),
          IconButton(
            icon: Icon(Icons.medical_services_outlined),
            onPressed: () {
              Navigator.pushNamed(context, '/Medi_Info');
            },
          ),
          SizedBox(),
          IconButton(
            icon: Icon(Icons.person),
            onPressed: () {
              _savelength(screenWidth, screenHeight);
              Navigator.pushNamed(context, '/Medi_Bot');
            },
          ),
          IconButton(
            icon: Icon(Icons.location_on_outlined),
            onPressed: () {
              _savelength(screenWidth, screenHeight);
              Navigator.pushNamed(context, '/Medi_Map');
            },
          ),
        ],
      ),
    );
  }
}
