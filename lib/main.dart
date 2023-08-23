// ignore_for_file: non_constant_identifier_names
import 'package:flutter/material.dart';
import 'package:flutter_medicine/Medi_info.dart';
import 'package:flutter_medicine/Medi_Map.dart';
import 'package:flutter_medicine/information.dart';
import 'package:flutter_medicine/ocr.dart';
import 'package:flutter_medicine/login_register/register.dart';
import 'package:flutter_medicine/login_register/set_user_info.dart';
import 'package:flutter_medicine/set.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'Medi_Bot.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'Medi_Calendar_Medicine.dart';
import 'Medi_Map_Prescription.dart';
import 'login_register/change_info.dart';
import 'login_register/login.dart';
import 'Direct_Ocr.dart';
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
      routes: {
        '/': (context) => HomePage(),
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
        '/Medi_Map': (context) => Medi_Map(),
        '/Medi_Map_Detail': (context) => Medi_Map_Detail(),
        '/Medi_Map_Prescription': (context) => Medi_Map_Prescription(),
        '/User_Information': (context) => Information(),
        '/Medi_Calendar_Medicine': (context) => Medi_Calendar_Medicine(),
        //   '/set': (context) => Medi_Set(),
        '/change_info': (context) => Change_Info_Page(),
      },
    );
  }
}
