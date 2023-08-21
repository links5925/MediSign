// ignore_for_file: sort_child_properties_last

import 'dart:convert';

import 'package:flutter_medicine/Default_set/Default_Logo.dart';
import 'package:http/http.dart' as http;
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Camera extends StatefulWidget {
  const Camera({Key? key}) : super(key: key);

  @override
  _CameraState createState() => _CameraState();
}

class _CameraState extends State<Camera> {
  final picker = ImagePicker();
  String? ocr_result;
  XFile? prescription_image;
  bool prescription_page = true;
  bool screen_1 = true;
  bool screen_2 = false;
  bool screen_3 = false;
  bool screen_4 = false;
  String? text;
  bool Fav = false;
  List<Widget> Reg_Pharmacy_List = [];
  List<Widget> Near_Pharmacy_List = [];
  int? id;
  double screenWidth = 0;
  double screenHeight = 0;
  double? lat;
  double? lon;
  List Reg_List = [];
  List<Widget> Fav_List = [];
  List<Widget> Near_List = [];
  Map<String, dynamic>? selected_pharmacy;
  TextEditingController pharmacy_name_controller = TextEditingController();
  @override
  void initState() {
    getImage();
    Get_Reg_List();
    Get_Near_List();
    super.initState();
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
      lat = loadlat?.toDouble();
      lon = loadlon?.toDouble();
    });
  }

  void Get_Reg_List() async {
    final response = await http.get(Uri.parse(
        'https://medisign-hackthon-95c791df694a.herokuapp.com/pharmacies/reg/$id'));
    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      for (var pharmacy in responseData) {
        setState(() {
          Reg_List.add(pharmacy);
          Fav_List.add(Make_Pharmacy_List_View(pharmacy, true));
        });
      }
    }
  }

  void Get_Near_List() async {
    final response = await http.get(Uri.parse(
        'https://medisign-hackthon-95c791df694a.herokuapp.com/pharmacies/nearby?lat=37.4495&lon=126.6536&distance_km=1'));

    if (response.statusCode == 200) {
      var responseData = json.decode(utf8.decode(response.bodyBytes));
      for (var pharmacy in responseData) {
        setState(() {
          Near_List.add(Make_Pharmacy_List_View(pharmacy, false));
        });
      }
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
              )),
              elevation: MaterialStateProperty.all<double>(1),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.white)),
          child: Row(
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
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
            ],
          ),
          onPressed: () {
            setState(() {
              selected_pharmacy = pharmacy;
              screen_4 = false;
            });
          },
        ),
      ),
    );
  }

  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage() async {
    final image = await picker.pickImage(source: ImageSource.camera);
    if (image == null) {
      Navigator.pop(context);
    } else {
      var bytes = File(image.path.toString()).readAsBytesSync();
      String img64 = base64Encode(bytes);

      // OCR API 호출을 위한 URL, 페이로드, 헤더 설정
      var url = 'https://api.ocr.space/parse/image';
      var payload = {
        "base64Image": "data:image/jpg;base64,${img64.toString()}",
        "language": "kor"
      };
      var header = {"apikey": "K84546995588957"};

      // OCR API 호출 및 응답 받아오기
      var post =
          await http.post(Uri.parse(url), body: payload, headers: header);
      var result = jsonDecode(post.body);
      var result1 = result['ParsedResults'];
      var result2 = result1 != null ? result1[0] : null;
      String? parsedtext = result2 != null ? result2['ParsedText'] : result2;
      List<String>? lines = parsedtext?.split('\n'); // 줄바꿈으로 문자열 나누기
      List<String>? parselist = lines?.map((input) {
        int firstClosingBracketIndex = input.indexOf(')');
        if (firstClosingBracketIndex != -1) {
          String substring = input.substring(firstClosingBracketIndex + 1);
          int firstOpeningBracketIndex = substring.indexOf('(');
          if (firstOpeningBracketIndex != -1) {
            substring = substring.substring(0, firstOpeningBracketIndex);
          }
          return substring;
        }
        return input;
      }).toList();
      setState(() {
        text = parsedtext;
        ocr_result = parselist?.join('\n');
        prescription_image = image;
      });
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
            )),
            child: prescription_page == true
                ? Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                        SingleChildScrollView(
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                              Container(
                                  height: screenHeight * 0.9,
                                  width: screenWidth * 0.9,
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.65),
                                      borderRadius: BorderRadius.circular(15)),
                                  child: SingleChildScrollView(
                                      child: Column(children: [
                                    Text(
                                        '${DateTime.now().year}.${DateTime.now().month}.${DateTime.now().day}'),
                                    Column(children: [
                                      prescription_image != null
                                          ? Container(
                                              width: screenWidth * 0.75,
                                              child: Image.file(File(
                                                  prescription_image!.path)))
                                          : Container(
                                              width: screenWidth * 0.75,
                                              height: screenHeight * 0.55,
                                              color: Colors.grey,
                                              child: Center(
                                                  child: Text('로딩중',
                                                      style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 60))))
                                    ]),
                                    SizedBox(height: screenHeight * 0.1),
                                    screen_1 == true
                                        ? Container(
                                            width: screenWidth * 0.75,
                                            height: screenHeight * 0.2,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.white.withOpacity(1),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Column(
                                              children: [
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.02),
                                                Text('촬영한 처방전 사진을 확인해주세요'),
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.02),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xff7885F8)
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  height: screenHeight * 0.05,
                                                  width: screenWidth * 0.46,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        shadowColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Colors
                                                                    .transparent),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Colors
                                                                    .transparent)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '다음',
                                                              style: TextStyle(
                                                                color: Colors
                                                                    .white,
                                                                fontSize: 18,
                                                              ),
                                                            ),
                                                            Container(
                                                                height: 20,
                                                                width: 20,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            90),
                                                                    color: Colors
                                                                        .white),
                                                                child: Icon(
                                                                  Icons
                                                                      .arrow_right,
                                                                  color: Color(
                                                                          0xff7885F8)
                                                                      .withOpacity(
                                                                          0.7),
                                                                  size: 20,
                                                                )),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      setState(() {
                                                        screen_1 = false;
                                                        screen_2 = true;
                                                      });
                                                    },
                                                  ),
                                                ),
                                                SizedBox(
                                                    height:
                                                        screenHeight * 0.02),
                                                Container(
                                                  decoration: BoxDecoration(
                                                      color: Color(0xff7885F8)
                                                          .withOpacity(0.7),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              15)),
                                                  height: screenHeight * 0.05,
                                                  width: screenWidth * 0.46,
                                                  child: ElevatedButton(
                                                    style: ButtonStyle(
                                                        shadowColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Colors
                                                                    .transparent),
                                                        backgroundColor:
                                                            MaterialStateProperty
                                                                .all<Color>(Colors
                                                                    .transparent)),
                                                    child: Row(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        Row(
                                                          children: [
                                                            Text(
                                                              '다시 촬영하기 ',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .white,
                                                                  fontSize: 18),
                                                            ),
                                                            Container(
                                                                height: 20,
                                                                width: 20,
                                                                decoration: BoxDecoration(
                                                                    borderRadius:
                                                                        BorderRadius.circular(
                                                                            90),
                                                                    color: Colors
                                                                        .white),
                                                                child: Icon(
                                                                    Icons
                                                                        .camera_alt_outlined,
                                                                    color: Color(
                                                                            0xff7885F8)
                                                                        .withOpacity(
                                                                            0.7),
                                                                    size: 16)),
                                                          ],
                                                        ),
                                                      ],
                                                    ),
                                                    onPressed: () {
                                                      screen_1 = false;
                                                      getImage();
                                                    },
                                                  ),
                                                )
                                              ],
                                            ),
                                          )
                                        : screen_2 == true
                                            ? Column(children: [
                                                Container(
                                                    padding: EdgeInsets.all(20),
                                                    width: screenWidth * 0.75,
                                                    height: screenHeight * 0.33,
                                                    decoration: BoxDecoration(
                                                        color: Colors.grey,
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(15)),
                                                    child: Column(children: [
                                                      Text('정보를 확인해주세요',
                                                          style: TextStyle(
                                                              fontSize: 20)),
                                                      Spacer(),
                                                      Center(
                                                          child: ocr_result !=
                                                                  null
                                                              ? Text(
                                                                  "정보가 없습니다",
                                                                  style: TextStyle(
                                                                      fontSize:
                                                                          30),
                                                                )
                                                              : Text(ocr_result ==
                                                                      null
                                                                  ? text == null
                                                                      ? "a"
                                                                      : "b"
                                                                  : 'c')),
                                                      Spacer(),
                                                      Row(children: [
                                                        Container(
                                                          height: screenHeight *
                                                              0.05,
                                                          width: screenWidth *
                                                              0.35,
                                                          decoration: BoxDecoration(
                                                              color: Color(
                                                                  0xff7885F8),
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          30)),
                                                          child: Stack(
                                                              alignment:
                                                                  Alignment
                                                                      .center,
                                                              children: [
                                                                Row(
                                                                  mainAxisAlignment:
                                                                      MainAxisAlignment
                                                                          .center,
                                                                  children: [
                                                                    Text(
                                                                        '정보 수정하기 ',
                                                                        style: TextStyle(
                                                                            color:
                                                                                Colors.white,
                                                                            fontSize: 16)),
                                                                    Container(
                                                                      decoration: BoxDecoration(
                                                                          color: Colors
                                                                              .white,
                                                                          borderRadius:
                                                                              BorderRadius.circular(90)),
                                                                      width: 20,
                                                                      height:
                                                                          20,
                                                                      child:
                                                                          Icon(
                                                                        Icons
                                                                            .camera_alt_rounded,
                                                                        size:
                                                                            17,
                                                                        color: Color(
                                                                            0xff7885F8),
                                                                      ),
                                                                    )
                                                                  ],
                                                                ),
                                                                ElevatedButton(
                                                                    style: ButtonStyle(
                                                                        backgroundColor:
                                                                            MaterialStateProperty.all(Colors
                                                                                .transparent),
                                                                        shadowColor:
                                                                            MaterialStateProperty.all(Colors
                                                                                .transparent)),
                                                                    onPressed:
                                                                        () {
                                                                      setState(
                                                                          () {
                                                                        screen_1 =
                                                                            true;
                                                                        screen_2 =
                                                                            false;
                                                                      });
                                                                      getImage();
                                                                    },
                                                                    child:
                                                                        Container())
                                                              ]),
                                                        ),
                                                        Spacer(),
                                                        Container(
                                                            height:
                                                                screenHeight *
                                                                    0.05,
                                                            width: screenWidth *
                                                                0.25,
                                                            decoration: BoxDecoration(
                                                                color: Color(
                                                                    0xff7885F8),
                                                                borderRadius:
                                                                    BorderRadius
                                                                        .circular(
                                                                            30)),
                                                            child: Stack(
                                                                alignment:
                                                                    Alignment
                                                                        .center,
                                                                children: [
                                                                  Row(
                                                                      mainAxisAlignment:
                                                                          MainAxisAlignment
                                                                              .center,
                                                                      children: [
                                                                        Text(
                                                                          '다음',
                                                                          style:
                                                                              TextStyle(color: Colors.white),
                                                                        ),
                                                                        SizedBox(
                                                                            width:
                                                                                5),
                                                                        Container(
                                                                            height:
                                                                                20,
                                                                            width:
                                                                                20,
                                                                            decoration:
                                                                                BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(90)),
                                                                            child: Transform.translate(offset: Offset(-5, -5), child: Icon(Icons.arrow_circle_right_outlined, color: Color(0xff7885F8), size: 30)))
                                                                      ]),
                                                                  ElevatedButton(
                                                                      onPressed:
                                                                          () {
                                                                        setState(
                                                                            () {
                                                                          screen_2 =
                                                                              false;
                                                                          screen_3 =
                                                                              true;
                                                                        });
                                                                      },
                                                                      style: ButtonStyle(
                                                                          backgroundColor: MaterialStateProperty.all(Colors
                                                                              .transparent),
                                                                          shadowColor: MaterialStateProperty.all(Colors
                                                                              .transparent)),
                                                                      child:
                                                                          Container(
                                                                        color: Colors
                                                                            .transparent,
                                                                      ))
                                                                ]))
                                                      ])
                                                    ]))
                                              ])
                                            : screen_3 == true
                                                ? Column(
                                                    children: [
                                                      SizedBox(
                                                          height: screenHeight *
                                                              0.15),
                                                      Container(
                                                        decoration: BoxDecoration(
                                                            color: Color(
                                                                    0xff7885F8)
                                                                .withOpacity(
                                                                    0.7),
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
                                                                        15)),
                                                        height:
                                                            screenHeight * 0.1,
                                                        width:
                                                            screenWidth * 0.75,
                                                        child: ElevatedButton(
                                                          style: ButtonStyle(
                                                              shadowColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      Colors
                                                                          .transparent),
                                                              backgroundColor:
                                                                  MaterialStateProperty.all<
                                                                          Color>(
                                                                      Colors
                                                                          .transparent)),
                                                          child: Row(
                                                              mainAxisAlignment:
                                                                  MainAxisAlignment
                                                                      .center,
                                                              children: [
                                                                Row(children: [
                                                                  Container(
                                                                      height:
                                                                          30,
                                                                      width: 30,
                                                                      decoration: BoxDecoration(
                                                                          borderRadius: BorderRadius.circular(
                                                                              90),
                                                                          color: Colors
                                                                              .white),
                                                                      child: Icon(
                                                                          Icons
                                                                              .add,
                                                                          color: Color(
                                                                              0xff7885F8),
                                                                          size:
                                                                              30)),
                                                                  Text(
                                                                      '  약 처방 받은 약국 연결하기',
                                                                      style:
                                                                          TextStyle(
                                                                        color: Colors
                                                                            .white,
                                                                        fontSize:
                                                                            18,
                                                                      ))
                                                                ])
                                                              ]),
                                                          onPressed: () {
                                                            setState(() {
                                                              screen_3 = false;
                                                              screen_4 = true;
                                                              prescription_page =
                                                                  false;
                                                            });
                                                          },
                                                        ),
                                                      ),
                                                    ],
                                                  )
                                                : Container(),
                                  ])))
                            ]))
                      ])
                : Column(
                    children: [
                      Default_Logo(),
                      Container(
                        height: screenHeight * 0.75,
                        width: screenWidth * 0.9,
                        decoration: BoxDecoration(
                            color: Colors.white.withOpacity(0.65),
                            borderRadius: BorderRadius.circular(15)),
                        child: Column(children: [
                          Container(
                            width: screenWidth * 0.5,
                            child: OutlinedButton(
                                style: ButtonStyle(
                                    shape: MaterialStateProperty.all<
                                        RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
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
                                            MainAxisAlignment.center,
                                        children: [
                                          Icon(Icons
                                              .not_listed_location_outlined),
                                          Text(
                                            '즐겨찾기 약국',
                                            style:
                                                TextStyle(color: Colors.black),
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
                                            style:
                                                TextStyle(color: Colors.black),
                                          )
                                        ],
                                      )),
                          ),
                          SingleChildScrollView(
                              child: Column(
                            children:
                                Fav ? Reg_Pharmacy_List : Near_Pharmacy_List,
                          )),
                        ]),
                      ),
                      SizedBox(height: screenHeight * 0.03),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(0xff7885F8).withOpacity(0.7),
                            borderRadius: BorderRadius.circular(15)),
                        height: screenHeight * 0.08,
                        width: screenWidth * 0.85,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Container(
                                  height: 30,
                                  width: 30,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(90),
                                      color: Colors.white),
                                  child: Icon(Icons.search,
                                      color: Color(0xff7885F8), size: 30)),
                              Container(
                                width: 100,
                                child: TextField(
                                  style: TextStyle(),
                                  controller: pharmacy_name_controller,
                                  decoration: InputDecoration(
                                      isDense: true,
                                      hintText: '약국 이름을 직접 검색하세요',
                                      hintStyle: TextStyle(color: Colors.white),
                                      border: InputBorder.none),
                                ),
                              ),
                              Text('  약국 이름을 검색해보세요',
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 18))
                            ]),
                      )
                    ],
                  )));
  }
}
