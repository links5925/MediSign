// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, file_names, library_private_types_in_public_api, camel_case_types, unused_element, unrelated_type_equality_checks, prefer_interpolation_to_compose_strings, sort_child_properties_last
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Medi_Set extends StatefulWidget {
  const Medi_Set({super.key});
  @override
  _Medi_SetState createState() => _Medi_SetState();
}

class _Medi_SetState extends State<Medi_Set> {
  TextEditingController _EmailController = TextEditingController();
  TextEditingController DurationController = TextEditingController();
  TextEditingController Medi_name_cntroller = TextEditingController();
  TextEditingController sep_controller1 = TextEditingController();
  TextEditingController sep_controller2 = TextEditingController();
  TextEditingController sep_controller3 = TextEditingController();
  int id = 0;
  int more = 0;
  int state = 1;
  int sub_screen = 0;

  CalendarFormat _calendarFormat = CalendarFormat.week;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  DateTime _selectedTime1 = DateTime.now();
  DateTime _selectedTime2 = DateTime.now();
  DateTime _selectedTime3 = DateTime.now();
  DateTime startday = DateTime.now();
  late DateTime day;

  late ValueNotifier<List<Medicine>> _selectedMedicines;

  bool Is_ALARM = false;
  Color selectedcolor = Colors.yellow;
  bool _IS_ALWAYS = false;
  List<String> Time_Seperate = <String>['기상', '아침', '점심', '저녁', '취침'];
  List<String> Regular_Day_List = [];
  List<Color> Color_List = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.brown
  ];
  Map<DateTime, List<Medicine>> Day_Medicine = {
    DateTime.utc(2023, 8, 22): [
      Medicine(
          '2',
          DateTime.utc(2023, 8, 22),
          Colors.blue,
          true,
          1,
          true,
          {'점심': '9:00'},
          {
            DateTime.utc(2023, 8, 13): false,
          },
          '테마'),
      Medicine('3', DateTime.utc(2023, 8, 22), Colors.red, true, 1, false,
          {'점심': '8:00'}, {DateTime.utc(2023, 8, 13): false}, '테마')
    ],
    DateTime.utc(2023, 8, 23): [
      Medicine('4', DateTime.utc(2023, 8, 23), Colors.red, true, 2, false,
          {'점심': "7:00"}, {DateTime.utc(2023, 8, 24): false}, '테마')
    ],
    DateTime.utc(2023, 8, 24): [
      Medicine('4', DateTime.utc(2023, 8, 23), Colors.red, true, 2, false,
          {'점심': "7:00"}, {DateTime.utc(2023, 8, 24): false}, '테마')
    ],
  };
  late Medicine New_Medicine;
  List<Medicine> User_medicine = [];
  List<Widget> Day_Medicine_Widget = [];
  @override
  void initState() {
    super.initState();

    loaduserinfo().then((value) {
      Load_Data();
    });
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedMedicines =
        ValueNotifier<List<Medicine>>(_getMedicinesForDay(_selectedDay));
  }

  Future<void> loaduserinfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    int loadid = user_info.getInt('id') ?? 0;
    setState(() {
      id = loadid;
    });
  }

  void changemedicine(Map<DateTime, List<Medicine>> Day_Medicine, DateTime day,
      Medicine medicine) {
    setState(() {
      int? index = Day_Medicine[day]?.indexOf(medicine) ?? -1;
      if (index != -1) {
        Day_Medicine[day]![index] = medicine;
      }
    });
  }

  List<Medicine> _getMedicinesForDay(DateTime day) {
    return Day_Medicine[day] ?? [];
  }

  re_weekday(Set<int> weekday) {
    if (weekday == 1) {
      return '월';
    } else if (weekday == 2) {
      return '화';
    } else if (weekday == 3) {
      return '수';
    } else if (weekday == 4) {
      return '목';
    } else if (weekday == 5) {
      return '금';
    } else if (weekday == 6) {
      return '토';
    } else {
      return '일';
    }
  }

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
        context: context,
        builder: (BuildContext context) => Container(
              height: 116,
              padding: const EdgeInsets.only(top: 6.0),
              margin: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              color: CupertinoColors.systemBackground.resolveFrom(context),
              child: SafeArea(
                top: false,
                child: child,
              ),
            ));
  }

// 약을 넣으면 위젯 만들어주기
  void _add_medicine_List(Medicine medicine) {
    DateTime endday = startday.add(Duration(days: medicine.duration));
    Day_Medicine_Widget.add(Row(children: [
      Icon(Icons.circle, size: 14, color: medicine.color),
      Column(
        children: [
          Text(medicine.name),
          Text(
              '${medicine.startday.year}-${medicine.startday.month}-${medicine.startday.day} ~ ${endday.year}-${endday.month}-${endday.day}')
        ],
      ),
      Spacer(),
      ElevatedButton(
          onPressed: () {
            if (Day_Medicine.containsKey(medicine.startday)) {
              setState() {
                state = 2;
                day = _selectedDay;
              }
            }
          },
          child: Text('수정')),
    ]));
  }

// 일에 맞게 약 집어넣기
  void Medi_Buileder(Medicine medicine) {
    for (int i = 0; i < medicine.duration; i++) {
      if (Day_Medicine.containsKey(medicine.startday.add(Duration(days: i)))) {
        setState(() {
          Day_Medicine[medicine.startday.add(Duration(days: i))]?.add(medicine);
        });
      } else {
        setState(() {
          Day_Medicine[medicine.startday.add(Duration(days: i))] = [medicine];
        });
      }
    }
  }

// Json Get
  void Load_Data() async {
    String url =
        'https://medisign-hackthon-95c791df694a.herokuapp.com/users/User_list$id';
    var response = await http.get(Uri.parse(url));
    if (response.statusCode == 201 || response.statusCode == 200) {
      final data = json.decode(utf8.decode(response.bodyBytes));
      for (final be_medicine in data["medicine"]) {
        var medicine = json.decode(utf8.decode(be_medicine.bodyBytes));
        var T = medicine["startday"].split('.');
        User_medicine.add(Medicine(
            medicine["name"],
            DateTime.utc(int.parse(T[0]), int.parse(T[1]), int.parse(T[2])),
            Color_List[medicine["color"]],
            medicine["alarm"],
            medicine["duration"],
            medicine["repeat"],
            json.decode(utf8.decode(medicine["time"])),
            medicine["check"],
            '테마'));
      }
    }
  }

// JSON POST
  void Post_data() async {
    String url =
        'https://medisign-hackthon-95c791df694a.herokuapp.com/users/User_list/3';
    List<dynamic> Will_Post_List = [];
    for (var prepared_data in User_medicine) {
      var pd = await BE_postData(prepared_data);
      var d = await jsonEncode(pd);
      Will_Post_List.add(d);
    }
    // Map<String, dynamic> data = {"medicine": Will_Post_List};
    Map<String, dynamic> data = {
      "name": "name",
      "password": "password",
    };
    var body = jsonEncode(data);
    var response = await http.patch(Uri.parse(url), body: body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      print('asdas ');
    } else {
      print(response.statusCode);
    }
  }

  Future<Map<String, dynamic>> BE_postData(Medicine medicine) async {
    var time = await medicine.Time;
    Map<String, dynamic> data = {
      "name": medicine.name,
      "color": Color_List.indexOf(medicine.color),
      "alarm": medicine.alarm,
      "startday":
          "${medicine.startday.year}.${medicine.startday.month}.${medicine.startday.day}",
      "duration": medicine.duration,
      "repeat": medicine.repeat,
      "time": time
    };
    return data;
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        body: Container(
            height: screenHeight,
            width: screenWidth,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Color(0xff627BFD), Color(0xffE3EBFF)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: SingleChildScrollView(
                child: Column(children: [
              Container(
                  height: screenHeight * 0.1,
                  child: Row(children: [
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(
                          Icons.keyboard_arrow_left_outlined,
                          color: Colors.white,
                          size: 40,
                        )),
                    SizedBox(width: screenWidth * 0.16),
                    Text(
                      '복용 알림 추가',
                      style: TextStyle(color: Colors.white, fontSize: 22),
                    )
                  ])),
              state == 1
                  ? Column(
                      children: [
                        Container(
                            height: screenHeight * 0.12,
                            width: screenWidth * 0.88,
                            decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.7),
                                borderRadius:
                                    BorderRadius.all(Radius.circular(15))),
                            child: Column(children: [
                              SizedBox(height: screenHeight * 0.02),
                              TableCalendar(
                                calendarFormat: _calendarFormat,
                                calendarStyle: CalendarStyle(
                                    cellMargin: EdgeInsets.all(6),
                                    cellPadding: EdgeInsets.all(0),
                                    isTodayHighlighted: true,
                                    markerDecoration: BoxDecoration(
                                        color: Colors.transparent)),
                                locale: 'ko_KR',
                                firstDay: DateTime.utc(2023, 1, 1),
                                lastDay: DateTime.utc(2024, 12, 31),
                                focusedDay: _focusedDay,
                                eventLoader: _getMedicinesForDay,
                                headerVisible: false,
                                headerStyle: HeaderStyle(
                                  leftChevronVisible: false,
                                  rightChevronVisible: false,
                                  titleTextStyle: TextStyle(fontSize: 0),
                                  headerPadding:
                                      EdgeInsets.only(left: 100, right: 100),
                                  formatButtonVisible: true,
                                ),
                                availableGestures:
                                    AvailableGestures.horizontalSwipe,
                                selectedDayPredicate: (day) {
                                  return isSameDay(_selectedDay, day);
                                },
                                onDaySelected: (selectedDay, focusedDay) {
                                  setState(() {
                                    _selectedDay = selectedDay;
                                    _focusedDay = focusedDay;
                                    _selectedMedicines.value =
                                        _getMedicinesForDay(selectedDay);
                                  });
                                },
                                onFormatChanged: (format) {
                                  setState(() {
                                    _calendarFormat = format;
                                  });
                                },
                                onPageChanged: (focusedDay) {
                                  _focusedDay = focusedDay;
                                },
                              )
                            ])),
                        SizedBox(height: screenHeight * 0.03),
                        SingleChildScrollView(
                          child: state == 1
                              ? Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.75),
                                      borderRadius: BorderRadius.circular(15)),
                                  width: screenWidth * 0.85,
                                  height: screenHeight * 0.6,
                                  child: medicine_list(),
                                )
                              : Container(),
                        ),
                        SizedBox(height: 30),
                        Container(
                            alignment: Alignment.center,
                            height: screenHeight * 0.06,
                            child: TextButton(
                              child: Text(
                                '복용 알림 추가',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () {
                                setState(() {
                                  state = 2;
                                  day = _selectedDay;
                                });
                              },
                            ),
                            color: Color(0xff7885F8))
                      ],
                    )
                  : state == 2
                      ? Stack(
                          alignment: Alignment.topCenter,
                          children: [
                            Column(children: [
                              Container(
                                padding: EdgeInsets.all(20),
                                width: screenWidth * 0.88,
                                decoration: BoxDecoration(
                                    color: Colors.white.withOpacity(0.7),
                                    borderRadius:
                                        BorderRadius.all(Radius.circular(15))),
                                child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text('복용약명'),
                                      SizedBox(height: 10),
                                      Row(children: [
                                        Container(
                                          padding: EdgeInsets.only(left: 10),
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(30)),
                                          width: 240,
                                          height: 40,
                                          child: TextField(
                                            controller: Medi_name_cntroller,
                                            onTap: () {
                                              setState(() {
                                                sub_screen = 0;
                                              });
                                            },
                                            decoration: InputDecoration(
                                                hintText: '예) 두통약',
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        Spacer(),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        selectedcolor),
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (sub_screen == 1) {
                                                  setState(() {
                                                    sub_screen = 0;
                                                  });
                                                } else {
                                                  setState(() {
                                                    sub_screen = 1;
                                                  });
                                                }
                                              },
                                              child: Container()),
                                        ),
                                      ]),
                                      SizedBox(height: 10),
                                      Text('복용기간'),
                                      SizedBox(height: 10),
                                      Row(children: [
                                        Container(
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          alignment: Alignment.center,
                                          width: 140,
                                          height: 40,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.end,
                                            children: [
                                              Text(
                                                  '${startday.year}-${startday.month}-${startday.day}'),
                                              IconButton(
                                                  onPressed: () {
                                                    setState(() {
                                                      sub_screen = 2;
                                                    });
                                                  },
                                                  icon: Icon(Icons
                                                      .calendar_today_outlined))
                                            ],
                                          ),
                                        ),
                                        Spacer(),
                                        Text('~'),
                                        Spacer(),
                                        Container(
                                          padding: EdgeInsets.only(left: 15),
                                          alignment: Alignment.centerRight,
                                          width: 70,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: TextField(
                                            controller: DurationController,
                                            decoration: InputDecoration(
                                                hintText: '숫자',
                                                border: InputBorder.none),
                                          ),
                                        ),
                                        SizedBox(width: 30),
                                        Text('일간')
                                      ]),
                                      SizedBox(height: 10),
                                      Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Container(
                                              width: 30,
                                              height: 30,
                                              child: ElevatedButton(
                                                  style: ButtonStyle(
                                                    backgroundColor: _IS_ALWAYS
                                                        ? MaterialStateProperty
                                                            .all(Colors
                                                                .blue[800])
                                                        : MaterialStateProperty
                                                            .all(Colors.grey),
                                                    shadowColor:
                                                        MaterialStateProperty
                                                            .all(Colors
                                                                .transparent),
                                                    shape: MaterialStateProperty
                                                        .all<
                                                            RoundedRectangleBorder>(
                                                      RoundedRectangleBorder(
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(90),
                                                          side: BorderSide(
                                                              color: Colors
                                                                  .black)),
                                                    ),
                                                  ),
                                                  onPressed: () {
                                                    if (_IS_ALWAYS == false) {
                                                      setState(() {
                                                        _IS_ALWAYS = true;
                                                      });
                                                    } else {
                                                      setState(() {
                                                        _IS_ALWAYS = false;
                                                      });
                                                    }
                                                  },
                                                  child: Transform.translate(
                                                    offset: Offset(-13, 0),
                                                    child: Icon(
                                                      Icons.check,
                                                    ),
                                                  )),
                                            ),
                                            Text('   상시복용')
                                          ]),
                                      Text('1회 복용량'),
                                      SizedBox(height: 10),
                                      Container(
                                          padding: EdgeInsets.only(left: 10),
                                          width: 300,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: TextField(
                                              controller: _EmailController,
                                              showCursor: false,
                                              decoration: InputDecoration(
                                                  hintText: '예) 1정 또는 1포',
                                                  border: InputBorder.none))),
                                      SizedBox(height: 10),
                                      Text('복용 주기'),
                                      SizedBox(height: 10),
                                      Row(children: [
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Regular_Day_List
                                                                .contains('월')
                                                            ? Colors.blue
                                                            : Colors.white),
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (Regular_Day_List.contains(
                                                    '월')) {
                                                  setState(() {
                                                    Regular_Day_List.remove(
                                                        '월');
                                                  });
                                                } else {
                                                  setState(() {
                                                    Regular_Day_List.add('월');
                                                  });
                                                }
                                              },
                                              child: Transform.translate(
                                                offset: Offset(-7, 0),
                                                child: Text(
                                                  '월',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Regular_Day_List
                                                                .contains('화')
                                                            ? Colors.blue
                                                            : Colors.white),
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (Regular_Day_List.contains(
                                                    '화')) {
                                                  setState(() {
                                                    Regular_Day_List.remove(
                                                        '화');
                                                  });
                                                } else {
                                                  setState(() {
                                                    Regular_Day_List.add('화');
                                                  });
                                                }
                                              },
                                              child: Transform.translate(
                                                offset: Offset(-7, 0),
                                                child: Text(
                                                  '화',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Regular_Day_List
                                                                .contains('수')
                                                            ? Colors.blue
                                                            : Colors.white),
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (Regular_Day_List.contains(
                                                    '수')) {
                                                  setState(() {
                                                    Regular_Day_List.remove(
                                                        '수');
                                                  });
                                                } else {
                                                  setState(() {
                                                    Regular_Day_List.add('수');
                                                  });
                                                }
                                              },
                                              child: Transform.translate(
                                                offset: Offset(-7, 0),
                                                child: Text(
                                                  '수',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Regular_Day_List
                                                                .contains('목')
                                                            ? Colors.blue
                                                            : Colors.white),
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (Regular_Day_List.contains(
                                                    '목')) {
                                                  setState(() {
                                                    Regular_Day_List.remove(
                                                        '목');
                                                  });
                                                } else {
                                                  setState(() {
                                                    Regular_Day_List.add('목');
                                                  });
                                                }
                                              },
                                              child: Transform.translate(
                                                offset: Offset(-7, 0),
                                                child: Text(
                                                  '목',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Regular_Day_List
                                                                .contains('금')
                                                            ? Colors.blue
                                                            : Colors.white),
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (Regular_Day_List.contains(
                                                    '금')) {
                                                  setState(() {
                                                    Regular_Day_List.remove(
                                                        '금');
                                                  });
                                                } else {
                                                  setState(() {
                                                    Regular_Day_List.add('금');
                                                  });
                                                }
                                              },
                                              child: Transform.translate(
                                                offset: Offset(-7, 0),
                                                child: Text(
                                                  '금',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Regular_Day_List
                                                                .contains('토')
                                                            ? Colors.blue
                                                            : Colors.white),
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (Regular_Day_List.contains(
                                                    '토')) {
                                                  setState(() {
                                                    Regular_Day_List.remove(
                                                        '토');
                                                  });
                                                } else {
                                                  setState(() {
                                                    Regular_Day_List.add('토');
                                                  });
                                                }
                                              },
                                              child: Transform.translate(
                                                offset: Offset(-7, 0),
                                                child: Text(
                                                  '토',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                        ),
                                        SizedBox(width: 10),
                                        Container(
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Regular_Day_List
                                                                .contains('일')
                                                            ? Colors.blue
                                                            : Colors.white),
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (Regular_Day_List.contains(
                                                    '일')) {
                                                  setState(() {
                                                    Regular_Day_List.remove(
                                                        '일');
                                                  });
                                                } else {
                                                  setState(() {
                                                    Regular_Day_List.add('일');
                                                  });
                                                }
                                              },
                                              child: Transform.translate(
                                                offset: Offset(-7, 0),
                                                child: Text(
                                                  '일',
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                ),
                                              )),
                                        )
                                      ]),
                                      SizedBox(height: 10),
                                      Text('복용 시간'),
                                      SizedBox(height: 10),
                                      Row(children: [
                                        Container(
                                            padding: EdgeInsets.only(left: 10),
                                            width: 70,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: TextField(
                                              controller: sep_controller1,
                                              decoration: InputDecoration(
                                                  hintText: '입력',
                                                  border: InputBorder.none),
                                            )),
                                        SizedBox(width: 30),
                                        Container(
                                            width: 150,
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: ElevatedButton(
                                              style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent)),
                                              child: Text(
                                                '${_selectedTime1.hour} : ${_selectedTime1.minute}',
                                                style: TextStyle(
                                                    color: Colors.grey),
                                              ),
                                              onPressed: () {
                                                setState(() {
                                                  showCupertinoDialog(
                                                      context: context,
                                                      barrierDismissible: true,
                                                      builder: (BuildContext
                                                          context) {
                                                        return Align(
                                                          alignment: Alignment
                                                              .bottomCenter,
                                                          child: Container(
                                                            color: Colors.white,
                                                            height: 300,
                                                            child:
                                                                CupertinoDatePicker(
                                                              mode:
                                                                  CupertinoDatePickerMode
                                                                      .time,
                                                              onDateTimeChanged:
                                                                  (DateTime
                                                                      date) {
                                                                setState(() {
                                                                  _selectedTime1 =
                                                                      date;
                                                                });
                                                              },
                                                            ),
                                                          ),
                                                        );
                                                      });
                                                });
                                              },
                                            )),
                                        SizedBox(width: 30),
                                        Container(
                                          alignment: Alignment.center,
                                          width: 30,
                                          height: 30,
                                          child: ElevatedButton(
                                              style: ButtonStyle(
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        more == 0
                                                            ? Color(0xff7885F8)
                                                            : Colors.grey),
                                                shadowColor:
                                                    MaterialStateProperty.all(
                                                        Colors.transparent),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            90),
                                                  ),
                                                ),
                                              ),
                                              onPressed: () {
                                                if (more == 0) {
                                                  setState(() {
                                                    more += 1;
                                                  });
                                                } else {
                                                  setState(() {
                                                    more -= 1;
                                                  });
                                                }
                                              },
                                              child: Transform.translate(
                                                  offset: Offset(-12, 0),
                                                  child: more == 0
                                                      ? Icon(Icons.add)
                                                      : Transform.translate(
                                                          offset:
                                                              Offset(-6, -13),
                                                          child: Icon(
                                                            Icons.minimize,
                                                            size: 35,
                                                          ),
                                                        ))),
                                        )
                                      ]),
                                      more > 0
                                          ? Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Row(children: [
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: TextField(
                                                        controller:
                                                            sep_controller2,
                                                        decoration:
                                                            InputDecoration(
                                                                hintText: '입력',
                                                                border:
                                                                    InputBorder
                                                                        .none),
                                                      )),
                                                  SizedBox(width: 30),
                                                  Container(
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .transparent),
                                                            shadowColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .transparent)),
                                                        child: Text(
                                                          '${_selectedTime2.hour} : ${_selectedTime2.minute}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            showCupertinoDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                          .white,
                                                                      height:
                                                                          300,
                                                                      child:
                                                                          CupertinoDatePicker(
                                                                        mode: CupertinoDatePickerMode
                                                                            .time,
                                                                        onDateTimeChanged:
                                                                            (DateTime
                                                                                date) {
                                                                          setState(
                                                                              () {
                                                                            _selectedTime2 =
                                                                                date;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  );
                                                                });
                                                          });
                                                        },
                                                      )),
                                                  SizedBox(width: 30),
                                                  Container(
                                                    alignment: Alignment.center,
                                                    width: 30,
                                                    height: 30,
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(more == 1
                                                                      ? Color(
                                                                          0xff7885F8)
                                                                      : Colors
                                                                          .grey),
                                                          shadowColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .transparent),
                                                          shape: MaterialStateProperty
                                                              .all<
                                                                  RoundedRectangleBorder>(
                                                            RoundedRectangleBorder(
                                                              borderRadius:
                                                                  BorderRadius
                                                                      .circular(
                                                                          90),
                                                            ),
                                                          ),
                                                        ),
                                                        onPressed: () {
                                                          if (more == 1) {
                                                            setState(() {
                                                              more += 1;
                                                            });
                                                          } else {
                                                            setState(() {
                                                              more -= 1;
                                                            });
                                                          }
                                                        },
                                                        child:
                                                            Transform.translate(
                                                                offset: Offset(
                                                                    -12, 0),
                                                                child: more == 1
                                                                    ? Icon(Icons
                                                                        .add)
                                                                    : Transform
                                                                        .translate(
                                                                        offset: Offset(
                                                                            -6,
                                                                            -13),
                                                                        child:
                                                                            Icon(
                                                                          Icons
                                                                              .minimize,
                                                                          size:
                                                                              35,
                                                                        ),
                                                                      ))),
                                                  )
                                                ]),
                                              ],
                                            )
                                          : Container(),
                                      more > 1
                                          ? Column(
                                              children: [
                                                SizedBox(height: 10),
                                                Row(children: [
                                                  Container(
                                                      padding: EdgeInsets.only(
                                                          left: 10),
                                                      width: 70,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: TextField(
                                                        controller:
                                                            sep_controller3,
                                                        decoration:
                                                            InputDecoration(
                                                                hintText: '입력',
                                                                border:
                                                                    InputBorder
                                                                        .none),
                                                      )),
                                                  SizedBox(width: 30),
                                                  Container(
                                                      width: 150,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      15)),
                                                      child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .transparent),
                                                            shadowColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .transparent)),
                                                        child: Text(
                                                          '${_selectedTime3.hour} : ${_selectedTime3.minute}',
                                                          style: TextStyle(
                                                              color:
                                                                  Colors.grey),
                                                        ),
                                                        onPressed: () {
                                                          setState(() {
                                                            showCupertinoDialog(
                                                                context:
                                                                    context,
                                                                barrierDismissible:
                                                                    true,
                                                                builder:
                                                                    (BuildContext
                                                                        context) {
                                                                  return Align(
                                                                    alignment:
                                                                        Alignment
                                                                            .bottomCenter,
                                                                    child:
                                                                        Container(
                                                                      color: Colors
                                                                          .white,
                                                                      height:
                                                                          300,
                                                                      child:
                                                                          CupertinoDatePicker(
                                                                        mode: CupertinoDatePickerMode
                                                                            .time,
                                                                        onDateTimeChanged:
                                                                            (DateTime
                                                                                date) {
                                                                          setState(
                                                                              () {
                                                                            _selectedTime3 =
                                                                                date;
                                                                          });
                                                                        },
                                                                      ),
                                                                    ),
                                                                  );
                                                                });
                                                          });
                                                        },
                                                      )),
                                                ]),
                                              ],
                                            )
                                          : Container(),
                                      SizedBox(height: 10),
                                      Text('알림 설정'),
                                      SizedBox(height: 10),
                                      Container(
                                        decoration: BoxDecoration(
                                            color: Colors.white,
                                            borderRadius:
                                                BorderRadius.circular(15)),
                                        child: Row(children: [
                                          Text('   복용 시간 알람'),
                                          Spacer(),
                                          Switch(
                                              value: Is_ALARM,
                                              onChanged: (value) {
                                                setState(() {
                                                  Is_ALARM = value;
                                                });
                                              })
                                        ]),
                                      )
                                    ]),
                              ),
                              SizedBox(height: screenHeight * 0.04),
                              Container(
                                  width: screenWidth,
                                  child: Expanded(
                                      child: Container(
                                          height: screenHeight * 0.12,
                                          child: Row(children: [
                                            Expanded(
                                              child: Container(
                                                  decoration: BoxDecoration(
                                                      color: Colors.grey),
                                                  child: ElevatedButton(
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .transparent),
                                                          shadowColor:
                                                              MaterialStateProperty
                                                                  .all(Colors
                                                                      .transparent)),
                                                      onPressed: () {
                                                        setState(() {
                                                          state = 1;
                                                          sub_screen = 0;
                                                        });
                                                      },
                                                      child: Text('취소'))),
                                            ),
                                            Expanded(
                                                child: Container(
                                                    decoration: BoxDecoration(
                                                        color:
                                                            Color(0xff7885F8)),
                                                    child: ElevatedButton(
                                                        style: ButtonStyle(
                                                            backgroundColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .transparent),
                                                            shadowColor:
                                                                MaterialStateProperty
                                                                    .all(Colors
                                                                        .transparent)),
                                                        onPressed: () {
                                                          int duration = int.parse(
                                                              DurationController
                                                                  .text);
                                                          Map<DateTime, bool>
                                                              just_check = {};
                                                          for (int i = 0;
                                                              i < duration;
                                                              i++) {
                                                            just_check[startday
                                                                    .add(Duration(
                                                                        days:
                                                                            i))] =
                                                                false;
                                                          }
                                                          if (Medi_name_cntroller.text.isEmpty == false &&
                                                                  DurationController
                                                                          .text
                                                                          .isEmpty ==
                                                                      false &&
                                                                  sep_controller1
                                                                          .text
                                                                          .isEmpty ==
                                                                      false &&
                                                                  more > 0
                                                              ? sep_controller2
                                                                      .text
                                                                      .isEmpty ==
                                                                  false
                                                              : true && more > 1
                                                                  ? sep_controller3
                                                                          .text
                                                                          .isEmpty ==
                                                                      false
                                                                  : true) {
                                                            setState(() {
                                                              sub_screen = 0;
                                                              state = 1;
                                                              New_Medicine =
                                                                  Medicine(
                                                                      Medi_name_cntroller
                                                                          .text,
                                                                      startday,
                                                                      selectedcolor,
                                                                      _IS_ALWAYS,
                                                                      duration,
                                                                      _IS_ALWAYS,
                                                                      more == 0
                                                                          ? {
                                                                              '$sep_controller1': '${_selectedTime1.hour}:${_selectedTime1.microsecond}'
                                                                            }
                                                                          : more == 1
                                                                              ? {
                                                                                  '$sep_controller1': '${_selectedTime1.hour}:${_selectedTime1.microsecond}',
                                                                                  '$sep_controller2': '${_selectedTime2.hour}:${_selectedTime2.microsecond}'
                                                                                }
                                                                              : {
                                                                                  '$sep_controller1': '${_selectedTime1.hour}:${_selectedTime1.microsecond}',
                                                                                  '$sep_controller2': '${_selectedTime2.hour}:${_selectedTime2.microsecond}',
                                                                                  '$sep_controller3': '${_selectedTime3.hour}:${_selectedTime3.microsecond}'
                                                                                },
                                                                      just_check,
                                                                      '테마');
                                                              for (int i = 0;
                                                                  i < duration;
                                                                  i++) {
                                                                Day_Medicine[New_Medicine
                                                                        .startday
                                                                        .add(Duration(
                                                                            days:
                                                                                i))]
                                                                    ?.add(
                                                                        New_Medicine);
                                                                User_medicine.add(
                                                                    New_Medicine);
                                                              }
                                                              Post_data();
                                                              Medi_Buileder(
                                                                  New_Medicine);
                                                            });
                                                          }
                                                        },
                                                        child: Text('저장'))))
                                          ]))))
                            ]),
                            sub_screen == 1
                                ? Transform.translate(
                                    offset: Offset(60, 85),
                                    child: Container(
                                      padding: EdgeInsets.all(5),
                                      height: 50,
                                      width: 200,
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          borderRadius:
                                              BorderRadius.circular(15),
                                          border:
                                              Border.all(color: Colors.black)),
                                      child: Row(
                                        children: [
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color_List[0]),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    sub_screen = 0;
                                                    selectedcolor =
                                                        Color_List[0];
                                                  });
                                                },
                                                child: Container()),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color_List[1]),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    sub_screen = 0;
                                                    selectedcolor =
                                                        Color_List[1];
                                                  });
                                                },
                                                child: Container()),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color_List[2]),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    sub_screen = 0;
                                                    selectedcolor =
                                                        Color_List[2];
                                                  });
                                                },
                                                child: Container()),
                                          ),
                                          SizedBox(width: 10),
                                          Container(
                                            width: 30,
                                            height: 30,
                                            child: ElevatedButton(
                                                style: ButtonStyle(
                                                  backgroundColor:
                                                      MaterialStateProperty.all(
                                                          Color_List[3]),
                                                  shadowColor:
                                                      MaterialStateProperty.all(
                                                          Colors.transparent),
                                                  shape:
                                                      MaterialStateProperty.all<
                                                          RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              90),
                                                    ),
                                                  ),
                                                ),
                                                onPressed: () {
                                                  setState(() {
                                                    sub_screen = 0;
                                                    selectedcolor =
                                                        Color_List[3];
                                                  });
                                                },
                                                child: Container()),
                                          )
                                        ],
                                      ),
                                    ),
                                  )
                                : sub_screen == 2
                                    ? Column(
                                        children: [
                                          SizedBox(height: screenHeight * 0.1),
                                          Container(
                                            width: screenWidth * 0.9,
                                            height: screenHeight * 0.6,
                                            decoration: BoxDecoration(
                                                color:
                                                    Colors.white.withOpacity(1),
                                                borderRadius:
                                                    BorderRadius.circular(15)),
                                            child: Column(
                                              children: [
                                                TableCalendar(
                                                  calendarFormat:
                                                      CalendarFormat.month,
                                                  calendarStyle: CalendarStyle(
                                                      cellMargin:
                                                          EdgeInsets.all(6),
                                                      cellPadding:
                                                          EdgeInsets.all(0),
                                                      markerDecoration:
                                                          BoxDecoration(
                                                              color: Colors
                                                                  .transparent),
                                                      isTodayHighlighted: true),
                                                  locale: 'ko_KR',
                                                  firstDay:
                                                      DateTime.utc(2023, 1, 1),
                                                  lastDay: DateTime.utc(
                                                      2024, 12, 31),
                                                  focusedDay: _focusedDay,
                                                  headerStyle: HeaderStyle(
                                                    leftChevronVisible: false,
                                                    rightChevronVisible: false,
                                                    titleCentered: true,
                                                    titleTextStyle:
                                                        TextStyle(fontSize: 30),
                                                    formatButtonVisible: false,
                                                  ),
                                                  availableGestures:
                                                      AvailableGestures
                                                          .horizontalSwipe,
                                                  selectedDayPredicate: (day) {
                                                    return isSameDay(
                                                        _selectedDay, day);
                                                  },
                                                  onDaySelected: (selectedDay,
                                                      focusedDay) {
                                                    setState(() {
                                                      _selectedDay =
                                                          selectedDay;
                                                      _focusedDay = focusedDay;
                                                      _selectedMedicines.value =
                                                          _getMedicinesForDay(
                                                              selectedDay);
                                                    });
                                                  },
                                                  onFormatChanged: (format) {
                                                    setState(() {
                                                      _calendarFormat = format;
                                                    });
                                                  },
                                                  onPageChanged: (focusedDay) {
                                                    _focusedDay = focusedDay;
                                                  },
                                                ),
                                                Spacer(),
                                                Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: Container(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: ElevatedButton(
                                                      onPressed: () {
                                                        setState(() {
                                                          sub_screen = 0;
                                                          startday =
                                                              _selectedDay;
                                                        });
                                                      },
                                                      child: Text('확인'),
                                                      style: ButtonStyle(
                                                          backgroundColor:
                                                              MaterialStateProperty
                                                                  .all(Color(
                                                                      0xff7885F8))),
                                                    ),
                                                  ),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      )
                                    : Container()
                          ],
                        )
                      : Container(),
            ]))));
  }

  Widget medicine_list() {
    return ValueListenableBuilder<List<Medicine>>(
        valueListenable: _selectedMedicines,
        builder: (context, medicines, _) {
          String calculate(DateTime time, int num) {
            DateTime S_time = time.add(Duration(days: num));
            return '${time.year}-${time.month}-${time.day}~${S_time.year}-${S_time.month}-${S_time.day}';
          }

          return Expanded(
              child: ListView.builder(
                  itemCount: medicines.length,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return Container(
                      margin: const EdgeInsets.only(
                          top: 10, bottom: 10, left: 30, right: 30),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(children: [
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(medicines[index].name),
                            SizedBox(height: 3),
                            Text(
                              calculate(medicines[index].startday,
                                  medicines[index].duration),
                              style:
                                  TextStyle(fontSize: 10, color: Colors.grey),
                            )
                          ],
                        ),
                        Spacer(),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              setState(() {
                                state = 2;
                              });
                            },
                            child: Text('수정'),
                            style: ButtonStyle(
                                shape: MaterialStateProperty.all<
                                    RoundedRectangleBorder>(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  ),
                                ),
                                fixedSize:
                                    MaterialStateProperty.all(Size(70, 20)),
                                backgroundColor:
                                    MaterialStateProperty.all(Colors.grey)),
                          ),
                        ),
                      ]),
                    );
                  }));
        });
  }
}

class Medicine {
  String name;
  Color color;
  bool alarm;
  DateTime startday;
  int duration;
  bool repeat;
  Map<String, String> Time;
  Map<DateTime, bool> check;
  String category;
  Medicine(this.name, this.startday, this.color, this.alarm, this.duration,
      this.repeat, this.Time, this.check, this.category);
}
