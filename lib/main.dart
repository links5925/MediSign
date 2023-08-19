// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:flutter_medicine/Medi_info.dart';
import 'package:flutter_medicine/Medi_map.dart';
import 'package:flutter_medicine/ocr.dart';
import 'package:flutter_medicine/login_register/register.dart';
import 'package:flutter_medicine/login_register/set_user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'Medi_Bot.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'login_register/login.dart';
import 'Directocr.dart';
import 'map.dart';
import 'startscreen.dart';
import 'All_alarm.dart';

void main() async {
  initializeDateFormatting().then((_) {
    runApp(MyApp());
  });
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  bool isLogin = false;

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    int? id = user_info.getInt('id');
    if (id != null) {
      setState(() {
        isLogin = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLogin ? '/Login' : '/',
      // initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        // '/UserInfo': (context) => UserInfoPage(),
        '/Ocr': (context) => OCR(),
        '/Register': (context) => RegisterPgae(),
        '/user_set': (context) => Setuser(),
        '/Login': (context) => LoginPage(),
        '/Directocr': (context) => Camera(),
        '/Startscreen': (context) => StartScreen(),
        '/Medi_Info': (context) => Medi_info(),
        '/Map': (context) => Map(),
        '/Medi_Bot': (context) => Medi_Bot(),
        '/All_Alarm': (context) => All_Alarm(),
        '/Medi_Map': (context) => Medi_Map()
      },
    );
  }
}
