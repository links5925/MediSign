import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class Default_bottomAppBar extends StatefulWidget {
  const Default_bottomAppBar({
    super.key,
  });

  @override
  State<Default_bottomAppBar> createState() => _Default_bottomAppBarState();
}

class _Default_bottomAppBarState extends State<Default_bottomAppBar> {
  @override
  Widget build(BuildContext context) {
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
              Navigator.pushNamed(context, '/Medi_Bot');
            },
          ),
          IconButton(
            icon: Icon(Icons.location_on_outlined),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}
