// ignore_for_file: sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Information extends StatefulWidget {
  const Information({super.key});

  @override
  State<Information> createState() => _InformationState();
}

class _InformationState extends State<Information> {
  String? profile;
  String name = '';
  String gender = '';
  int height = 0;
  int weight = 0;
  String blood_type = '';
  List<Widget> disease_list = [];

  @override
  void initState() {
    super.initState();
    _loadUserinfo();
  }

  void _loadUserinfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    String? loadprofile = user_info.getString('profile');
    String loadname = user_info.getString('name') ?? '익명';
    String loadgender = user_info.getString('name') ?? '익명';
    String loadblood_type = user_info.getString('bloodType') ?? '익명';
    int loadheight = user_info.getInt('height') ?? 0;
    int loadweight = user_info.getInt('weight') ?? 0;
    var loaddisease = user_info.getStringList('disease') ?? [];
    for (var disease in loaddisease) {
      setState(() {
        disease_list.add(Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
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
      });
    }

    setState(() {
      profile = loadprofile;
      name = loadname;
      gender = loadgender;
      blood_type = loadblood_type;
      height = loadheight;
      weight = loadweight;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

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
            SizedBox(height: screenHeight * 0.05),
            Text(
              '내정보',
              style: TextStyle(color: Colors.white, fontSize: 18),
            ),
            SizedBox(height: screenHeight * 0.03),
            Container(
              decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.8),
                  borderRadius: BorderRadius.all(Radius.circular(15))),
              height: screenHeight * 0.8,
              width: screenWidth * 0.8,
              child: Column(
                children: [
                  SizedBox(
                      height: screenHeight * 0.7,
                      child: Column(children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 24, bottom: 10),
                          child: Image(
                              image: AssetImage('assets/image/graph 1.png')),
                        ),
                        Text(
                          name,
                          style: TextStyle(fontSize: 30, color: Colors.black),
                        ),
                        SizedBox(
                            width: screenWidth * 0.7,
                            child: Column(children: [
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Text(
                                      '성별',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                    Spacer(),
                                    Text(
                                      gender,
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.black,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Text('키', style: TextStyle(fontSize: 18)),
                                    Spacer(),
                                    Text(
                                      '$height' 'CM',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.black,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Text('몸무게', style: TextStyle(fontSize: 18)),
                                    Spacer(),
                                    Text(
                                      '$weight' 'KG',
                                      style: TextStyle(fontSize: 18),
                                    ),
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.black,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 4, bottom: 4),
                                child: Row(
                                  children: [
                                    Text('혈액형', style: TextStyle(fontSize: 18)),
                                    Spacer(),
                                    Text(
                                      '$blood_type' '형',
                                      style: TextStyle(fontSize: 18),
                                    )
                                  ],
                                ),
                              ),
                              Divider(
                                height: 1,
                                thickness: 1,
                                color: Colors.black,
                              ),
                              Padding(
                                  padding:
                                      const EdgeInsets.only(top: 4, bottom: 4),
                                  child: Row(children: [
                                    Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        children: [
                                          Text(
                                            '나의 지병 내역',
                                            style: TextStyle(fontSize: 18),
                                          ),
                                          Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            children: disease_list,
                                          )
                                        ])
                                  ]))
                            ]))
                      ])),
                  SizedBox(
                    width: screenWidth * 0.7,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.pushNamed(context, '/change_info');
                      },
                      child: Row(
                        children: [
                          Icon(
                            Icons.mode_edit_outlined,
                            color: Colors.black,
                            size: 18,
                          ),
                          Text(
                            '나의 정보 수정하기',
                            style: TextStyle(color: Colors.black, fontSize: 16),
                          ),
                        ],
                      ),
                      style: ButtonStyle(
                        elevation: MaterialStateProperty.all(1),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
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
          ],
        ),
      ),
    );
  }
}
