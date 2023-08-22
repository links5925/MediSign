// ignore_for_file: curly_braces_in_flow_control_structures

import 'dart:ui';
import 'package:geolocator/geolocator.dart';
import 'dart:convert';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'Default_set/Default_BottomAppBar.dart';
import 'Default_set/Default_Logo.dart';
import 'Medi_info.dart';

class Medi_Map extends StatefulWidget {
  const Medi_Map({super.key});

  @override
  State<Medi_Map> createState() => _Medi_MapState();
}

class _Medi_MapState extends State<Medi_Map> {
  late int pharmacy_id;
  int? id;
  bool Fav = true;
  late List Reg_List = [];
  List<Widget> Fav_List = [];
  List<Widget> Near_List = [];
  List<dynamic> B_Fav_List = [];
  List<dynamic> B_Near_List = [];
  double screenWidth = 1;
  double screenHeight = 1;
  int? lat;
  int? lon;
  WebViewController? _webViewController;
  int screen = 1;

  @override
  void initState() {
    super.initState();
    _loadUserinfo().then((value) {
      _webViewController = WebViewController()
        ..loadRequest(Uri.parse(id == null
            ? 'https://medisign-hackthon-95c791df694a.herokuapp.com/pharmacies/show_near/?user_id=$id&lat=37.4507&lon=126.6543'
            : 'https://medisign-hackthon-95c791df694a.herokuapp.com/pharmacies/show_near/?user_id=3&lat=37.4507&lon=126.6543'))
        ..setJavaScriptMode(JavaScriptMode.unrestricted);
      Get_Reg_List().then((value) {
        Get_Near_List();
      });
    });
  }

  Future<void> _loadUserinfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    int? loadid = user_info.getInt('id');
    int loadscreenWidth = user_info.getInt('Width') ?? 0;
    int loadscreenHeight = user_info.getInt('Height') ?? 0;
    int? loadlat = user_info.getInt('Lat');
    int? loadlon = user_info.getInt('Lon');

    setState(() {
      id = loadid;
      screenWidth = loadscreenWidth.toDouble();
      screenHeight = loadscreenHeight.toDouble();
      lat = loadlat;
      lon = loadlon;
    });
  }

  Future<void> _post_Medi_Map_Detail(bool fav, int pharmacy_id) async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setInt('Medi_Map_Pharmacy_id', pharmacy_id);
    user_info.setBool('Medi_Map_Fav', Fav);
    user_info.setBool('Medi_Map_Detail_Fav', fav);
  }

  Future<void> Get_Reg_List() async {
    final response = await http.get(Uri.parse(
        'https://medisign-hackthon-95c791df694a.herokuapp.com/pharmacies/reg/1'));
    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      for (var pharmacy in responseData) {
        setState(() {
          B_Fav_List.add(pharmacy);
          Fav_List.add(Make_Pharmacy_List_View(pharmacy));
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
        setState(() {
          B_Near_List.add(pharmacy);
          Near_List.add(Make_Pharmacy_List_View(pharmacy));
        });
      }
    }
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

  Make_Pharmacy_List_View(var pharmacy) {
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
                      borderRadius: BorderRadius.circular(20))),
              elevation: MaterialStateProperty.all<double>(1),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
          child: Row(
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(children: [
                    Icon(Icons.keyboard_arrow_right_sharp,
                        color: Colors.black, size: 22),
                    Text(pharmacy["care_institution_name"],
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 17,
                            fontFamily: 'NotoSnasKR',
                            fontWeight: FontWeight.w700)),
                  ]),
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
                    child: Stack(
                      alignment: Alignment.centerLeft,
                      children: [
                        Icon(
                          Icons.star,
                          color: B_Fav_List.contains(pharmacy)
                              ? Colors.blue[300]
                              : Colors.grey,
                          size: screenHeight * 0.05,
                        ),
                        TextButton(
                            onPressed: () {
                              int state = -1;
                              if (B_Fav_List.contains(pharmacy) == true) {
                                setState(() {
                                  Fav_List.remove(
                                      Make_Pharmacy_List_View(pharmacy));
                                  B_Fav_List.remove(pharmacy);
                                });
                              } else {
                                B_Fav_List.add(pharmacy);
                                Fav_List.add(Make_Pharmacy_List_View(pharmacy));
                              }
                              Fav_List;
                              Near_List;
                            },
                            style: ButtonStyle(
                                backgroundColor: MaterialStateProperty.all(
                                    Colors.transparent),
                                shadowColor: MaterialStateProperty.all(
                                    Colors.transparent)),
                            child: Container())
                      ],
                    ),
                  ),
                ],
              )
            ],
          ),
          onPressed: () {
            _post_Medi_Map_Detail(
                B_Fav_List.contains(pharmacy), pharmacy["id"]);
            Navigator.pushNamed(context, '/Medi_Map_Detail');
          },
        ),
      ),
    );
  }

  Future<void> _Prescription_Image(
      String url, String date, String hospital) async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    user_info.setString('prescription_image', url);
    user_info.setString('prescription_date', date);
    user_info.setString('hospital', hospital);
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
            Default_Logo(),
            Column(
              children: [
                Container(
                    height: screenHeight * 0.75,
                    width: screenWidth * 0.88,
                    decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.85),
                        borderRadius: BorderRadius.all(Radius.circular(15))),
                    child: Column(
                      children: [
                        screen == 1
                            ? Container(
                                height: screenHeight * 0.65,
                                child: SingleChildScrollView(
                                  child: Column(
                                    children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                              padding:
                                                  const EdgeInsets.all(15.0),
                                              child: Container(
                                                width: screenWidth * 0.5,
                                                child: OutlinedButton(
                                                    style: ButtonStyle(
                                                        shape: MaterialStateProperty
                                                            .all<
                                                                RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(30),
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
                                                                    color: Colors
                                                                        .black),
                                                              )
                                                            ],
                                                          )
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                              Icon(
                                                                Icons
                                                                    .location_on_sharp,
                                                                color: Colors
                                                                    .black,
                                                              ),
                                                              Text(
                                                                '내 주변 약국',
                                                                style: TextStyle(
                                                                    color: Colors
                                                                        .black),
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
                                                      const EdgeInsets.only(
                                                          right: 20),
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
                                        children: Fav ? Fav_List : Near_List,
                                      ),
                                    ],
                                  ),
                                ),
                              )
                            : Column(
                                children: [
                                  SizedBox(
                                    height: screenHeight * 0.1,
                                  ),
                                  webviewbuilder(),
                                  SizedBox(
                                    height: screenHeight * 0.15,
                                  )
                                ],
                              ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Container(
                            decoration: BoxDecoration(
                                color: Color(0xff7885F8).withOpacity(0.7),
                                borderRadius: BorderRadius.circular(15)),
                            height: screenHeight * 0.07,
                            width: screenWidth * 0.56,
                            child: ElevatedButton(
                              style: ButtonStyle(
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      Colors.transparent),
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent)),
                              child: screen == 1
                                  ? Text(
                                      'OPEN MAP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.07,
                                      ),
                                    )
                                  : Text(
                                      'CLOSE MAP',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: screenWidth * 0.07,
                                      ),
                                    ),
                              onPressed: () {
                                if (screen == 1) {
                                  setState(() {
                                    screen = 0;
                                  });
                                } else {
                                  setState(() {
                                    screen = 1;
                                  });
                                }
                              },
                            ),
                          ),
                        )
                      ],
                    ))
              ],
            ),
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

  Widget webviewbuilder() {
    return _webViewController != null
        ? Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.39,
            child: WebViewWidget(controller: _webViewController!),
          )
        : Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.39,
            color: Colors.grey,
          );
  }
}

class Medi_Map_Detail extends StatefulWidget {
  const Medi_Map_Detail({super.key});

  @override
  State<Medi_Map_Detail> createState() => Medi_Map_DetailState();
}

class Medi_Map_DetailState extends State<Medi_Map_Detail> {
  double screenWidth = 1;
  double screenHeight = 1;
  int? id;
  bool Fav = true;
  bool fav = true;
  int pharmacy_id = 0;
  WebViewController? _webViewController;
  String name = '';
  String phone_number = '';
  String address = '';
  bool loading = true;
  late Widget map;
  List<Widget> Prescription_List = [];
  int Screen = 1;

  @override
  void initState() {
    _loadUserinfo().then((value) {
      if (Fav == true) {
        Get_Reg_List();
      } else {
        Get_Near_List();
      }
      _webViewController = WebViewController()
        ..loadRequest(Uri.parse(
            'https://medisign-hackthon-95c791df694a.herokuapp.com/pharmacies/show_select/?pharmacy_id=$pharmacy_id'))
        ..setJavaScriptMode(JavaScriptMode.unrestricted);
    });
    _permission();
    super.initState();
  }

  Future<void> _permission() async {
    var requestStatus = await Permission.location.request();
    var status = await Permission.location.status;
    if (requestStatus.isGranted && status.isLimited) {
      print("isGranted");
      if (await Permission.locationWhenInUse.serviceStatus.isEnabled) {
        var position = await Geolocator.getCurrentPosition();
      }
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

  String limitString(
    String input,
  ) {
    if (input.length <= 16) {
      return input;
    } else {
      return input.substring(0, 16);
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
        'https://medisign-hackthon-95c791df694a.herokuapp.com/users/User_list/3'));
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
            constraints: BoxConstraints(minHeight: screenHeight),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff627BFD), Color(0xffE3EBFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Column(children: [
              Default_Logo(),
              pharmacy_id != 0
                  ? Screen == 1
                      ? Column(children: [
                          Container(
                              height: screenHeight * 0.75,
                              width: screenWidth * 0.88,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.85),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Column(children: [
                                Container(
                                    height: screenHeight * 0.65,
                                    child: Column(children: [
                                      Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: Container(
                                                    width: screenWidth * 0.5,
                                                    child: OutlinedButton(
                                                        style: ButtonStyle(
                                                            shape: MaterialStateProperty.all<
                                                                    RoundedRectangleBorder>(
                                                                RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(30),
                                                        ))),
                                                        onPressed: () {},
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
                                                                  ])
                                                            : Row(
                                                                mainAxisAlignment:
                                                                    MainAxisAlignment
                                                                        .center,
                                                                children: [
                                                                    Icon(
                                                                      Icons
                                                                          .location_on_sharp,
                                                                      color: Colors
                                                                          .black,
                                                                    ),
                                                                    Text(
                                                                      '내 주변 약국',
                                                                      style: TextStyle(
                                                                          color:
                                                                              Colors.black),
                                                                    )
                                                                  ])))),
                                            Spacer(),
                                            Column(children: [
                                              Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 20),
                                                  child: Container(
                                                    width: screenWidth * 0.12,
                                                    height: screenHeight * 0.08,
                                                    color: Colors.purple,
                                                    child: Icon(Icons.star,
                                                        size: 45,
                                                        color: Fav
                                                            ? Colors.blue[300]
                                                            : Colors.grey),
                                                  ))
                                            ])
                                          ]),
                                      Container(
                                          width: screenWidth * 0.7,
                                          height: screenHeight * 0.55,
                                          decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15),
                                          ),
                                          child: Column(children: [
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(children: [
                                                  Text(
                                                    '$name',
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  Icon(Icons.phone),
                                                  Spacer(),
                                                  Icon(
                                                    Icons.star,
                                                    color: fav
                                                        ? Colors.blue[300]
                                                        : Colors.grey,
                                                    size: screenHeight * 0.05,
                                                  )
                                                ])),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(children: [
                                                  Text(
                                                    '전화',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          screenWidth * 0.06),
                                                  Text('$phone_number',
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ))
                                                ])),
                                            Padding(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                child: Row(children: [
                                                  Text(
                                                    '주소',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 14),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          screenWidth * 0.06),
                                                  Text(setRange('$address', 16),
                                                      maxLines: 2,
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.w300,
                                                      ))
                                                ])),
                                            SingleChildScrollView(
                                              child: webviewbuilder(),
                                            )
                                          ]))
                                    ])),
                                Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xff7885F8)
                                                .withOpacity(0.7),
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        height: screenHeight * 0.07,
                                        width: screenWidth * 0.56,
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                shadowColor:
                                                    MaterialStateProperty.all<Color>(
                                                        Colors.transparent),
                                                backgroundColor:
                                                    MaterialStateProperty.all<
                                                            Color>(
                                                        Colors.transparent)),
                                            child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(90),
                                                        color: Colors.white),
                                                  ),
                                                  SizedBox(
                                                      width:
                                                          screenWidth * 0.01),
                                                  Text('지난 처방전 보기',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize:
                                                            screenWidth * 0.054,
                                                      ))
                                                ]),
                                            onPressed: () {
                                              _prescription();
                                              setState(() {
                                                Screen = 2;
                                              });
                                              // Navigator.pushNamed(context,
                                              //     '/Medi_Map_Prescription');
                                            })))
                              ]))
                        ])
                      : Column(children: [
                          Container(
                              height: screenHeight * 0.32,
                              width: screenWidth * 0.88,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(0.85),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: Column(children: [
                                Column(children: [
                                  Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
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
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              30),
                                                    ))),
                                                    onPressed: () {},
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
                                                                      color: Colors
                                                                          .black),
                                                                )
                                                              ])
                                                        : Row(
                                                            mainAxisAlignment:
                                                                MainAxisAlignment
                                                                    .center,
                                                            children: [
                                                                Icon(
                                                                  Icons
                                                                      .location_on_sharp,
                                                                  color: Colors
                                                                      .black,
                                                                ),
                                                                Text(
                                                                  '내 주변 약국',
                                                                  style: TextStyle(
                                                                      color: Colors
                                                                          .black),
                                                                )
                                                              ])))),
                                        Spacer(),
                                        Column(children: [
                                          Padding(
                                              padding: const EdgeInsets.only(
                                                  right: 20),
                                              child: Container(
                                                width: screenWidth * 0.12,
                                                height: screenHeight * 0.08,
                                                color: Colors.purple,
                                                child: Icon(Icons.star,
                                                    size: 45,
                                                    color: Fav
                                                        ? Colors.blue[300]
                                                        : Colors.grey),
                                              ))
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
                                              Text('$name',
                                                  style:
                                                      TextStyle(fontSize: 16)),
                                              Icon(Icons.phone),
                                              Spacer(),
                                              Container(
                                                child: Stack(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  children: [
                                                    Icon(
                                                      Icons.star,
                                                      color: fav
                                                          ? Colors.blue[300]
                                                          : Colors.grey,
                                                      size: screenHeight * 0.05,
                                                    ),
                                                    TextButton(
                                                        onPressed: () {
                                                          if (fav == true) {
                                                            setState(() {
                                                              fav = false;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              fav = true;
                                                            });
                                                          }
                                                        },
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .transparent),
                                                        ),
                                                        child: Container())
                                                  ],
                                                ),
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
                                              SizedBox(
                                                  width: screenWidth * 0.06),
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
                                                  width: screenWidth * 0.06),
                                              Text(setRange('$address', 16),
                                                  maxLines: 2,
                                                  style: TextStyle(
                                                    fontWeight: FontWeight.w300,
                                                  ))
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
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(15))),
                              child: SingleChildScrollView(
                                  child: Column(children: [
                                Row(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: Container(
                                              width: screenWidth * 0.5,
                                              child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    Icon(Icons
                                                        .not_listed_location_outlined),
                                                    Text(
                                                      '지난 처방전 보기',
                                                      style: TextStyle(
                                                          color: Colors.black),
                                                    )
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
                  : Container(),
            ])),
        bottomNavigationBar: Default_bottomAppBar(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, '/Directocr');
            },
            child: Icon(Icons.camera_alt_outlined,
                color: Colors.white, size: screenWidth * 0.12),
            backgroundColor:
                Color.fromRGBO(87, 132, 250, 1).withOpacity(0.75)));
  }

  Widget webviewbuilder() {
    return _webViewController != null
        ? Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.37,
            child: WebViewWidget(controller: _webViewController!),
          )
        : Container(
            width: screenWidth * 0.8,
            height: screenHeight * 0.39,
            color: Colors.grey,
          );
  }
}
