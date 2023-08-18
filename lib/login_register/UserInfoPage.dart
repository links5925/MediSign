import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoPage extends StatefulWidget {
  @override
  _UserInfoPageState createState() => _UserInfoPageState();
}

class _UserInfoPageState extends State<UserInfoPage> {
  TextEditingController _nameController = TextEditingController();
  TextEditingController _birthdateController = TextEditingController();
  TextEditingController _bloodTypeController = TextEditingController();
  TextEditingController _diseaseController = TextEditingController();
  TextEditingController _genderController = TextEditingController();
  TextEditingController _heightController = TextEditingController();
  TextEditingController _weightController = TextEditingController();
  List<Widget> textFieldList = [];

  @override
  void initState() {
    super.initState();
    _loadUserInfo();
    textedit();
  }

  void textedit() {
    textFieldList = [];
    Map<String, TextEditingController> textFields = {
      '이름': _nameController,
      '생년월일': _birthdateController,
      '성별': _genderController,
      '혈액형': _bloodTypeController,
      '질병': _diseaseController,
      '키': _heightController,
      '몸무게': _weightController,
    };
    for (var field in textFields.keys) {
      textFieldList.add(TextField(
        controller: textFields['key'],
        decoration: InputDecoration(labelText: field),
      ));
    }
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    String Email = user_info.getString('Email') ?? '';
    String Password = user_info.getString('Password') ?? '';
    String name = user_info.getString('name') ?? '';
    String birthdate = user_info.getString('birthdate') ?? '';
    String bloodType = user_info.getString('bloodType') ?? '';
    String disease = user_info.getString('disease') ?? '';
    String gender = user_info.getString('gender') ?? '';
    String height = user_info.getString('height') ?? '';
    String weight = user_info.getString('weight') ?? '';

    setState(() {
      _nameController.text = name;
      _birthdateController.text = birthdate;
      _bloodTypeController.text = bloodType;
      _diseaseController.text = disease;
      _genderController.text = gender;
      _heightController.text = height;
      _weightController.text = weight;
    });
  }

  Future<void> _saveUserInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    if (_nameController.text.isEmpty ||
        _birthdateController.text.isEmpty ||
        _bloodTypeController.text.isEmpty ||
        _genderController.text.isEmpty ||
        _heightController.text.isEmpty ||
        _weightController.text.isEmpty ||
        _diseaseController.text.isEmpty) {
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
      user_info.setString('name', _nameController.text);
      user_info.setString('birthdate', _birthdateController.text);
      user_info.setString('bloodType', _bloodTypeController.text);
      user_info.setString('gender', _genderController.text);
      user_info.setString('height', _heightController.text);
      user_info.setString('weight', _weightController.text);
      user_info.setString('disease', _diseaseController.text);
    }
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
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: textFieldList,
            ),
            ElevatedButton(
              onPressed: () {
                _saveUserInfo();
              },
              child: Text('회원가입'),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, '/UserInfoView');
              },
              child: Text('정보 확인'),
            ),
          ],
        ),
      ),
    );
  }
}
