import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'Default_set/Default_BottomAppBar.dart';
import 'Default_set/Default_Logo.dart';
import 'Medi_info.dart';

class Medi_Map_Prescription extends StatefulWidget {
  const Medi_Map_Prescription({super.key});

  @override
  State<Medi_Map_Prescription> createState() => Medi_Map_PrescriptionState();
}

class Medi_Map_PrescriptionState extends State<Medi_Map_Prescription> {
  double screenWidth = 1;
  double screenHeight = 1;
  int? id;
  bool Fav = true;
  bool fav = true;
  late int pharmacy_id;
  String phone_number = '';
  String address = '';
  String name = '';
  List<Widget> Prescription_List = [];

  @override
  void initState() {
    super.initState();
    _loadUserinfo().then((value) {
      Get_Reg_List();
      Get_Near_List();
      _prescription();
    });
  }

  cutting(String address) {
    String input = address;
    int bracketIndex = input.indexOf('(');

    if (bracketIndex != -1) {
      String output = input.substring(0, bracketIndex);
      return output;
    } else {
      return input;
    }
  }

  Future<void> _loadUserinfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    int? loadid = user_info.getInt('id');
    int loadscreenWidth = user_info.getInt('Width') ?? 0;
    int loadscreenHeight = user_info.getInt('Height') ?? 0;
    int load_Pharmacy_id = user_info.getInt('Medi_Map_Pharmacy_id') ?? 0;
    bool load_Fav = user_info.getBool('Medi_Map_Fav') ?? true;
    bool load_fav = user_info.getBool('Medi_Map_Detail_Fav') ?? true;

    setState(() {
      id = loadid;
      screenWidth = loadscreenWidth.toDouble();
      screenHeight = loadscreenHeight.toDouble();
      Fav = load_Fav;
      fav = load_fav;
      pharmacy_id = load_Pharmacy_id;
    });
  }

  Future<void> Get_Reg_List() async {
    final response = await http.get(Uri.parse(
        'https://medisign-hackthon-95c791df694a.herokuapp.com/pharmacies/reg/$id'));
    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      for (var pharmacy in responseData) {
        if (pharmacy["id"] == pharmacy_id)
          setState(() {
            name = pharmacy["care_institution_name"];
            phone_number = pharmacy["phone_number"];
            address = pharmacy["address"];
          });
      }
    } else {}
  }

  Future<void> Get_Near_List() async {
    final response = await http.get(Uri.parse(
        'https://medisign-hackthon-95c791df694a.herokuapp.com/pharmacies/nearby?lat=37.4495&lon=126.6536&distance_km=1'));

    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      for (var pharmacy in responseData) {
        if (pharmacy["id"] == pharmacy_id)
          setState(() {
            name = pharmacy["care_institution_name"];
            phone_number = pharmacy["phone_number"];
            address = pharmacy["address"];
          });
      }
    }
  }

  Future<void> _Prescription_Image(
      String url, String date, String hospital) async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setString('prescription_image', url);
    user_info.setString('prescription_date', date);
    user_info.setString('hospital', hospital);
  }

  Future<void> _prescription() async {
    var response = await http.get(Uri.parse(
        'https://medisign-hackthon-95c791df694a.herokuapp.com/users/User_list/$id'));
    if (response.statusCode == 200) {
      var user = json.decode(utf8.decode(response.bodyBytes));
      List<dynamic> prescriptions = user["prescriptions"];

      for (var prescription in prescriptions) {
        if (prescription["hospital"] == pharmacy_id) {
          String hospital = prescription['hospital'];
          String date = prescription['prescription_date'] ?? 'date';
          setState(() {
            Prescription_List.add(ElevatedButton(
                style: ButtonStyle(
                  elevation: MaterialStateProperty.all<double>(1),
                  backgroundColor: MaterialStateProperty.all(Colors.white),
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                onPressed: () {
                  _Prescription_Image(prescription['image'], date, hospital);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => Prescription_image(),
                      ));
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.keyboard_arrow_right_sharp,
                      color: Colors.black,
                    ),
                    Row(
                      children: [
                        Text(
                          '$date',
                          style: TextStyle(color: Colors.black),
                        ),
                      ],
                    ),
                  ],
                )));
          });
          ;
        }
      }
    }
  }

  String setRange(String inputText, int maxLength) {
    final stringBuffer = StringBuffer();
    for (int i = 0; i < inputText.length; i += maxLength) {
      final endIndex = (i + maxLength) > inputText.length
          ? inputText.length
          : (i + maxLength);
      stringBuffer.write(inputText.substring(i, endIndex));
      if (endIndex != inputText.length) stringBuffer.write("\n");
    }
    return stringBuffer.toString();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
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
            Column(children: [
              Container(
                  height: screenHeight * 0.32,
                  width: screenWidth * 0.88,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(children: [
                    Column(children: [
                      Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                width: screenWidth * 0.5,
                                child: OutlinedButton(
                                    style: ButtonStyle(
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(30),
                                      ),
                                    )),
                                    onPressed: () {},
                                    child: Fav
                                        ? Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(Icons
                                                  .not_listed_location_outlined),
                                              Text(
                                                '즐겨찾기 약국',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            ],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: [
                                              Icon(
                                                Icons.location_on_sharp,
                                                color: Colors.black,
                                              ),
                                              Text(
                                                '내 주변 약국',
                                                style: TextStyle(
                                                    color: Colors.black),
                                              )
                                            ],
                                          )),
                              ),
                            ),
                            Spacer(),
                            Column(children: [
                              Padding(
                                  padding: const EdgeInsets.only(right: 20),
                                  child: Container(
                                      width: screenWidth * 0.12,
                                      height: screenHeight * 0.08,
                                      color: Colors.purple,
                                      child: Icon(Icons.star,
                                          size: 45,
                                          color: Fav
                                              ? Colors.blue[300]
                                              : Colors.grey)))
                            ])
                          ]),
                      Container(
                          width: screenWidth * 0.7,
                          height: screenHeight * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Column(children: [
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Text('$name', style: TextStyle(fontSize: 25)),
                                  Icon(Icons.phone),
                                  Spacer(),
                                  Icon(
                                    Icons.star,
                                    color: fav ? Colors.blue[300] : Colors.grey,
                                    size: screenHeight * 0.05,
                                  )
                                ])),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Text(
                                    '전화',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  SizedBox(width: screenWidth * 0.06),
                                  Text('$phone_number',
                                      style: TextStyle(
                                        fontWeight: FontWeight.w300,
                                      ))
                                ])),
                            Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Row(children: [
                                  Text(
                                    '주소',
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 14),
                                  ),
                                  SizedBox(
                                    width: screenWidth * 0.06,
                                  ),
                                  Container(
                                      child: Text(cutting('$address'),
                                          maxLines: 3,
                                          style: TextStyle(
                                            fontWeight: FontWeight.w300,
                                          )))
                                ]))
                          ]))
                    ])
                  ])),
              SizedBox(height: screenHeight * 0.01),
              Container(
                  height: screenHeight * 0.45,
                  width: screenWidth * 0.88,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.85),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: SingleChildScrollView(
                      child: Column(children: [
                    Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                              padding: const EdgeInsets.all(15.0),
                              child: Container(
                                  width: screenWidth * 0.5,
                                  child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Icon(
                                            Icons.not_listed_location_outlined),
                                        Text('지난 처방전 보기',
                                            style:
                                                TextStyle(color: Colors.black))
                                      ])))
                        ]),
                    Container(
                        width: screenWidth * 0.7,
                        height: screenHeight * 10,
                        child: SingleChildScrollView(
                            child: Column(children: [
                          Column(
                            children: Prescription_List,
                          )
                        ])))
                  ])))
            ])
          ])),
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