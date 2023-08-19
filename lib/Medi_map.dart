import 'package:flutter/material.dart';

import 'Default_set/Default_Logo.dart';

class Medi_Map extends StatefulWidget {
  const Medi_Map({super.key});

  @override
  State<Medi_Map> createState() => _Medi_MapState();
}

class _Medi_MapState extends State<Medi_Map> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Default_Logo(),
        ],
      ),
    );
  }
}
