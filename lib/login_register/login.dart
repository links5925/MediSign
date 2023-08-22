import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _EmailController = TextEditingController();
  TextEditingController _PasswordController = TextEditingController();
  late String email;
  late String password;
  var User;
  void checkData() async {
    email = _EmailController.text;
    password = _PasswordController.text;

    const String url =
        'https://medisign-hackthon-95c791df694a.herokuapp.com/users/User_list';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      for (final user in data) {
        if (user['email'] == email && user['password'] == password) {
          User = user;
          break;
        }
      }
      if (User == null) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text('알림'),
                  content: Text('아이디 비번 틀림'),
                  actions: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("확인"))
                  ],
                ));
      } else {
        loaduserinfo(User);
        Navigator.pushNamed(context, '/');
      }
    } else {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('알림'),
                content: Text('오류가 발생했습니다'),
                actions: [
                  TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: Text("확인"))
                ],
              ));
    }
  }

  void loaduserinfo(Map<String, dynamic> User) async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setString('Email', User['email']);
    user_info.setString('name', User['name']);
    user_info.setString('bloodType', User['blood_type']);
    user_info.setString('gender', User['gender']);
    user_info.setInt('height', User['height']);
    user_info.setInt('weight', User['weight']);
    user_info.setInt('id', User['id']);
    user_info.setStringList('disease', User['disease']);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;
    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          width: screenWidth,
          height: screenHeight,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff627BFD), Color(0xffE3EBFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  height: screenHeight * 0.6,
                  width: screenWidth * 0.9,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15)),
                  child: Container(
                    height: screenHeight * 0.5,
                    child: Column(
                      children: [
                        Column(
                          children: [
                            SizedBox(
                              height: screenHeight * 0.1,
                            ),
                            ClipOval(
                              child: Image.network(
                                'https://picsum.photos/200/200', // 이미지 URL
                                width: screenHeight * 0.12, // 원형 이미지의 가로
                                height: screenHeight * 0.12, // 원형 이미지의 세로 길이
                                fit: BoxFit.cover, // 이미지를 원형에 맞게 조정
                              ),
                            ),
                            Container(
                                width: screenWidth * 0.77,
                                child: TextField(
                                  controller: _EmailController,
                                  showCursor: false,
                                  decoration: InputDecoration(hintText: '이메일'),
                                )),
                            Container(
                                width: screenWidth * 0.77,
                                child: TextField(
                                  controller: _PasswordController,
                                  showCursor: false,
                                  decoration: InputDecoration(hintText: '비밀번호'),
                                )),
                          ],
                        ),
                        Spacer(),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: Container(
                                height: 30,
                                width: 100,
                                decoration: BoxDecoration(
                                    color: Color(0xff7885f8).withOpacity(0.7),
                                    borderRadius: BorderRadius.circular(15)),
                                child: TextButton(
                                  child: Text(
                                    '회원가입',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/Register');
                                  },
                                ),
                              ),
                            ),
                          ],
                        )
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                Container(
                  height: screenHeight * 0.055,
                  width: screenWidth * 0.35,
                  decoration: BoxDecoration(
                      color: Color(0xff7885f8).withOpacity(0.7),
                      borderRadius: BorderRadius.circular(15)),
                  child: ElevatedButton(
                    style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.all(Colors.transparent),
                        shadowColor:
                            MaterialStateProperty.all(Colors.transparent)),
                    child: Text(
                      '로그인',
                      style: TextStyle(color: Colors.white),
                    ),
                    onPressed: () {
                      if (_EmailController.text.isEmpty ||
                          _PasswordController.text.isEmpty) {
                        showDialog(
                            context: context,
                            builder: (context) => AlertDialog(
                                  title: Text('알림'),
                                  content: Text('공란이 있습니다.'),
                                  actions: [
                                    TextButton(
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Text("확인"))
                                  ],
                                ));
                      } else {
                        checkData();
                      }
                    },
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
