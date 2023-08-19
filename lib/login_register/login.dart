// ignore_for_file: use_build_context_synchronously, prefer_typing_uninitialized_variables, non_constant_identifier_names, unnecessary_null_in_if_null_operators

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
  TextEditingController _emailController = TextEditingController();
  TextEditingController _passwordController = TextEditingController();
  late String email;
  late String password;
  var User;
  void checkData() async {
    email = _emailController.text;
    password = _passwordController.text;

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
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
          appBar: AppBar(
            title: Text('로그인'),
            centerTitle: true,
          ),
          body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: '이메일'),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: '비밀번호'),
            ),
            ElevatedButton(
              onPressed: () {
                if (_emailController.text.isEmpty ||
                    _passwordController.text.isEmpty) {
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
              child: Text('로그인'),
            ),
            ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/Register');
                },
                child: Text('회원가입'))
          ])),
    );
  }
}
