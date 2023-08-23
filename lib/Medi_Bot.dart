// ignore_for_file: sort_child_properties_last
//id랑 history이름 화긴, 경로 화긴
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Default_set/Default_Logo.dart';

class Medi_Bot extends StatefulWidget {
  const Medi_Bot({super.key});

  @override
  State<Medi_Bot> createState() => _Medi_BotState();
}

class _Medi_BotState extends State<Medi_Bot> {
  bool status = true;
  double screenWidth = 1;
  double screenHeight = 1;
  int? id;
  TextEditingController control = TextEditingController();
  List<Widget> Medi_Bot_History = [];

  @override
  void initState() {
    super.initState();
    _loadUserinfo();
  }

  Future<void> _loadUserinfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    int? loadid = user_info.getInt('id');
    int loadscreenWidth = user_info.getInt('Width') ?? 0;
    int loadscreenHeight = user_info.getInt('Height') ?? 0;

    setState(() {
      id = loadid;
      screenWidth = loadscreenWidth.toDouble();
      screenHeight = loadscreenHeight.toDouble();
    });
  }

  Future<void> get_history() async {
    final response = await http.get(
        Uri.parse('https://medisign-hackthon-95c791df694a.herokuapp.com/user'));
    if (response.statusCode == 200) {
      // API 응답을 JSON으로 변환하여 파싱
      List<Map<String, dynamic>> responseData = json.decode(response.body);
      for (var history in responseData) {
        if (id == history['id']) {
          Medi_Bot_History.add(history['history']);
        }
      }
      setState(() {
        // Medi_Bot_History= responseData;
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  void User_Input(String input) {
    Medi_Bot_History.add(Padding(
      padding: EdgeInsets.only(top: 18, right: 19),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          Container(
            padding: EdgeInsets.only(top: 12, bottom: 12, left: 17, right: 17),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  bottomLeft: Radius.circular(15),
                  bottomRight: Radius.circular(15)),
              color: Colors.white.withOpacity(0.9),
            ),
            child: Text(input),
          ),
        ],
      ),
    ));
    if (input == '약 정보 관련') {
      Medi_Bot_History.add(Medi_Bot_Return1());
    } else if (input == '처방전 관련') {
      Medi_Bot_History.add(Medi_Bot_Return2(input));
    } else if (input == '처방전 등록방법') {
      Medi_Bot_History.add(Medi_Bot_Return2_1());
    } else if (input == '처방전 유효기간') {
      Medi_Bot_History.add(Medi_Bot_Return2_2());
    } else if (input == '처방전이 없을 때') {
      Medi_Bot_History.add(Medi_Bot_Return2_3());
    } else if (input == '상호작용 관련') {
      Medi_Bot_History.add(Medi_Bot_Return3());
    } else if (input == '어플 관련') {
      Medi_Bot_History.add(Medi_Bot_Return4());
    }
    setState(() {
      Medi_Bot_History;
    });
  }

  Medi_Bot_Return1() {
    setState(() {
      status = false;
    });
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.chat_bubble_outline),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('메디봇'),
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth * 0.75,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "약 정보와 관련하여 궁금한 점이 있으신가요?\n[약 이름]을 채팅으로 알려주세요.",
                            style: TextStyle(fontSize: screenWidth * 0.033),
                          ),
                          SizedBox(height: 4),
                          Text(
                            '*약의 주요 효능, 부작용, 복용 방법 등의 정보 제공',
                            style: TextStyle(fontSize: screenWidth * 0.025),
                          )
                        ],
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Medi_Bot_Return2(String user_input) {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.chat_bubble_outline),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('메디봇'),
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth * 0.75,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '안녕하세요. 메디봇입니다',
                            style: TextStyle(fontSize: screenWidth * 0.033),
                          ),
                          Text('궁금하신 사항에 대해서 선택해 주세요.',
                              style: TextStyle(fontSize: screenWidth * 0.033)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.66,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  User_Input('처방전 등록방법');
                                });
                              },
                              child: Text(
                                '처방전 등록방법',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(1),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.66,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  User_Input('처방전 유효기간');
                                });
                              },
                              child: Text(
                                '처방전 유효기간',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          30), // 버튼 가장자리를 동그랗게 만듭니다.
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(1),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.66,
                            child: ElevatedButton(
                              onPressed: () {
                                setState(() {
                                  User_Input('처방전이 없을 때');
                                });
                              },
                              child: Text(
                                '처방전이 없을 때',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          30), // 버튼 가장자리를 동그랗게 만듭니다.
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(1),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Medi_Bot_Return2_1() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.chat_bubble_outline),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('메디봇'),
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth * 0.75,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "처방전은 어플의 '메디렌즈' 기능을 통하여\n처방전을 촬영해 등록할 수 있습니다.\n\n처방전 촬영시, 약품명과 1회 투약량,\n1일 투요횟수, 총 투약일수의 정보가 자동으로 시스템에 입력됩니다.\n\n이대 다시 촬영하기 버튼을 사요아형 처방전의 사진을 다시 촬영할 수 있으며, 처방전의 내용과\n다른 경우 직접 입력하여 수정할 수 있습니다.\n\n또한, 약을 처방받은 약국을 저장하여 저장된\n정보는 '메디인포'의 '나의 조제 내역'과 '메디맵'의 약국의 지난내역에서 처방전을\n확인할 수 있습니다.",
                            style: TextStyle(fontSize: screenWidth * 0.033),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Medi_Bot_Return2_2() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.chat_bubble_outline),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('메디봇'),
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth * 0.75,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "처방전 유효기간은 발급일로부터 2일간\n 유효합니다.",
                            style: TextStyle(fontSize: screenWidth * 0.033),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Medi_Bot_Return2_3() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.chat_bubble_outline),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('메디봇'),
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth * 0.75,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Text(
                            "처방전이 없을 경우, 약을 처방받은 병원에\n 방문하여 환자보관용 처방전을 신청할 수 \n있습니다.",
                            style: TextStyle(fontSize: screenWidth * 0.033),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Medi_Bot_Return3() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.chat_bubble_outline),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('메디봇'),
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth * 0.75,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "상호작용은 현재 복용중인 약과 다른 처방받은\n약 또는 비타민과 영야제를 함께 복용했을 때에\n나타나는 것을 말합니다.\n\n이 기능은 공지사항의 약 상호관계 알림을 통하여\n등록된 약들의 상호관계를 자동으로 조사하여\n사용자에게 경고해주는 기능을 합니다.",
                            style: TextStyle(fontSize: screenWidth * 0.033),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  Medi_Bot_Return4() {
    return Padding(
      padding: EdgeInsets.only(left: 10),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.chat_bubble_outline),
          SizedBox(
            width: screenWidth * 0.02,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('메디봇'),
              SizedBox(
                height: 10,
              ),
              Container(
                width: screenWidth * 0.75,
                child: Container(
                  margin: EdgeInsets.all(10),
                  child: Column(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '안녕하세요. 메디봇입니다',
                            style: TextStyle(fontSize: screenWidth * 0.033),
                          ),
                          Text('궁금하신 사항에 대해서 선택해 주세요.',
                              style: TextStyle(fontSize: screenWidth * 0.033)),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          SizedBox(
                            width: screenWidth * 0.66,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/');
                              },
                              child: Text(
                                'MEDI.HOME(메디 홈)',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(30),
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(1),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.66,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/Medi_Info');
                              },
                              child: Text(
                                'MEDI.INFO(메디 인포)',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          30), // 버튼 가장자리를 동그랗게 만듭니다.
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(1),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.66,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/Directocr');
                              },
                              child: Text(
                                'MEDI.LENZ(메디 렌즈)',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          30), // 버튼 가장자리를 동그랗게 만듭니다.
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(1),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                            ),
                          ),
                          SizedBox(
                            width: screenWidth * 0.66,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushNamed(context, '/Medi_Map');
                              },
                              child: Text(
                                'MEDI.MAP(메디 맵)',
                                style: TextStyle(color: Colors.black),
                              ),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(
                                          30), // 버튼 가장자리를 동그랗게 만듭니다.
                                    ),
                                  ),
                                  elevation: MaterialStateProperty.all(1),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.white)),
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.9),
                  borderRadius: BorderRadius.only(
                      topRight: Radius.circular(15),
                      bottomLeft: Radius.circular(15),
                      bottomRight: Radius.circular(15)),
                ),
              )
            ],
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    default_medi_bot() {
      return (Padding(
        padding: EdgeInsets.only(left: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(Icons.chat_bubble_outline),
            SizedBox(
              width: screenWidth * 0.02,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('메디봇'),
                SizedBox(
                  height: 10,
                ),
                Container(
                  width: screenWidth * 0.75,
                  child: Container(
                    margin: EdgeInsets.all(10),
                    child: Column(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '안녕하세요. 메디봇입니다',
                              style: TextStyle(fontSize: screenWidth * 0.033),
                            ),
                            Text('궁금하신 사항에 대해서 선택해 주세요.',
                                style:
                                    TextStyle(fontSize: screenWidth * 0.033)),
                          ],
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              width: screenWidth * 0.66,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    User_Input('약 정보 관련');
                                  });
                                },
                                child: Text(
                                  '약 정보 관련',
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // 버튼 가장자리를 동그랗게 만듭니다.
                                      ),
                                    ),
                                    elevation: MaterialStateProperty.all(1),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white)),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.66,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    User_Input('처방전 관련');
                                  });
                                },
                                child: Text(
                                  '처방전 관련',
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    ),
                                    elevation: MaterialStateProperty.all(1),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white)),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.66,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    User_Input('상호작용 관련');
                                  });
                                },
                                child: Text(
                                  '상호작용 관련',
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // 버튼 가장자리를 동그랗게 만듭니다.
                                      ),
                                    ),
                                    elevation: MaterialStateProperty.all(1),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white)),
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.66,
                              child: ElevatedButton(
                                onPressed: () {
                                  setState(() {
                                    User_Input('어플 관련');
                                  });
                                },
                                child: Text(
                                  '어플 관련',
                                  style: TextStyle(color: Colors.black),
                                ),
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                            30), // 버튼 가장자리를 동그랗게 만듭니다.
                                      ),
                                    ),
                                    elevation: MaterialStateProperty.all(1),
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white)),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(15),
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15)),
                  ),
                )
              ],
            )
          ],
        ),
      ));
    }

    return Scaffold(
      body: SingleChildScrollView(
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff627BFD), Color(0xffE3EBFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Container(
                height: screenHeight * 0.9,
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      Stack(
                        children: [
                          Default_Logo(),
                          Padding(
                            padding: const EdgeInsets.all(20),
                            child: TextButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                child: Icon(
                                  Icons.keyboard_arrow_left_outlined,
                                  size: 45,
                                  color: Colors.white,
                                )),
                          )
                        ],
                      ),
                      SingleChildScrollView(
                          child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                default_medi_bot(),
                                Column(
                                  children: Medi_Bot_History,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ))
                    ],
                  ),
                ),
              ),
              Container(
                height: screenHeight * 0.1,
                width: screenWidth * 0.8,
                color: Colors.transparent,
                child: TextField(
                  controller: control,
                  readOnly: status,
                  autofocus: false,
                  decoration: InputDecoration(
                    contentPadding:
                        EdgeInsets.symmetric(horizontal: 15, vertical: -7),
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.all(
                          Radius.circular(30),
                        ),
                        borderSide: BorderSide(color: Colors.transparent)),
                    filled: true,
                    fillColor: Colors.white,
                    hintText: '메디봇에게 메시지 보내기',
                    hintStyle: TextStyle(
                      fontSize: screenWidth * 0.033, // 힌트 텍스트의 글꼴 크기 설정
                      color: Colors.grey, // 힌트 텍스트의 색상 설정
                      fontWeight: FontWeight.w400, // 힌트 텍스트의 폰트 굵기 설정,
                    ),
                    suffixIcon: IconButton(
                      icon: Icon(Icons.send),
                      iconSize: screenWidth * 0.06,
                      onPressed: () {
                        setState(() {});
                        if (control.text.isEmpty == false &&
                            control.text != '') {
                          status = true;
                          User_Input('${control.text}');
                        }
                        control.text = '';
                      },
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
