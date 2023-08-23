import 'package:http/http.dart' as http;
// ignore_for_file: sort_child_properties_last

import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

class Change_Info_Page extends StatefulWidget {
  @override
  _Change_Info_PageState createState() => _Change_Info_PageState();
}

class _Change_Info_PageState extends State<Change_Info_Page> {
  late int id;
  TextEditingController _PasswordController = TextEditingController();
  TextEditingController _NameController = TextEditingController();
  TextEditingController _EmailController = TextEditingController();
  bool _Is_Male = true;
  TextEditingController _HeightController = TextEditingController();
  TextEditingController _WeightController = TextEditingController();
  late String blood_type = 'A';
  List<String> Blood_Type_List = ['A', 'B', "AB", "O"];
  List<String> Disease_List = [];
  List<Widget> Disease_Widget = [];
  bool disease_window = false;
  bool disease_1 = false;
  bool disease_2 = false;
  bool disease_3 = false;
  bool disease_4 = false;
  bool disease_5 = false;
  bool disease_6 = false;
  bool disease_7 = false;
  bool disease_8 = false;
  bool disease_9 = false;
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  void Add_Deisease() {
    setState(() {
      Disease_Widget = [];
    });
    setState(() {
      for (var disease in Disease_List) {
        Disease_Widget.add(Row(
          children: [
            Icon(
              Icons.circle,
              color: Colors.black,
              size: 10,
            ),
            SizedBox(width: 5),
            Text(
              disease,
              style: TextStyle(color: Colors.black, fontSize: 17),
            ),
          ],
        ));
      }
    });
  }

  Future<void> _saveRegisterInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setString('Email', _EmailController.text);
    user_info.setString('Password', _PasswordController.text);
  }

  void _saveUserInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setString('name', _NameController.text);
    user_info.setString('email', _EmailController.text);
    user_info.setString('password', _PasswordController.text);
    user_info.setString('password', blood_type);
    user_info.setString('gender', _Is_Male ? '남자' : '여자');
    user_info.setInt('weight', int.parse(_WeightController.text));
    user_info.setInt('height', int.parse(_HeightController.text));
    user_info.setStringList('disease', Disease_List);
  }

  void _loadUserInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    List de = user_info.getStringList('disease') ?? [];
    setState(() {
      id = user_info.getInt('id') ?? 0;
      _NameController.text = user_info.getString('name') ?? '';
      _EmailController.text = user_info.getString('email') ?? '';
      _PasswordController.text = user_info.getString('password') ?? '';
      blood_type = user_info.getString('bloodType') ?? 'A';
      _Is_Male = user_info.getString('gender') == '남자' ? true : false;
      _WeightController.text = '${user_info.getInt('weight')}';
      _HeightController.text = '${user_info.getInt('height')}';
      if (de.contains('당뇨')) {
        disease_1 = true;
      }
      if (de.contains('뇌졸증')) {
        disease_2 = true;
      }
      if (de.contains('암')) {
        disease_3 = true;
      }
      if (de.contains('간염')) {
        disease_4 = true;
      }
      if (de.contains('동맥경화')) {
        disease_5 = true;
      }
      if (de.contains('폐질환')) {
        disease_6 = true;
      }
      if (de.contains('치매')) {
        disease_7 = true;
      }
      if (de.contains('심근경색')) {
        disease_8 = true;
      }
      if (de.contains('천식')) {
        disease_9 = true;
      }
    });
  }

  void postData(String name, bool gender, String weight, String height,
      String bloody, String password, String email) async {
    int w = int.parse(weight);
    int h = int.parse(height);
    String url =
        'https://medisign-hackthon-95c791df694a.herokuapp.com/users/User_list/$id';
    Map<String, dynamic> data = {
      "name": "$name",
      "password": "$password",
      "email": "$email",
      "gender": gender ? "남자" : "여자",
      "weight": w,
      "height": h,
      "blood_type": "$bloody",
      "username": "$name",
      "disease": Disease_List
    };
    var body = jsonEncode(data);
    var response = await http.patch(Uri.parse(url),
        headers: {'Content-Type': 'application/json'}, body: body);
    if (response.statusCode == 201) {
      response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final users = jsonDecode(response.body);
        for (final user in users) {
          if (user['email'] == email && user['password'] == password) {
            Future<void> _saveRegisterInfo() async {
              SharedPreferences user_info =
                  await SharedPreferences.getInstance();
              user_info.setInt('id', user['id']);
            }

            Navigator.pushNamed(context, '/');

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
          builder: (context) => AlertDialog(
                  title: Text('알림'),
                  content: Text(
                      '${response.statusCode} $name $gender $weight $height $bloody $password $email'),
                  actions: [
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
        body: SingleChildScrollView(
      child: Container(
        constraints:
            BoxConstraints(minHeight: screenHeight, minWidth: screenWidth),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xff627BFD), Color(0xffE3EBFF)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
              height: screenHeight * 0.05,
            ),
            Text(
              '정보 수정',
              style: TextStyle(color: Colors.white, fontSize: 20),
            ),
            SizedBox(
              height: 20,
            ),
            Stack(
              children: [
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.7),
                        borderRadius: BorderRadius.circular(15)),
                    width: screenWidth * 0.9,
                    height: min(screenHeight * 0.8, screenHeight * 2),
                    child: Column(
                      children: [
                        SizedBox(height: screenHeight * 0.05),
                        Image(image: AssetImage('assets/image/graph 1.png')),
                        Container(
                            width: screenWidth * 0.77,
                            child: TextField(
                              controller: _NameController,
                              autofocus: true,
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: '이름',
                                  border: InputBorder.none),
                              cursorColor: Colors.transparent,
                            )),
                        Container(
                          width: screenWidth * 0.77,
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                            width: screenWidth * 0.77,
                            child: TextField(
                              controller: _EmailController,
                              autofocus: true,
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                  isDense: true,
                                  hintText: '이메일',
                                  border: InputBorder.none),
                              cursorColor: Colors.transparent,
                            )),
                        Container(
                          width: screenWidth * 0.77,
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                            width: screenWidth * 0.77,
                            child: TextField(
                              controller: _PasswordController,
                              autofocus: true,
                              textDirection: TextDirection.rtl,
                              decoration: InputDecoration(
                                isDense: true,
                                border: InputBorder.none,
                                hintText: '비밀번호',
                              ),
                              cursorColor: Colors.transparent,
                            )),
                        Container(
                          width: screenWidth * 0.77,
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                            width: screenWidth * 0.77,
                            child: Stack(
                              children: [
                                TextField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: '성별',
                                  ),
                                  cursorColor: Colors.transparent,
                                ),
                                Transform.translate(
                                  offset: Offset(0, 6),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      Text('남'),
                                      Container(
                                        width: 25,
                                        height: 25,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: _Is_Male
                                                  ? MaterialStateProperty.all(
                                                      Colors.blue[800])
                                                  : MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                    side: BorderSide(
                                                        color: Colors.black)),
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _Is_Male = true;
                                              });
                                            },
                                            child: _Is_Male
                                                ? Transform.translate(
                                                    offset: Offset(-10, 0),
                                                    child: Icon(
                                                      Icons.check,
                                                    ),
                                                  )
                                                : Container(
                                                    width: 1, height: 1)),
                                      ),
                                      SizedBox(width: screenWidth * 0.01),
                                      Text('여'),
                                      Container(
                                        width: 25,
                                        height: 25,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                              backgroundColor: _Is_Male
                                                  ? MaterialStateProperty.all(
                                                      Colors.transparent)
                                                  : MaterialStateProperty.all(
                                                      Colors.blue[800]),
                                              shadowColor:
                                                  MaterialStateProperty.all(
                                                      Colors.transparent),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                    side: BorderSide(
                                                        color: Colors.black)),
                                              ),
                                            ),
                                            onPressed: () {
                                              setState(() {
                                                _Is_Male = false;
                                              });
                                            },
                                            child: _Is_Male
                                                ? Container(width: 1, height: 1)
                                                : Transform.translate(
                                                    offset: Offset(-10, 0),
                                                    child: Icon(
                                                      Icons.check,
                                                    ),
                                                  )),
                                      ),
                                    ],
                                  ),
                                )
                              ],
                            )),
                        Container(
                          width: screenWidth * 0.77,
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                            width: screenWidth * 0.77,
                            child: Stack(
                              children: [
                                TextField(
                                  controller: _HeightController,
                                  textDirection: TextDirection.rtl,
                                  decoration: InputDecoration(
                                    contentPadding: EdgeInsets.only(
                                        right: 27, top: 7, bottom: 7),
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: '키',
                                  ),
                                  cursorColor: Colors.transparent,
                                ),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Transform.translate(
                                        offset: Offset(0, 8),
                                        child: Text('CM')),
                                  ],
                                )
                              ],
                            )),
                        Container(
                          width: screenWidth * 0.77,
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                            width: screenWidth * 0.77,
                            child: Stack(
                              children: [
                                TextField(
                                  textDirection: TextDirection.rtl,
                                  controller: _WeightController,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    contentPadding: EdgeInsets.only(
                                        right: 27, top: 7, bottom: 7),
                                    hintText: '몸무게',
                                  ),
                                  cursorColor: Colors.transparent,
                                ),
                                Row(
                                  textDirection: TextDirection.rtl,
                                  children: [
                                    Transform.translate(
                                        offset: Offset(0, 8),
                                        child: Text('kg')),
                                  ],
                                )
                              ],
                            )),
                        Container(
                          width: screenWidth * 0.77,
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                            width: screenWidth * 0.77,
                            child: Stack(
                              children: [
                                Column(
                                  children: [
                                    TextField(
                                      readOnly: true,
                                      decoration: InputDecoration(
                                        isDense: true,
                                        border: InputBorder.none,
                                        hintText: '혈액형',
                                      ),
                                      cursorColor: Colors.transparent,
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    DropdownButton(
                                      items: Blood_Type_List.map((String item) {
                                        return DropdownMenuItem<String>(
                                            child: Text('$item'), value: item);
                                      }).toList(),
                                      onChanged: (dynamic value) {
                                        setState(() {
                                          blood_type = value;
                                        });
                                      },
                                      value: '$blood_type',
                                    )
                                  ],
                                )
                              ],
                            )),
                        Container(
                          width: screenWidth * 0.77,
                          child: Divider(
                            height: 1,
                            thickness: 1,
                            color: Colors.black,
                          ),
                        ),
                        Container(
                            width: screenWidth * 0.77,
                            child: Stack(
                              children: [
                                TextField(
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    isDense: true,
                                    border: InputBorder.none,
                                    hintText: '나의 지병',
                                  ),
                                  cursorColor: Colors.transparent,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          disease_window = true;
                                        });
                                      },
                                      child: Text(
                                        '지병 정보 수정',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 13),
                                      ),
                                      style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(30),
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                Color.fromRGBO(
                                                    217, 217, 217, 1)),
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            )),
                        Container(
                          width: screenWidth * 0.77,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: Disease_Widget,
                          ),
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            onPressed: () {
                              if (_EmailController.text.isEmpty ||
                                  _PasswordController.text.isEmpty ||
                                  _HeightController.text.isEmpty ||
                                  _WeightController.text.isEmpty) {
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
                              _saveUserInfo();
                              postData(
                                  _NameController.text,
                                  _Is_Male,
                                  _WeightController.text,
                                  _HeightController.text,
                                  blood_type,
                                  _PasswordController.text,
                                  _EmailController.text);
                              Navigator.pushNamed(context, '/');
                            },
                            child: Stack(
                              children: [
                                Icon(
                                  Icons.mode_edit_outlined,
                                  color: Colors.black,
                                  size: 18,
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      '회원가입 완료',
                                      style: TextStyle(
                                          color: Colors.black, fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            style: ButtonStyle(
                              shape: MaterialStateProperty.all<
                                  RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(30),
                                ),
                              ),
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  Color.fromRGBO(217, 217, 217, 1)),
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                disease_window
                    ? Container(
                        decoration: BoxDecoration(color: Colors.white),
                        margin: EdgeInsets.only(
                            top: screenHeight * 0.45,
                            left: screenWidth * 0.06,
                            right: screenWidth * 0.06),
                        padding: EdgeInsets.only(top: 10, bottom: 10, left: 10),
                        width: screenWidth * 0.78,
                        child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Container(
                                      padding: EdgeInsets.only(right: 30),
                                      child: Row(
                                        children: [
                                          Text('당뇨'),
                                          Spacer(),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: disease_1
                                                      ? MaterialStateProperty
                                                          .all(Colors.blue[800])
                                                      : MaterialStateProperty
                                                          .all(Colors
                                                              .transparent),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      side: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (disease_1 == true) {
                                                    setState(() {
                                                      disease_1 = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      disease_1 = true;
                                                    });
                                                  }
                                                },
                                                child: disease_1
                                                    ? Transform.translate(
                                                        offset: Offset(-13, 0),
                                                        child: Icon(
                                                          Icons.check,
                                                          size: 18,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 1, height: 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Container(
                                      padding: EdgeInsets.only(right: 30),
                                      child: Row(
                                        children: [
                                          Text('뇌졸증'),
                                          Spacer(),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: disease_2
                                                      ? MaterialStateProperty
                                                          .all(Colors.blue[800])
                                                      : MaterialStateProperty
                                                          .all(Colors
                                                              .transparent),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      side: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (disease_2 == true) {
                                                    setState(() {
                                                      disease_2 = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      disease_2 = true;
                                                    });
                                                  }
                                                },
                                                child: disease_2
                                                    ? Transform.translate(
                                                        offset: Offset(-13, 0),
                                                        child: Icon(
                                                          Icons.check,
                                                          size: 18,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 1, height: 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Row(
                                        children: [
                                          Text('암'),
                                          Spacer(),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: disease_3
                                                      ? MaterialStateProperty
                                                          .all(Colors.blue[800])
                                                      : MaterialStateProperty
                                                          .all(Colors
                                                              .transparent),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      side: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (disease_3 == true) {
                                                    setState(() {
                                                      disease_3 = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      disease_3 = true;
                                                    });
                                                  }
                                                },
                                                child: disease_3
                                                    ? Transform.translate(
                                                        offset: Offset(-13, 0),
                                                        child: Icon(
                                                          Icons.check,
                                                          size: 18,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 1, height: 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 30),
                                      child: Row(
                                        children: [
                                          Text('간염'),
                                          Spacer(),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: disease_4
                                                      ? MaterialStateProperty
                                                          .all(Colors.blue[800])
                                                      : MaterialStateProperty
                                                          .all(Colors
                                                              .transparent),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      side: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (disease_4 == true) {
                                                    setState(() {
                                                      disease_4 = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      disease_4 = true;
                                                    });
                                                  }
                                                },
                                                child: disease_4
                                                    ? Transform.translate(
                                                        offset: Offset(-13, 0),
                                                        child: Icon(
                                                          Icons.check,
                                                          size: 18,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 1, height: 1)),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Row(
                                        children: [
                                          Text('동맥경화'),
                                          Spacer(),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: disease_5
                                                      ? MaterialStateProperty
                                                          .all(Colors.blue[800])
                                                      : MaterialStateProperty
                                                          .all(Colors
                                                              .transparent),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      side: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (disease_5 == true) {
                                                    setState(() {
                                                      disease_5 = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      disease_5 = true;
                                                    });
                                                  }
                                                },
                                                child: disease_5
                                                    ? Transform.translate(
                                                        offset: Offset(-13, 0),
                                                        child: Icon(
                                                          Icons.check,
                                                          size: 18,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 1, height: 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Row(
                                        children: [
                                          Text('폐질환'),
                                          Spacer(),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: disease_6
                                                      ? MaterialStateProperty
                                                          .all(Colors.blue[800])
                                                      : MaterialStateProperty
                                                          .all(Colors
                                                              .transparent),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      side: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (disease_6 == true) {
                                                    setState(() {
                                                      disease_6 = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      disease_6 = true;
                                                    });
                                                  }
                                                },
                                                child: disease_6
                                                    ? Transform.translate(
                                                        offset: Offset(-13, 0),
                                                        child: Icon(
                                                          Icons.check,
                                                          size: 18,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 1, height: 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Row(
                                        children: [
                                          Text('치매'),
                                          Spacer(),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: disease_7
                                                      ? MaterialStateProperty
                                                          .all(Colors.blue[800])
                                                      : MaterialStateProperty
                                                          .all(Colors
                                                              .transparent),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      side: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (disease_7 == true) {
                                                    setState(() {
                                                      disease_7 = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      disease_7 = true;
                                                    });
                                                  }
                                                },
                                                child: disease_7
                                                    ? Transform.translate(
                                                        offset: Offset(-13, 0),
                                                        child: Icon(
                                                          Icons.check,
                                                          size: 18,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 1, height: 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.01),
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Row(
                                        children: [
                                          Text('심근경색'),
                                          Spacer(),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: disease_8
                                                      ? MaterialStateProperty
                                                          .all(Colors.blue[800])
                                                      : MaterialStateProperty
                                                          .all(Colors
                                                              .transparent),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      side: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (disease_8 == true) {
                                                    setState(() {
                                                      disease_8 = false;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      disease_8 = true;
                                                    });
                                                  }
                                                },
                                                child: disease_8
                                                    ? Transform.translate(
                                                        offset: Offset(-13, 0),
                                                        child: Icon(
                                                          Icons.check,
                                                          size: 18,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 1, height: 1)),
                                          )
                                        ],
                                      ),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(right: 20),
                                      child: Row(
                                        children: [
                                          Text('천식'),
                                          Spacer(),
                                          Container(
                                            width: 20,
                                            height: 20,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor: disease_9
                                                      ? MaterialStateProperty
                                                          .all(Colors.blue[800])
                                                      : MaterialStateProperty
                                                          .all(Colors
                                                              .transparent),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                      side: BorderSide(
                                                          color: Colors.black),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  if (disease_9 == false) {
                                                    setState(() {
                                                      disease_9 = true;
                                                    });
                                                  } else {
                                                    setState(() {
                                                      disease_9 = false;
                                                    });
                                                  }
                                                },
                                                child: disease_9
                                                    ? Transform.translate(
                                                        offset: Offset(-13, 0),
                                                        child: Icon(
                                                          Icons.check,
                                                          size: 18,
                                                        ),
                                                      )
                                                    : Container(
                                                        width: 1, height: 1)),
                                          )
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: screenHeight * 0.06),
                                    Container(
                                      width: screenWidth * 0.22,
                                      child: ElevatedButton(
                                        onPressed: () {
                                          if (disease_1 == true) {
                                            setState(() {
                                              Disease_List.add('당뇨');
                                            });
                                          }
                                          if (disease_2 == true) {
                                            setState(() {
                                              Disease_List.add('뇌졸증');
                                            });
                                          }
                                          if (disease_3 == true) {
                                            setState(() {
                                              Disease_List.add('암');
                                            });
                                          }
                                          if (disease_4 == true) {
                                            setState(() {
                                              Disease_List.add('간염');
                                            });
                                          }
                                          if (disease_5 == true) {
                                            setState(() {
                                              Disease_List.add('동맥경화');
                                            });
                                          }
                                          if (disease_6 == true) {
                                            setState(() {
                                              Disease_List.add('폐질환');
                                            });
                                          }
                                          if (disease_7 == true) {
                                            setState(() {
                                              Disease_List.add('치매');
                                            });
                                          }
                                          if (disease_8 == true) {
                                            setState(() {
                                              Disease_List.add('심근경색');
                                            });
                                          }
                                          if (disease_9 == true) {
                                            setState(() {
                                              Disease_List.add('천식');
                                            });
                                          }
                                          Add_Deisease();
                                          disease_window = false;
                                        },
                                        child: Text(
                                          '선택 완료',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 14)
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(30)
                                            )
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color.fromRGBO(
                                                      217, 217, 217, 1))
                                        )
                                      )
                                    )
                                  ]
                                )
                              )
                            ])
                      )
                    : Column()
              ],
            ),
          ],
        ),
      ),
    ));
  }
}
