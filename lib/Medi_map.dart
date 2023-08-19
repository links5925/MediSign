import 'dart:convert';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'Default_set/Default_BottomAppBar.dart';
import 'Default_set/Default_Logo.dart';

class Medi_Map extends StatefulWidget {
  const Medi_Map({super.key});

  @override
  State<Medi_Map> createState() => _Medi_MapState();
}

class _Medi_MapState extends State<Medi_Map> {
  int? id;
  bool Fav = true;
  List<Widget> Fav_List = [];
  double screenWidth = 1;
  double screenHeight = 1;

  @override
  void initState() {
    super.initState();
    _loadUserinfo();
    Get_Reg_List();
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

  Future<void> Get_Reg_List() async {
    final response = await http.get(Uri.parse(
        'https://medisign-hackthon-95c791df694a.herokuapp.com/pharmacies/reg/1'));
    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      for (var pharmacy in responseData) {
        setState(() {
          Fav_List.add(Make_Pharmacy_List_View(pharmacy, true));
        });
      }
    } else {}
  }

  String limitString(
    String input,
  ) {
    if (input.length <= 20) {
      return input;
    } else {
      return input.substring(0, 20);
    }
  }

  Make_Pharmacy_List_View(var pharmacy, bool fav) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        width: screenWidth * 0.8,
        height: screenHeight * 0.1,
        decoration: BoxDecoration(
            color: Colors.transparent, borderRadius: BorderRadius.circular(15)),
        child: ElevatedButton(
          style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                ),
              ),
              elevation: MaterialStateProperty.all<double>(1),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 10,
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.keyboard_arrow_right_sharp,
                        color: Colors.black,
                        size: 22,
                      ),
                      Text(pharmacy["care_institution_name"],
                          style: TextStyle(
                              color: Colors.black,
                              fontSize: 17,
                              fontFamily: 'NotoSnasKR',
                              fontWeight: FontWeight.w700)),
                    ],
                  ),
                  Spacer(),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 10, left: 10),
                    child: Text(
                      limitString(pharmacy["address"]),
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 12,
                          fontFamily: 'NotoSnasKR',
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ],
              ),
              Spacer(),
              Column(
                children: [
                  Padding(
                    padding: EdgeInsets.only(top: screenHeight * 0.01),
                    child: Icon(
                      Icons.star,
                      color: fav ? Colors.blue[300] : Colors.grey,
                      size: screenHeight * 0.05,
                    ),
                  ),
                ],
              )
            ],
          ),
          onPressed: () {},
        ),
      ),
    );
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
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Transform.translate(
                offset: Offset(screenWidth * 0.2, 0),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Default_Logo(),
                ),
              ),
            ),
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                      child: Column(
                    children: [
                      Container(
                          height: min(screenHeight * 0.8, screenHeight * 10),
                          width: screenWidth * 0.88,
                          decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.85),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(15))),
                          child: Column(
                            children: [
                              Row(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: Container(
                                        width: screenWidth * 0.5,
                                        child: OutlinedButton(
                                            style: ButtonStyle(
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                              RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(30),
                                              ),
                                            )),
                                            onPressed: () {
                                              if (Fav == true) {
                                                setState(() {
                                                  Fav = false;
                                                });
                                              } else {
                                                setState(() {
                                                  Fav = true;
                                                });
                                              }
                                            },
                                            child: Fav
                                                ? Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(Icons
                                                          .not_listed_location_outlined),
                                                      Text(
                                                        '즐겨찾기 약국',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      )
                                                    ],
                                                  )
                                                : Row(
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .center,
                                                    children: [
                                                      Icon(
                                                        Icons.location_on_sharp,
                                                        color: Colors.black,
                                                      ),
                                                      Text(
                                                        '내 주변 약국',
                                                        style: TextStyle(
                                                            color:
                                                                Colors.black),
                                                      )
                                                    ],
                                                  )),
                                      ),
                                    ),
                                    Spacer(),
                                    Column(
                                      children: [
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(right: 20),
                                          child: Container(
                                            width: screenWidth * 0.12,
                                            height: screenHeight * 0.08,
                                            color: Colors.purple,
                                            child: Icon(Icons.star,
                                                size: 45,
                                                color: Fav
                                                    ? Colors.blue[300]
                                                    : Colors.grey),
                                          ),
                                        ),
                                      ],
                                    )
                                  ]),
                              Column(
                                  //children: Fav_List,
                                  ),
                              Padding(
                                padding: EdgeInsets.only(
                                    top: screenHeight * 0.01,
                                    bottom: screenHeight * 0.01),
                                child: Container(
                                  height: screenHeight * 0.07,
                                  width: screenWidth * 0.8,
                                  color: Color(0xff7885).withOpacity(0.7),
                                ),
                              )
                            ],
                          )),
                    ],
                  ))
                ],
              ),
            )
          ],
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
