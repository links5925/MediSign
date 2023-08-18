import 'package:flutter/material.dart';
import 'package:flutter_medicine/Medi_info.dart';
import 'package:flutter_medicine/ocr.dart';
import 'package:flutter_medicine/login_register/register.dart';
import 'package:flutter_medicine/login_register/set_user_info.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'HomePage.dart';
import 'Medi_Bot.dart';
import 'login_register/UserInfoPage.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'login_register/login.dart';
import 'directocr.dart';
import 'map.dart';
import 'startscreen.dart';

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
  late bool isLogin = false;

  @override
  void initState() {
    super.initState();
    _loadisLogin();
    _loadUserInfo();
  }

  Future<void> _loadisLogin() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    isLogin = user_info.getBool('isLogin') ?? false;
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    String Email = user_info.getString('Email') ?? '';
    String Password = user_info.getString('Password') ?? '';
    isLogin = user_info.getBool('isLogin') ?? false;
    if (Email.isEmpty || Password.isEmpty) {
      isLogin = false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: isLogin ? '/' : '/Login',
      // initialRoute: '/',
      routes: {
        '/': (context) => HomePage(),
        '/UserInfo': (context) => UserInfoPage(),
        '/Ocr': (context) => OCR(),
        '/Register': (context) => RegisterPgae(),
        '/user_set': (context) => Setuser(),
        '/Login': (context) => LoginPage(),
        '/Directocr': (context) => Camera(),
        '/Startscreen': (context) => StartScreen(),
        '/Medi_Info': (context) => Medi_info(),
        '/Medi_Map': (context) => Medi_Map(),
        '/Medi_Bot': (context) => Medi_Bot(),
      },
    );
  }
}
