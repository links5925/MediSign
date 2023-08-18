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

    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      AlertDialog(
        title: Text('알림'),
        content: Text('기재되지 않은 사항이 있습니다.'),
        actions: [
          TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text("확인"))
        ],
      );
    } else {
      const String url =
          'https://medisign-hackthon-95c791df694a.herokuapp.com/users/User_list';
      var response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        for (final user in data) {
          if (user['email'] == email && user['password'] == password) {
            // email 값과 password 값이 일치하는 데이터를 찾았을 때, 해당 데이터를 반환합니다.
            User = user;
          } else {
            AlertDialog(
              title: Text('알림'),
              content: Text('아이디,비밀번호가 틀림 '),
              actions: [TextButton(onPressed: () {}, child: Text("확인"))],
            );
          }
        }
      } else {
        AlertDialog(
          title: Text('알림'),
          content: Text('오류가 발생했습니다'),
          actions: [TextButton(onPressed: () {}, child: Text("확인"))],
        );
      }
    }
  }

  void loaduserinfo(Map<String, dynamic> User) async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setString('Email', User['email']);
    user_info.setString('name', User['email']);
    user_info.setString('birthdate', User['birth_date']);
    user_info.setString('bloodType', User['blood_type']);
    user_info.setString('gender', User['gender']);
    user_info.setString('height', User['height']);
    user_info.setString('weight', User['weight']);
    user_info.setString('disease', User['disease']);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('로그인')),
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
              checkData();
            },
            child: Text('로그인'),
          ),
          ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/Register');
              },
              child: Text('회원가입'))
        ]));
  }
}
