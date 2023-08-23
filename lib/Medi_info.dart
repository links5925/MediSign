// ignore_for_file: sized_box_for_whitespace

import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_medicine/Default_set/Default_Logo.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'Default_set/Default_BottomAppBar.dart';
import 'Medicine_Detail.dart';

class Medi_info extends StatefulWidget {
  @override
  _Medi_infoState createState() => _Medi_infoState();
}

class _Medi_infoState extends State<Medi_info> {
  late List<dynamic> All_Medicine;
  bool fold_1 = false;
  bool fold_2 = false;
  List<Widget> Output_Medi_List = [];
  int? id;
  List<Widget> Prescription_List = [];
  late var prescriptions;
  @override
  void initState() {
    super.initState();
    _loadUserinfo();
    get_medicines();
    Medi_Set();
  }

  Future<void> _post_name(String name) async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setString('post_name', name);
  }

  Future<void> _Prescription_Image(
      String url, String date, String hospital) async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setString('prescription_image', url);
    user_info.setString('prescription_date', date);
    user_info.setString('hospital', hospital);
  }

  Future<void> _loadUserinfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    int? loadid = user_info.getInt('id');
    setState(() {
      id = loadid;
    });
  }

  Future<void> get_medicines() async {
    final response = await http.get(Uri.parse(
        'https://medisign-hackthon-95c791df694a.herokuapp.com/medicines/medicine_list'));
    if (response.statusCode == 200) {
      // API 응답을 JSON으로 변환하여 파싱
      List<dynamic> responseData = json.decode(response.body);
      setState(() {
        All_Medicine = responseData;
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  void Medi_Set() async {
    String url =
        'https://medisign-hackthon-95c791df694a.herokuapp.com/users/User_list/1';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var user = json.decode(utf8.decode(response.bodyBytes));
      for (var prescription in (user["prescriptions"])) {
        setState(() {
          prescriptions = jsonDecode(prescription.body);
        });
        final medicine_list = prescriptions["medicine"];
        final times = prescriptions["dosage_times"];
        for (var medicine in medicine_list) {
          for (var check_medicine in All_Medicine) {
            if (medicine == check_medicine["name"]) {
              setState(() {
                Output_Medi_List.add(Make_medicine(check_medicine, times));
              });
            }
          }
        }
      }
    }
  }

  void _prescription() {
    for (var prescription in prescriptions) {
      int year = prescription['prescription_date'].year;
      int month = prescription['prescription_date'].month;
      int day = prescription['prescription_date'].year.day;
      String hospital = prescription['hospital'];
      Prescription_List.add(ElevatedButton(
          onPressed: () {
            _Prescription_Image(
                prescription['image'], ('$year.$month.$day'), hospital);
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => Prescription_image(),
                ));
          },
          child: Row(
            children: [
              Icon(Icons.keyboard_arrow_right_sharp),
              Row(
                children: [Text('$year.$month.$day'), Text(hospital)],
              ),
            ],
          )));
    }
  }

  Make_medicine(Map<String, dynamic> medicine, List<String> times) {
    String time = '';
    for (String t in times) {
      time += t;
    }
    return Padding(
      padding: const EdgeInsets.only(left: 7, right: 7),
      child: SizedBox(
        height: 160,
        width: 120,
        child: ElevatedButton(
            onPressed: () {
              _post_name(medicine['name']);
              Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => Medicine_detail(),
                  ));
            },
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(12), // 버튼 가장자리를 동그랗게 만듭니다.
                  ),
                )),
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 16),
                  child: ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(10)),
                    child: medicine['image'] != null
                        ? Image.network(
                            medicine['image'],
                            height: 65,
                            width: 65,
                            fit: BoxFit.cover,
                          )
                        : Image(image: AssetImage('assets/image/graph 1.png')),
                  ),
                ),
                Text(
                  medicine['name'],
                  style: TextStyle(color: Colors.black, fontSize: 16),
                ),
                Text(
                  //medicine['efficacy'],
                  '설명-확인요망',
                  style: TextStyle(
                      color: Colors.grey.withOpacity(0.7), fontSize: 12),
                ),
                Text(
                  time,
                  style: TextStyle(color: Colors.black, fontSize: 12),
                )
              ],
            )),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
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
              child: Column(children: [
                Default_Logo(),
                SizedBox(
                  height: screenHeight * 0.02,
                ),
                SingleChildScrollView(
                    child: Column(children: [
                  Container(
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.9),
                        borderRadius: BorderRadius.circular(15)),
                    width: screenWidth * 0.8,
                    height: fold_1
                        ? screenHeight * 0.061
                        : min(screenHeight * 0.061, screenHeight * 0.1) +
                            screenHeight * 0.01,
                    child: Column(
                      children: [
                        TextButton(
                            onPressed: () {
                              if (fold_1 == true) {
                                setState(() {
                                  fold_1 = false;
                                });
                              } else {
                                setState(() {
                                  fold_1 = true;
                                });
                              }
                            },
                            child: Row(
                              children: [
                                fold_1
                                    ? Icon(
                                        Icons.keyboard_arrow_right_sharp,
                                        color: Colors.black,
                                      )
                                    : Icon(
                                        Icons.keyboard_arrow_down_sharp,
                                        color: Colors.black,
                                      ),
                                Text(
                                  '현재 복용 중',
                                  style: TextStyle(color: Colors.black),
                                )
                              ],
                            )),
                        Row(
                          children: Output_Medi_List,
                        )
                      ],
                    ),
                  ),
                ])),
                SizedBox(height: screenHeight * 0.015),
                Container(
                  margin: EdgeInsets.all(0),
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.9),
                      borderRadius: BorderRadius.circular(15)),
                  width: screenWidth * 0.8,
                  height: fold_2 ? screenHeight * 0.061 : min(100, 10000),
                  child: Column(
                    children: [
                      TextButton(
                        onPressed: () {
                          if (fold_2 == true) {
                            setState(() {
                              fold_2 = false;
                            });
                          } else {
                            setState(() {
                              fold_2 = true;
                            });
                          }
                        },
                        child: Row(
                          children: [
                            fold_1
                                ? Icon(
                                    Icons.keyboard_arrow_right_sharp,
                                    color: Colors.black,
                                  )
                                : Icon(
                                    Icons.keyboard_arrow_down_sharp,
                                    color: Colors.black,
                                  ),
                            Text(
                              '나의 조제 내역',
                              style: TextStyle(color: Colors.black),
                            )
                          ],
                        ),
                      ),
                      Column(children: Prescription_List)
                    ],
                  ),
                ),
              ]))),
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

class Prescription_image extends StatefulWidget {
  const Prescription_image({super.key});

  @override
  State<Prescription_image> createState() => _Prescription_imageState();
}

class _Prescription_imageState extends State<Prescription_image> {
  String hospital = '';
  String url = '';
  String date = '';
  @override
  void initState() {
    super.initState();
    _prescription_info();
  }

  Future<void> _prescription_info() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    String loadurl = user_info.getString('prescription_image') ?? '';
    String loaddate = user_info.getString('prescription_date') ?? '';
    String loadhospital = user_info.getString('hospital') ?? '';
    setState(() {
      url = loadurl;
      hospital = loadhospital;
      date = loaddate;
    });
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenWidth = mediaQuery.size.width;
    final screenHeight = mediaQuery.size.height;

    return Scaffold(
        body: Column(
      children: [
        Container(
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
              Default_Logo(),
              Container(
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.9),
                    borderRadius: BorderRadius.circular(10)),
                width: screenWidth * 0.9,
                child: Column(
                  children: [
                    Row(
                      children: [
                        Icon(Icons.arrow_right_sharp, size: 40),
                        Text(
                          '$date $hospital',
                          style: TextStyle(fontSize: 17),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    ClipRRect(
                      borderRadius: BorderRadius.all(Radius.circular(10)),
                      child: Image.network(
                        url,
                        width: screenWidth * 0.8,
                        fit: BoxFit.cover,
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    ));
  }
}
