// ignore_for_file: non_constant_identifier_names, unused_import, library_private_types_in_public_api, unnecessary_import

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

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
    return Scaffold(
      appBar: AppBar(
        title: Text('유저 정보 기입란'),
        centerTitle: true,
      ),
      body: Center(
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
                      _saveRegisterInfo;
                      Navigator.pushNamed(context, '/user_set');
                    },
                    child: Text('다음'))
              ],
            ),
          ],
        ),
      ),
    );
  }
}
