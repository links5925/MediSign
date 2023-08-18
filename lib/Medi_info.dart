// ignore_for_file: sized_box_for_whitespace

import 'package:flutter/material.dart';
import 'package:flutter_medicine/Default_set/Default_AppBar.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

import 'Medicine_Detial.dart';

class Medi_info extends StatefulWidget {
  @override
  _Medi_infoState createState() => _Medi_infoState();
}

class _Medi_infoState extends State<Medi_info> {
  late List<Map<String, dynamic>> All_Medicine;
  bool fold_1 = false;
  bool fold_2 = true;
  bool fold_3 = true;
  late List<Widget> Output_Medi_List;
  late int id;
  late String? profile;
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
    id = user_info.getInt('id') ?? 0;
    profile = user_info.getString('profile');
  }

  Future<void> get_medicines() async {
    final response = await http.get(Uri.parse(
        'https://medisign-hackthon-95c791df694a.herokuapp.com/medicines/medicine_list'));
    if (response.statusCode == 200) {
      // API 응답을 JSON으로 변환하여 파싱
      List<Map<String, dynamic>> responseData = json.decode(response.body);
      setState(() {
        All_Medicine = responseData;
      });
    } else {
      throw Exception('Failed to load posts');
    }
  }

  void Medi_Set() async {
    String url =
        'https://medisign-hackthon-95c791df694a.herokuapp.com/users/User_list/$id';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      var user = jsonDecode(response.body);
      for (var prescription in (user["prescription"])) {
        prescriptions = jsonDecode(prescription.body); // 복용 횟수 얻음

        final medicine_list = prescriptions["medicine"]; // 복용 횟수 얻음
        final times = prescriptions["times"];
        for (var medicine in medicine_list) {
          for (var check_medicine in All_Medicine) {
            if (medicine == check_medicine["name"]) {
              Output_Medi_List.add(Make_medicine(check_medicine, times));
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
                    child: Image.network(
                      profile ?? 'https://picsum.photos/200/200',
                      height: 65,
                      width: 65,
                      fit: BoxFit.cover,
                    ),
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
    // MediaQuery를 사용하여 기기 정보 가져오기
    final mediaQuery = MediaQuery.of(context);
    // 기기의 너비와 높이 가져오기
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
                  Custom_Appbar(),
                  Container(
                    width: screenWidth,
                    height: fold_1 ? 0.13 : 0.4,
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
                                    ? Icon(Icons.keyboard_arrow_right_sharp)
                                    : Icon(Icons.keyboard_arrow_down_sharp),
                                Text('현재 복용 중')
                              ],
                            )),
                        Row(
                          children: Output_Medi_List,
                        )
                      ],
                    ),
                  ),
                  Container(
                    width: screenWidth,
                    height: fold_2 ? 50 : 350,
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
                                  ? Icon(Icons.keyboard_arrow_right_sharp)
                                  : Icon(Icons.keyboard_arrow_down_sharp),
                              Text('나의 조제 내역')
                            ],
                          ),
                        ),
                        Column(children: Prescription_List)
                      ],
                    ),
                  ),
                ]))));
  }
}

class Prescription_image extends StatefulWidget {
  const Prescription_image({super.key});

  @override
  State<Prescription_image> createState() => _Prescription_imageState();
}

class _Prescription_imageState extends State<Prescription_image> {
  String? hospital = '';
  String? url = '';
  String? date = '';

  @override
  void initState() {
    super.initState();
    _prescription_info();
  }

  Future<void> _prescription_info() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    url = user_info.getString('prescription_image');
    date = user_info.getString('prescription_date');
    hospital = user_info.getString('hospital');
  }

  @override
  Widget build(BuildContext context) {
    final mediaQuery = MediaQuery.of(context);
    final screenHeight = mediaQuery.size.height;
    final screenWidth = mediaQuery.size.width;

    return Scaffold(
      appBar: AppBar(),
      body: Container(
        color: Colors.white.withOpacity(0.9),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
        width: screenWidth * 0.9,
        child: Column(
          children: [
            Row(
              children: [
                Icon(Icons.arrow_right_sharp),
                Text(date ?? ''),
                Text(hospital ?? '')
              ],
            ),
            SizedBox(
              height: 15,
            ),
            ClipRRect(
              borderRadius: BorderRadius.all(Radius.circular(10)),
              child: Image.network(
                url ?? 'https://picsum.photos/200/200',
                width: screenWidth * 0.8,
                fit: BoxFit.cover,
              ),
            )
          ],
        ),
      ),
    );
  }
}
