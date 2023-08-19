import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class RegisterPgae extends StatefulWidget {
  @override
  _RegisterPgaeState createState() => _RegisterPgaeState();
}

class _RegisterPgaeState extends State<RegisterPgae> {
  TextEditingController _PasswordController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveRegisterInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setString('Email', _EmailController.text);
    user_info.setString('Password', _PasswordController.text);
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      appBar: AppBar(
        title: Text('유저 정보 기입란'),
        centerTitle: true,
      ),
      body: Center(
        child: Container(
          width: screenWidth,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextField(
                controller: _EmailController,
                decoration: InputDecoration(labelText: '이메일'),
              ),
              TextField(
                controller: _PasswordController,
                decoration: InputDecoration(labelText: '비밀번호'),
              ),
              Row(
                children: [
                  ElevatedButton(
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
                          _saveRegisterInfo;
                          Navigator.pushNamed(context, '/user_set');
                        }
                      },
                      child: Text('다음'))
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}