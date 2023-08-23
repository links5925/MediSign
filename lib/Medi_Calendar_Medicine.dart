// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, file_names, library_private_types_in_public_api, camel_case_types, unused_element, unrelated_type_equality_checks, prefer_interpolation_to_compose_strings, sort_child_properties_last
import 'package:flutter/material.dart';
import 'package:flutter_medicine/Default_set/Default_Logo.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:table_calendar/table_calendar.dart';

class Medi_Calendar_Medicine extends StatefulWidget {
  const Medi_Calendar_Medicine({super.key});
  @override
  _Medi_Calendar_MedicineState createState() => _Medi_Calendar_MedicineState();
}

double screenHeight = 1;
double screenWidth = 1;
Color selected_color = Colors.transparent;
List<Widget> Color_button_List = [];
List<Medicine> checker = [];
List<bool> ctrl_list = [];
List<Widget> Group_Setting = [];
List<Widget> Sub_Group_Setting = [];
Map<Color, String> Categorize = {};
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
Set<Medicine> Medi_Set = {};

class _Medi_Calendar_MedicineState extends State<Medi_Calendar_Medicine> {
  TextEditingController ctrl = TextEditingController();

  List<Color> Color_List = [
    Colors.red,
    Colors.yellow,
    Colors.green,
    Colors.brown
  ];

  int state = 1;
  CalendarFormat _calendarFormat = CalendarFormat.week; // 이 부분에서 수정
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late ValueNotifier<List<Medicine>> _selectedMedicines;
  bool show_color = false;

  @override
  void initState() {
    super.initState();
    make_color_button();
    _loadUserinfo();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedMedicines =
        ValueNotifier<List<Medicine>>(_getMedicinesForDay(_selectedDay));
    for (var medicine in Day_Medicine.values) {
      Medi_Set.addAll(medicine);
    }
    Make_Category(Colors.black, '카테고리');
  }

  Future<void> _loadUserinfo() async {
    SharedPreferences user_info = await SharedPreferences.getInstance();
    int loadscreenWidth = user_info.getInt('Width') ?? 0;
    int loadscreenHeight = user_info.getInt('Height') ?? 0;

    setState(() {
      screenWidth = loadscreenWidth.toDouble();
      screenHeight = loadscreenHeight.toDouble();
    });
  }

  _state_3(Color color) {
    for (Medicine medicine in Medi_Set) {
      if (medicine.color == color) {
        Make_Sub(medicine.color, medicine.name);
      }
    }
  }

  void Make_Category(Color color, String category) {
    Group_Setting.add(Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
            height: screenHeight * 0.08,
            width: screenWidth * 0.8,
            color: Colors.transparent,
            child: ElevatedButton(
                onPressed: () {
                  setState(() {
                    Sub_Group_Setting = [];
                    _state_3(color);
                    state = 3;
                  });
                },
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(1),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                child: Row(children: [
                  Icon(
                    Icons.circle,
                    color: color,
                    size: 25,
                  ),
                  Text('$category',
                      style: TextStyle(fontSize: 18, color: Colors.black))
                ])))));
  }

  void Make_Sub(Color color, String category) {
    Sub_Group_Setting.add(Padding(
        padding: const EdgeInsets.only(bottom: 15),
        child: Container(
            height: screenHeight * 0.08,
            width: screenWidth * 0.8,
            color: Colors.transparent,
            child: ElevatedButton(
                onPressed: () {
                  setState(() {});
                },
                style: ButtonStyle(
                    elevation: MaterialStateProperty.all(1),
                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    )),
                    backgroundColor: MaterialStateProperty.all(Colors.white)),
                child: Row(children: [
                  Icon(
                    Icons.circle,
                    color: color,
                    size: 25,
                  ),
                  Text('$category',
                      style: TextStyle(fontSize: 18, color: Colors.black))
                ])))));
  }

  void changemedicine(Map<DateTime, List<Medicine>> Day_Medicine, DateTime day,
      Medicine medicine) {
    setState(() {
      int? index = Day_Medicine[day]?.indexOf(medicine) ?? 0;
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

  void make_color_button() {
    for (Color color in Color_List) {
      Color_button_List.add(Container(
        width: 30,
        height: 30,
        child: ElevatedButton(
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(color),
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(90),
                  ),
                )),
            onPressed: () {
              setState(() {
                selected_color = Color_List[Color_List.indexOf(color)];
              });
            },
            child: Container()),
      ));
    }
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
              Default_Logo(),
              Container(
                  height: screenHeight * 0.82,
                  width: screenWidth * 0.88,
                  decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.7),
                      borderRadius: BorderRadius.all(Radius.circular(15))),
                  child: Column(children: [
                    state == 1
                        ? Column(children: [
                            Row(
                              children: [
                                Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Text('메디캘린더',
                                        style: TextStyle(fontSize: 20))),
                                Container(
                                  width: screenWidth * 0.36,
                                  height: screenHeight * 0.03,
                                  decoration: BoxDecoration(
                                      color: Color.fromARGB(255, 217, 217, 217),
                                      borderRadius: BorderRadius.circular(30)),
                                  child: ElevatedButton(
                                      onPressed: () {
                                        setState(() {
                                          state = 2;
                                        });
                                      },
                                      child: Stack(
                                        children: [
                                          Transform.translate(
                                            offset: Offset(-10, -2),
                                            child: Icon(
                                                Icons.mode_edit_outlined,
                                                color: Colors.black,
                                                size: 18),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 10),
                                            child: Text('복용 알림 설정하기',
                                                style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 10)),
                                          ),
                                        ],
                                      ),
                                      style: ButtonStyle(
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.transparent),
                                          shadowColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.transparent))),
                                )
                              ],
                            ),
                            Column(children: [
                              Row(
                                children: [
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 15, bottom: 10),
                                    child: Text(
                                      '${_selectedDay.year}년 ${_selectedDay.month}월 ${_selectedDay.day}일 ' +
                                          re_weekday({_selectedDay.weekday}) +
                                          '요일',
                                      style: TextStyle(fontSize: 20),
                                    ),
                                  ),
                                ],
                              ),
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
                                  }),
                              Container(
                                child: medicine_list(),
                                width: screenWidth * 0.8,
                                height: screenHeight * 0.55,
                              )
                            ])
                          ])
                        : state == 2
                            ? Stack(
                                alignment: Alignment.topCenter,
                                children: [
                                  Column(children: [
                                    Padding(
                                        padding: const EdgeInsets.all(15.0),
                                        child: Row(children: [
                                          Text('> 약 종류 설정하기',
                                              style: TextStyle(fontSize: 20))
                                        ])),
                                    Column(
                                      children: Group_Setting,
                                    ),
                                    Container(
                                        width: screenWidth * 0.8,
                                        height: screenHeight * 0.08,
                                        child: ElevatedButton(
                                            onPressed: () {
                                              setState(() {});
                                            },
                                            style: ButtonStyle(
                                                shape: MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                    RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                )),
                                                backgroundColor:
                                                    MaterialStateProperty.all(
                                                        Color(0xff7885F8))),
                                            child: Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                      alignment:
                                                          Alignment.topCenter,
                                                      decoration: BoxDecoration(
                                                          color: Colors.white,
                                                          borderRadius:
                                                              BorderRadius
                                                                  .circular(
                                                                      90)),
                                                      height: 30,
                                                      width: 30,
                                                      child: Transform.translate(
                                                          offset: Offset(0, -5),
                                                          child: Text('+',
                                                              style: TextStyle(
                                                                  fontSize: 30,
                                                                  color: Color(
                                                                      0xff7885F8))))),
                                                  Text('  약 종류 추가하기')
                                                ])))
                                  ]),
                                  show_color
                                      ? Column(
                                          children: [
                                            SizedBox(
                                              height: screenHeight * 0.2,
                                            ),
                                            Container(
                                                width: screenWidth * 0.9,
                                                height: screenHeight * 0.35,
                                                color: Colors.white,
                                                child: Column(
                                                  children: [
                                                    Row(children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 20),
                                                          child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            child:
                                                                Color_button_List[
                                                                    0],
                                                          )),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 20),
                                                          child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            child:
                                                                Color_button_List[
                                                                    1],
                                                          )),
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 20),
                                                          child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            child:
                                                                Color_button_List[
                                                                    2],
                                                          ))
                                                    ]),
                                                    Row(children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 20,
                                                                  top: 20),
                                                          child: Container(
                                                            width: 30,
                                                            height: 30,
                                                            child:
                                                                Color_button_List[
                                                                    3],
                                                          ))
                                                    ]),
                                                    SizedBox(
                                                        height: screenHeight *
                                                            0.03),
                                                    Row(children: [
                                                      Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                      .only(
                                                                  left: 18),
                                                          child: Text(
                                                            '약 종류명:',
                                                            style: TextStyle(
                                                                fontSize: 18),
                                                          )),
                                                      Container(
                                                          alignment: Alignment
                                                              .bottomLeft,
                                                          width: 150,
                                                          height: 10,
                                                          child: Transform
                                                              .translate(
                                                                  offset:
                                                                      Offset(0,
                                                                          10),
                                                                  child:
                                                                      TextField(
                                                                    controller:
                                                                        ctrl,
                                                                    autofocus:
                                                                        true,
                                                                    decoration:
                                                                        InputDecoration(
                                                                      isDense:
                                                                          true,
                                                                    ),
                                                                    cursorColor:
                                                                        Colors
                                                                            .transparent,
                                                                  )))
                                                    ]),
                                                    Spacer(),
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.all(
                                                              18.0),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          Container(
                                                            width: screenWidth *
                                                                0.18,
                                                            height:
                                                                screenHeight *
                                                                    0.05,
                                                            child: ElevatedButton(
                                                                onPressed: () {
                                                                  setState(() {
                                                                    show_color =
                                                                        false;
                                                                    Make_Category(
                                                                        selected_color,
                                                                        ctrl.text);
                                                                  });
                                                                },
                                                                style: ButtonStyle(
                                                                    shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                                                                      RoundedRectangleBorder(
                                                                        borderRadius:
                                                                            BorderRadius.circular(15),
                                                                      ),
                                                                    ),
                                                                    backgroundColor: MaterialStateProperty.all(Color(0xff7885F8).withOpacity(0.7))),
                                                                child: Text('저장')),
                                                          )
                                                        ],
                                                      ),
                                                    )
                                                  ],
                                                )),
                                          ],
                                        )
                                      : Container()
                                ],
                              )
                            : Container(
//3필요시
                                )
                  ]))
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
                          top: 10, bottom: 10, left: 10, right: 10),
                      decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.75),
                          borderRadius: BorderRadius.circular(15)),
                      child: Row(children: [
                        SizedBox(width: 10),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Icon(Icons.circle,
                                    color: medicines[index].color),
                                SizedBox(width: 10),
                                Text(medicines[index].name),
                              ],
                            ),
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
                                if (checker.contains(medicines[index]) ==
                                    false) {
                                  setState(() {
                                    checker.add(medicines[index]);
                                  });
                                }
                                if (medicines[index].check == false &&
                                    Day_Medicine[medicines[index].Time]!
                                        .contains(medicines)) {
                                  var Will_Change =
                                      Day_Medicine[medicines[index].Time]!
                                          .indexOf(medicines[index]);
                                  setState(() {
                                    Day_Medicine[medicines[index].Time]![
                                            Will_Change]
                                        .check[_selectedDay] = true;
                                  });
                                }
                                Day_Medicine;
                              },
                              child:
                                  Text('복용함', style: TextStyle(fontSize: 12)),
                              style: ButtonStyle(
                                  shape: MaterialStateProperty.all<
                                          RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(30),
                                  )),
                                  fixedSize:
                                      MaterialStateProperty.all(Size(70, 20)),
                                  backgroundColor: MaterialStateProperty.all(
                                      checker.contains(medicines[index])
                                          ? Color(0xff7885F8)
                                          : Colors.grey)),
                            )),
                        Padding(
                          padding: const EdgeInsets.only(right: 10),
                          child: ElevatedButton(
                            onPressed: () {
                              if (checker.contains(medicines[index])) {
                                setState(() {
                                  checker.remove(medicines[index]);
                                });
                              }
                            },
                            child: Text(
                              '복용 안 함',
                              style: TextStyle(fontSize: 8),
                            ),
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
