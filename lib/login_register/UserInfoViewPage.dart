import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserInfoViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('사용자 정보 확인'),
      ),
      body: UserInfoDisplay(),
    );
  }
}

class UserInfoDisplay extends StatefulWidget {
  @override
  _UserInfoDisplayState createState() => _UserInfoDisplayState();
}

class _UserInfoDisplayState extends State<UserInfoDisplay> {
  String name = '';
  String gender = '';
  String height = '';
  String weight = '';
  String bloodType = '';
  String disease = '';
  @override
  void initState() {
    _loadUserInfo();
    super.initState();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    String loadedName = user_info.getString('name') ?? '';
    String loadedBloodType = user_info.getString('bloodType') ?? '';
    String loadedDisease = user_info.getString('disease') ?? '';
    String loadgender = user_info.getString('gender') ?? '';
    String loadheight = user_info.getString('height') ?? '';
    String loadweight = user_info.getString('weight') ?? '';

    setState(() {
      name = loadedName;
      bloodType = loadedBloodType;
      disease = loadedDisease;
      gender = loadgender;
      height = loadheight;
      weight = loadweight;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text('이름: $name', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Text('혈액형: $bloodType', style: TextStyle(fontSize: 20)),
          SizedBox(height: 10),
          Text('지병: $disease', style: TextStyle(fontSize: 20)),
        ],
      ),
    );
  }
}
