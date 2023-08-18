// ignore_for_file: sort_child_properties_last, prefer_const_literals_to_create_immutables, prefer_const_constructors
//경로 재설정

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Default_Drawer extends StatefulWidget {
  const Default_Drawer({super.key});

  @override
  State<Default_Drawer> createState() => _Default_DrawerState();
}

class _Default_DrawerState extends State<Default_Drawer> {
  String? name;
  String profile = '';
  bool namecheck = false;
  int id = 0;
  @override
  void initState() {
    _loadName();
    super.initState();
  }

  Future<void> _loadName() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    String name = user_info.getString('name') ?? '';
    profile = user_info.getString('profile') ?? '';
    id = user_info.getInt('id') ?? 0;
    if (name != '') {
      namecheck = true;
    }
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Drawer(
      shadowColor: Colors.transparent,
      backgroundColor: Colors.transparent,
      elevation: 0,
      child: SizedBox(
        height: screenHeight,
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            SizedBox(height: screenHeight * 0.08),
            SizedBox(
              height: screenHeight * 0.4,
              child: DrawerHeader(
                margin: EdgeInsets.all(0),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        SizedBox(
                          height: screenHeight * 0.021,
                          width: screenWidth * 0.2,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        20), // 버튼 가장자리를 동그랗게 만듭니다.
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff2036A7)),
                              ),
                              onPressed: () {
                                Navigator.pushNamed(context, '/Login');
                              },
                              child: Row(
                                children: [
                                  Text('내정보', style: TextStyle(fontSize: 10)),
                                  Transform.translate(
                                      offset: Offset(6, 1),
                                      child: Icon(
                                        Icons.keyboard_arrow_right_sharp,
                                        size: 10,
                                      ))
                                ],
                              )),
                        ),
                        SizedBox(
                          width: screenWidth * 0.02,
                        ),
                        SizedBox(
                          height: screenHeight * 0.021,
                          width: screenWidth * 0.24,
                          child: ElevatedButton(
                              style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(
                                        30), // 버튼 가장자리를 동그랗게 만듭니다.
                                  ),
                                ),
                                backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Color(0xff2036A7)),
                              ),
                              onPressed:
                                  () {}, //Navigator.pushNamed(context, '/확인');,
                              child: Row(
                                children: [
                                  Text(
                                    '로그아웃',
                                    style: TextStyle(fontSize: 10),
                                  ),
                                  Transform.translate(
                                      offset: Offset(6, 1),
                                      child: Icon(
                                        Icons.keyboard_arrow_right_sharp,
                                        size: 14,
                                      ))
                                ],
                              )),
                        ),
                      ],
                    ),
                    Padding(
                      padding: EdgeInsets.only(top: screenHeight * 0.03),
                      child: ClipOval(
                        child: Image.network(
                          namecheck
                              ? profile
                              : 'https://picsum.photos/200/200', // 이미지 URL
                          width: screenHeight * 0.12, // 원형 이미지의 가로
                          height: screenHeight * 0.12, // 원형 이미지의 세로 길이
                          fit: BoxFit.cover, // 이미지를 원형에 맞게 조정
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    namecheck
                        ? Text(
                            '$name님, 반가워요!',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          )
                        : Text(
                            '익명님, 반가워요!',
                            style: TextStyle(fontSize: 16, color: Colors.white),
                          ),
                    SizedBox(height: screenHeight * 0.005),
                    Text(
                      '오늘도 건강한 하루 보내세요',
                      style: TextStyle(
                          fontSize: 14, color: Colors.white.withOpacity(0.5)),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.055,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/Medi_Info');
                                  },
                                  child: Icon(Icons.medical_services_outlined),
                                  style: ElevatedButton.styleFrom(
                                      shape:
                                          CircleBorder(), // CircleBorder 클래스를 사용하여 버튼의 모양을 원형으로 변경
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      surfaceTintColor: Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              Text('MEDI.INFO',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.white))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.055,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/Directocr');
                                  },
                                  child: Icon(Icons.camera_alt_outlined),
                                  style: ElevatedButton.styleFrom(
                                      shape:
                                          CircleBorder(), // CircleBorder 클래스를 사용하여 버튼의 모양을 원형으로 변경
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      surfaceTintColor: Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              Text('MEDI.LENZ',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.white))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.055,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/Medi_Bot');
                                  },
                                  child:
                                      Icon(Icons.chat_bubble_outline_outlined),
                                  style: ElevatedButton.styleFrom(
                                      shape:
                                          CircleBorder(), // CircleBorder 클래스를 사용하여 버튼의 모양을 원형으로 변경
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      surfaceTintColor: Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              Text('MEDI.BOT',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.white))
                            ],
                          ),
                        ),
                        Expanded(
                          child: Column(
                            children: [
                              SizedBox(
                                height: screenHeight * 0.055,
                                child: ElevatedButton(
                                  onPressed: () {
                                    Navigator.pushNamed(context, '/Medi_Map');
                                  },
                                  child: Icon(Icons.location_on_outlined),
                                  style: ElevatedButton.styleFrom(
                                      shape:
                                          CircleBorder(), // CircleBorder 클래스를 사용하여 버튼의 모양을 원형으로 변경
                                      backgroundColor: Colors.transparent,
                                      shadowColor: Colors.transparent,
                                      surfaceTintColor: Colors.grey),
                                ),
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              Text('MEDI.MAP',
                                  style: TextStyle(
                                      fontSize: 11, color: Colors.white))
                            ],
                          ),
                        )
                      ],
                    )
                  ],
                ),
                decoration: BoxDecoration(
                    color: Color(0xff4f68ff),
                    borderRadius:
                        BorderRadius.only(topRight: Radius.circular(30))),
              ),
            ),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.only(bottomRight: Radius.circular(20))),
              height: screenHeight * 0.52,
              child: Container(
                width: screenWidth * 0.1,
                child: Column(
                  children: [
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                '약 검색하기',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )),
                              Icon(
                                Icons.keyboard_arrow_right_sharp,
                                color: Colors.black,
                              )
                            ],
                          )),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                '약 복용 시간 설정',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )),
                              Icon(
                                Icons.keyboard_arrow_right_sharp,
                                color: Colors.black,
                              )
                            ],
                          )),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                '지난 처방전 내역',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )),
                              Icon(
                                Icons.keyboard_arrow_right_sharp,
                                color: Colors.black,
                              )
                            ],
                          )),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                '즐겨찾기 약국 관리',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )),
                              Icon(
                                Icons.keyboard_arrow_right_sharp,
                                color: Colors.black,
                              )
                            ],
                          )),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black.withOpacity(0.3),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(3.0),
                      child: TextButton(
                          onPressed: () {},
                          child: Row(
                            children: [
                              Expanded(
                                  child: Text(
                                '약 종류 설정하기',
                                style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 12,
                                    fontWeight: FontWeight.bold),
                              )),
                              Icon(
                                Icons.keyboard_arrow_right_sharp,
                                color: Colors.black,
                              )
                            ],
                          )),
                    ),
                    Divider(
                      height: 1,
                      color: Colors.black.withOpacity(0.3),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}