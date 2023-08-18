// ignore_for_file: use_build_context_synchronously, non_constant_identifier_names, unnecessary_string_interpolations, prefer_interpolation_to_compose_strings, unused_element, no_leading_underscores_for_local_identifiers, unnecessary_import
import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Setuser extends StatefulWidget {
  const Setuser({super.key});

  @override
  State<Setuser> createState() => _SetuserState();
}

class _SetuserState extends State<Setuser> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _bloodTypeController = TextEditingController();
  TextEditingController _diseaseController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  List<Widget> textFieldList = [];
  int id = 0;
  @override
  void initState() {
    super.initState();
  }

  Future<void> _saveUserInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setString('name', _nameController.text);
    user_info.setString('bloodType', _bloodTypeController.text);
    user_info.setString('gender', _genderController.text);
    user_info.setString('height', _heightController.text);
    user_info.setString('weight', _weightController.text);
    user_info.setString('disease', _diseaseController.text);
  }

  void postData(String name, String gender, String weight, String height,
      String bloody) async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    String password = user_info.getString('Password') ?? '';
    String email = user_info.getString('Email') ?? '';

    const String url =
        'https://medisign-hackthon-95c791df694a.herokuapp.com/users/User_list';
    Map<String, dynamic> data = {
      "name": "$name",
      "password": "$password",
      "email": "$email",
      "gender": "$gender",
      "weight": int.parse(weight),
      "height": int.parse(height),
      "blood_type": "$bloody",
      "disease": [],
      "username": "$name"
    };
    var body = jsonEncode(data);
    var response = await http.post(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: body);
    if (response.statusCode == 200) {
      response = await http.get(Uri.parse(url + '/$id'));
      if (response.statusCode == 200) {
        final users = jsonDecode(response.body);
        for (final user in users) {
          if (user['email'] == email && user['password'] == password) {
            Future<void> _saveRegisterInfo() async {
              SharedPreferences user_info =
                  await SharedPreferences.getInstance();
              user_info.setInt('id', user['id']);
              Navigator.pushNamed(context, '/');
            }

            break;
          }
        }
      } else {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
                    title: Text('알림'),
                    content: Text('통신 오류1'),
                    actions: [
                      TextButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          child: Text("확인"))
                    ]));
      }
    } else {
      showDialog(
          context: context,
          builder: (context) =>
              AlertDialog(title: Text('알림'), content: Text('오류2'), actions: [
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("확인"))
              ]));
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
        body: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
      Container(
        width: screenWidth,
        child: Column(children: [
          TextField(
            controller: _nameController,
            decoration: InputDecoration(labelText: '이름'),
          ),
          TextField(
            controller: _genderController,
            decoration: InputDecoration(labelText: '성별'),
          ),
          TextField(
            controller: _bloodTypeController,
            decoration: InputDecoration(labelText: '혈액형'),
          ),
          TextField(
            controller: _diseaseController,
            decoration: InputDecoration(labelText: '질병'),
          ),
          TextField(
            controller: _heightController,
            decoration: InputDecoration(labelText: '키'),
          ),
          TextField(
            controller: _weightController,
            decoration: InputDecoration(labelText: '몸무게'),
          )
        ]),
      ),
      ElevatedButton(
          onPressed: () {
            _saveUserInfo;
            if (_nameController.text.isEmpty ||
                _bloodTypeController.text.isEmpty ||
                _genderController.text.isEmpty ||
                _heightController.text.isEmpty ||
                _weightController.text.isEmpty) {
              showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                          title: Text('알림'),
                          content: Text('공란'),
                          actions: [
                            TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Text("확인"))
                          ]));
            } else {
              postData(
                _nameController.text,
                _genderController.text,
                _heightController.text,
                _weightController.text,
                _bloodTypeController.text,
              );
            }
          },
          child: Text('저장'))
    ]));
  }
}
