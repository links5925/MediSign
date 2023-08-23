// ignore_for_file: sort_child_properties_last

import 'package:shared_preferences/shared_preferences.dart';
import 'package:flutter/material.dart';
import 'Default_set/Default_AppBar.dart';
import 'Calendar.dart';
import 'Default_set/Default_BottomAppBar.dart';
import 'Default_set/Default_Drawer.dart';
import 'Medicine_Detail.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
    TextEditingController ctrl = TextEditingController();

  String name = '';
  String birthdate = '';
  String bloodType = '';
  var disease;
  String gender = '';
  int? height;
  int? weight;
  var year = DateTime.now().year;
  var month = DateTime.now().month;
  bool fold = true;
  List<Widget> disease_list = [];
  @override
  void initState() {
    super.initState();
    _loadUserInfo();
  }

  Future<void> _post_name(String name) async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setString('post_name', name);
  }

  Future<void> _loadUserInfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    String loadedName = user_info.getString('name') ?? '';
    String loadedBirthdate = user_info.getString('birthdate') ?? '';
    String loadedBloodType = user_info.getString('bloodType') ?? '';
    String loadgender = user_info.getString('gender') ?? '';
    int? loadheight = user_info.getInt('height');
    int? loadweight = user_info.getInt('weight');
    List<String> loaddisease = user_info.getStringList('disease') ?? [];
    setState(() {
      name = loadedName;
      birthdate = loadedBirthdate;
      bloodType = loadedBloodType;
      gender = loadgender;
      height = loadheight;
      weight = loadweight;
      setState(() {
        for (var disease in loaddisease) {
          disease_list.add(Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Icon(
                Icons.circle,
                color: Colors.black,
                size: 8,
              ),
              SizedBox(width: 5),
              Padding(
                padding: const EdgeInsets.only(top: 3),
                child: Text(
                  disease,
                  style: TextStyle(color: Colors.black, fontSize: 13),
                ),
              ),
            ],
          ));
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
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
                          child: TextField(controller: ctrl,
                            autofocus: false,
                            onSubmitted: (value) {
                              _post_name(ctrl.text);
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => Medicine_detail(),
                                  ));
                            },
                            decoration: InputDecoration(
                              contentPadding: EdgeInsets.symmetric(
                                  horizontal: 15, vertical: -7),
                              border: OutlineInputBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(30),
                                  ),
                                  borderSide: BorderSide(
                                      color: Color.fromRGBO(217, 217, 217, 1))),
                              filled: true,
                              fillColor: Color.fromRGBO(217, 217, 217, 1),
                              hintText: '궁금한 약에 대해서 검색해보세요:',
                              hintStyle: TextStyle(
                                fontSize: screenWidth * 0.033,
                                color: Colors.black,
                                fontWeight: FontWeight.w400,
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
                        height: screenHeight * 0.13,
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
                                    SizedBox(height: screenHeight * 0.01),
                                    Text(name,
                                        style: TextStyle(
                                            fontStyle: FontStyle.normal,
                                            fontWeight: FontWeight.w400,
                                            fontSize: screenWidth * 0.038)),
                                    Transform.translate(
                                      offset: Offset(
                                          0, 1), // 두 번째 텍스트의 y축 위치를 조절합니다.
                                      child: Text(
                                        '님',
                                        style: TextStyle(
                                            fontWeight: FontWeight.w400,
                                            fontSize: screenWidth * 0.03),
                                      ),
                                    )
                                  ],
                                ),
                                SizedBox(height: screenHeight * 0.01),
                                Text('오늘 약은 드셨나요??',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.03,
                                        fontWeight: FontWeight.w400)),
                                Text('언제나 화이팅!',
                                    style: TextStyle(
                                        fontSize: screenWidth * 0.03,
                                        fontWeight: FontWeight.w400)),
                                SizedBox(height: screenHeight * 0.01),
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
                                    SizedBox(
                                      width: screenWidth * 0.14,
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Container(
                      constraints:
                          BoxConstraints(minHeight: screenHeight * 0.1),
                      width: screenWidth * 0.9,
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(1),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(left: 10, top: 10),
                            child: Icon(Icons.medical_services_outlined),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(left: 5, top: 15),
                                child: Text(
                                  '나의 지병',
                                  style: TextStyle(
                                    fontWeight: FontWeight.w400,
                                    fontSize: screenWidth * 0.035,
                                  ),
                                ),
                              ),
                              fold
                                  ? Column()
                                  : Column(
                                      children: [
                                        SizedBox(height: 10),
                                        Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.start,
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: disease_list,
                                        ),
                                      ],
                                    ),
                              TextButton(
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
                                  child: fold
                                      ? Text('자세히 보기',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: screenWidth * 0.024,
                                              decoration:
                                                  TextDecoration.underline))
                                      : Text('자세히 보기 닫기',
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: screenWidth * 0.024,
                                              decoration:
                                                  TextDecoration.underline)))
                            ],
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.01),
                    Container(
                        height: screenHeight * 0.55,
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
                                  Icon(Icons.calendar_today_outlined,
                                      size: screenWidth * 0.1),
                                  SizedBox(width: screenWidth * 0.01),
                                  Text('메디캘린더',
                                      style: TextStyle(
                                          fontSize: screenWidth * 0.044)),
                                  SizedBox(width: screenWidth * 0.14),
                                  Container(
                                      width: screenWidth * 0.37,
                                      height: screenHeight * 0.03,
                                      child: ElevatedButton(
                                          onPressed: () {
                                            Navigator.pushNamed(context,
                                                '/Medi_Calendar_Medicine');
                                          },
                                          child: Row(children: [
                                            Transform.translate(
                                              offset: Offset(-5, 0),
                                              child: Icon(
                                                  Icons.mode_edit_outlined,
                                                  color: Colors.black,
                                                  size: 18),
                                            ),
                                            Text('복용 알림 설정하기',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12))
                                          ]),
                                          style: ButtonStyle(
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(30),
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      Color.fromRGBO(
                                                          217, 217, 217, 1)))))
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
