// ignore_for_file: sort_child_properties_last

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'Default_set/Default_AppBar.dart';
import 'Calendar.dart';
import 'Default_set/Default_BottomAppBar.dart';
import 'Default_set/Default_Drawer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String name = '';
  String birthdate = '';
  String bloodType = '';
  String disease = '';
  String gender = '';
  String height = '';
  String weight = '';
  var year = DateTime.now().year;
  var month = DateTime.now().month;
  bool fold = true;
  
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    String loadedName = user_info.getString('name') ?? '';
    String loadedBirthdate = user_info.getString('birthdate') ?? '';
    String loadedBloodType = user_info.getString('bloodType') ?? '';
    String loadedDisease = user_info.getString('disease') ?? '';
    String loadgender = user_info.getString('gender') ?? '';
    String loadheight = user_info.getString('height') ?? '';
    String loadweight = user_info.getString('weight') ?? '';
    setState(() {
      name = loadedName;
      birthdate = loadedBirthdate;
      bloodType = loadedBloodType;
      disease = loadedDisease;
      gender = loadgender;
      height = loadheight;
      weight = loadweight;
    });
  }

  @override
  Widget build(BuildContext context) {
    // MediaQuery를 사용하여 기기 정보 가져오기
    final mediaQuery = MediaQuery.of(context);

    // 기기의 너비와 높이 가져오기
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      drawer: Default_Drawer(),
      body: SingleChildScrollView(
        child: Container(
          constraints: BoxConstraints(
            minHeight: screenHeight,
          ),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Color(0xff627BFD), Color(0xffE3EBFF)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: Column(
            children: [
              Custom_Appbar(),
              Center(
                child: Column(
                  children: [
                    Transform.translate(
                      offset: Offset(0, -2),
                      child: Padding(
                        padding: EdgeInsets.only(
                            left: screenWidth * 0.05,
                            right: screenWidth * 0.05),
                        child: Container(
                          height: screenHeight * 0.038,
                          width: 0.9 * screenWidth,
                          child: TextField(
                            autofocus: false,
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: -7),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(217, 217, 217, 1))),
                              filled:
                                  true, // TextField 내부를 채우려면 이 값을 true로 설정하세요.
                              fillColor: Color.fromRGBO(217, 217, 217, 1),
                              hintText: '궁금한 약에 대해서 검색해보세요:',
                              hintStyle: TextStyle(
                                fontSize:
                                    screenWidth * 0.033, // 힌트 텍스트의 글꼴 크기 설정
                                color: Colors.black, // 힌트 텍스트의 색상 설정
                                fontWeight:
                                    FontWeight.w400, // 힌트 텍스트의 폰트 굵기 설정,
                              ),
                              suffixIcon: Transform.translate(
                                offset: Offset(0, -7),
                                child: IconButton(
                                  icon: Icon(Icons.search),
                                  iconSize: screenWidth * 0.06,
                                  onPressed: () {},
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.02,
                    ),
                    Container(
                      child: Container(
                        height:
                            fold ? screenHeight * 0.18 : screenHeight * 0.248,
                        alignment: Alignment.center,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(20))),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                  top: screenHeight * 0.012,
                                  left: screenWidth * 0.01),
                              child: Column(
                                children: [
                                  Icon(
                                    Icons.person,
                                    size: screenWidth * 0.07,
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              width: screenWidth * 0.01,
                            ),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: screenHeight * 0.01,
                                ),
                                Row(
                                  children: [
                                    Text('$name',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: screenWidth * 0.038)),
                                    Transform.translate(
                                      offset: Offset(
                                          0, 1), // 두 번째 텍스트의 y축 위치를 조절합니다.
                                      child: Text(
                                        '$name님',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: screenWidth * 0.03),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(
                                  height: screenHeight * 0.005,
                                ),
                                Text('오늘 약은 드셨나요??',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.03,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(
                                  height: screenHeight * 0.005,
                                ),
                                Text(
                                    '$gender / $height'
                                    'CM / $weight'
                                    'kg / $bloodType형',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.03)),
                                SizedBox(
                                  height: 5,
                                ),
                                Row(
                                  children: [
                                    Column(
                                      children: [
                                        Text(
                                          '나의 지병',
                                          style: TextStyle(
                                              fontWeight: FontWeight.w400,
                                              fontSize: screenWidth * 0.035),
                                        ),
                                        Transform.translate(
                                          offset: Offset(-screenWidth * 0.01,
                                              screenHeight * 0.005),
                                          child: TextButton(
                                              onPressed: () {
                                                if (fold == true) {
                                                  setState(() {
                                                    fold = false;
                                                  });
                                                } else {
                                                  setState(() {
                                                    fold = true;
                                                  });
                                                }
                                              },
                                              child: fold ? Text(
                                                '자세히 보기',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize:
                                                        screenWidth * 0.024,
                                                    decoration: TextDecoration
                                                        .underline),
                                              ):Text('자세히 보기 닫기',style: TextStyle(color: Colors.black,fontSize: screenWidth*0.024,decoration: TextDecoration.underline),)),
                                        )
                                      ],
                                    ),
                                    SizedBox(
                                      width: screenWidth * 0.14,
                                    ),
                                    Container(
                                      height: 0.036 * screenHeight,
                                      width: 0.42 * screenWidth,
                                      child: ElevatedButton(
                                        onPressed: () {},
                                        child: Transform.translate(
                                          offset: Offset(-7, 0),
                                          child: Row(
                                            children: [
                                              Icon(
                                                Icons.mode_edit_outlined,
                                                color: Colors.black,
                                                size: 18,
                                              ),
                                              Transform.translate(
                                                offset: Offset(6, 0),
                                                child: Text(
                                                  '복용 알림 설정하기',
                                                  style: TextStyle(
                                                      color: Colors.black,
                                                      fontSize: 9),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        style: ButtonStyle(
                                          shape: MaterialStateProperty.all<
                                              RoundedRectangleBorder>(
                                            RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      30), // 버튼 가장자리를 동그랗게 만듭니다.
                                            ),
                                          ),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Color.fromRGBO(
                                                      217, 217, 217, 1)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(
                      height: screenHeight * 0.01,
                    ),
                    Container(
                        width: screenWidth * 0.9,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius:
                                BorderRadius.all(Radius.circular(16))),
                        child: Column(
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(top: 8, left: 8),
                              child: Row(
                                children: [
                                  Icon(
                                    Icons.calendar_today_outlined,
                                    size: screenWidth * 0.1,
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.01,
                                  ),
                                  Text(
                                    '메디캘린더',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.044),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.025,
                                  ),
                                  Container(
                                    width: screenWidth * 0.49,
                                    height: screenHeight * 0.03,
                                    child: ElevatedButton(
                                      onPressed: () {}, // 갤러리에서 이미지 선택하는 함수 호출
                                      child: Transform.translate(
                                        offset: Offset(-7, 0),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.mode_edit_outlined,
                                              color: Colors.black,
                                              size: 18,
                                            ),
                                            Transform.translate(
                                              offset: Offset(6, 0),
                                              child: Text(
                                                '나의 메디캘린더 수정하기',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 9),
                                              ),
                                            ),
                                          ],
                                        ),
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
                                  )
                                ],
                              ),
                            ),
                            SizedBox(
                              height: screenHeight * 0.015,
                            ),
                            Row(
                              children: [
                                SizedBox(
                                  width: screenWidth * 0.05,
                                ),
                                Text(
                                  '$year년 $month월',
                                  style:
                                      TextStyle(fontSize: screenWidth * 0.05),
                                ),
                              ],
                            ),
                            Calendar(),
                          ],
                        )),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      bottomNavigationBar: Default_bottomAppBar(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/Directocr');
        },
        child: Icon(Icons.camera_alt_outlined,
            color: Colors.white, size: screenWidth * 0.12),
        backgroundColor: Color.fromRGBO(87, 132, 250, 1).withOpacity(0.75),
      ),
    );
  }
}