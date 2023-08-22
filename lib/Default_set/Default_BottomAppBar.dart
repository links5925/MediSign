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
      elevation: 10,
      color: Colors.white.withOpacity(0.55),
      shape: CircularNotchedRectangle(),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              IconButton(
                icon: Column(
                  children: [
                    Icon(
                      Icons.home,
                    ),
                    Text('MEDI.HOME',
                        style: TextStyle(fontSize: 5, color: Colors.blue))
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/');
                },
              ),
              IconButton(
                icon: Column(
                  children: [
                    Icon(Icons.medical_services_outlined),
                    Text(
                      'MEDI.INFO',
                      style: TextStyle(fontSize: 5, color: Colors.blue),
                    )
                  ],
                ),
                onPressed: () {
                  Navigator.pushNamed(context, '/Medi_Info');
                },
              ),
              SizedBox(),
              IconButton(
                icon: Column(
                  children: [
                    Icon(Icons.person),
                    Text(
                      'MEDI.BOT',
                      style: TextStyle(color: Colors.blue, fontSize: 6),
                    )
                  ],
                ),
                onPressed: () {
                  _savelength(screenWidth, screenHeight);
                  Navigator.pushNamed(
                    context,
                    '/Medi_Bot',
                  );
                },
              ),
              IconButton(
                icon: Column(
                  children: [
                    Icon(Icons.location_on_outlined),
                    Text('MEDI.MAP',
                        style: TextStyle(fontSize: 6, color: Colors.blue))
                  ],
                ),
                onPressed: () {
                  _savelength(screenWidth, screenHeight);
                  Navigator.pushNamed(context, '/Medi_Map');
                },
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.all(6.0),
            child: Text('MEDI.LENZ',
                style: TextStyle(fontSize: 8, color: Colors.blue)),
          )
        ],
      ),
    );
  }
}
