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
  int id = 0;
  List<Widget> Medi_Bot_History = [];

  @override
  void initState() {
    super.initState();
    _loadUserinfo();
    // get_history();
  }

  Future<void> _loadUserinfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();

    id = user_info.getInt('id') ?? 0;
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
      padding: EdgeInsets.only(right: 18),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.only(
              topLeft: Radius.circular(15),
              bottomLeft: Radius.circular(15),
              bottomRight: Radius.circular(15)),
          color: Colors.white.withOpacity(0.9),
        ),
        child: Text(input),
      ),
    ));
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
                                  User_Input('약정보관련');
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
                                onPressed: () {},
                                child: Text(
                                  '처방전 관련',
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
                                onPressed: () {},
                                child: Text(
                                  '증상 관련',
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
                                onPressed: () {},
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
      body: Container(
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
          children: [
            Container(
              height: screenHeight * 0.9,
              child: Column(
                children: [
                  Default_Logo(),
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
            Container(
              width: screenWidth * 0.8,
              color: Colors.transparent,
              child: TextField(
                autofocus: false,
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 15, vertical: -7),
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(
                        Radius.circular(30),
                      ),
                      borderSide: BorderSide(color: Colors.transparent)),
                  filled: true, // TextField 내부를 채우려면 이 값을 true로 설정하세요.
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
                    onPressed: () {},
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
