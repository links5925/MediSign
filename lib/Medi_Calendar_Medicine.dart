// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, file_names, library_private_types_in_public_api, camel_case_types, unused_element, unrelated_type_equality_checks, prefer_interpolation_to_compose_strings, sort_child_properties_last

import 'package:flutter/material.dart';
import 'package:flutter_medicine/Default_set/Default_Logo.dart';
import 'package:table_calendar/table_calendar.dart';

class Medi_Calendar_Medicine extends StatefulWidget {
  const Medi_Calendar_Medicine({super.key});
  @override
  _Medi_Calendar_MedicineState createState() => _Medi_Calendar_MedicineState();
}

class _Medi_Calendar_MedicineState extends State<Medi_Calendar_Medicine> {
  int state = 1;
  CalendarFormat _calendarFormat = CalendarFormat.week; // 이 부분에서 수정
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late ValueNotifier<List<Medicine>> _selectedMedicines;
  Map<DateTime, List<Medicine>> Day_Medicine = {
    DateTime.utc(2023, 8, 7): [Medicine('title', '1', Colors.red, true)],
    DateTime.utc(2023, 8, 13): [
      Medicine('title2', '2', Colors.black, false),
      Medicine('title3', '2', Colors.black, false)
    ],
    DateTime.utc(2023, 8, 14): [Medicine('title4', '3', Colors.black, false)],
  };
  bool ctrl_1 = false;
  bool ctrl_2 = false;
  bool ctrl_3 = false;
  bool ctrl_4 = false;
  bool ctrl_5 = false;
  bool ctrl_6 = false;
  bool ctrl_7 = false;
  bool ctrl_8 = false;
  bool ctrl_9 = false;
  bool ctrl_10 = false;
  List<bool> ctrl_list = [];
  @override
  void initState() {
    super.initState();
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedMedicines =
        ValueNotifier<List<Medicine>>(_getMedicinesForDay(_selectedDay));
    Day_Medicine = {
      DateTime.utc(2023, 8, 7): [Medicine('title', '1', Colors.black, true)],
      DateTime.utc(2023, 8, 13): [
        Medicine('title2', '2', Colors.blue, false),
        Medicine('title3', '2', Colors.black, false)
      ],
      DateTime.utc(2023, 8, 14): [Medicine('title4', '3', Colors.black, false)],
    };
    ctrl_list.add(ctrl_1);
    ctrl_list.add(ctrl_2);
    ctrl_list.add(ctrl_3);
    ctrl_list.add(ctrl_4);
    ctrl_list.add(ctrl_5);
    ctrl_list.add(ctrl_6);
    ctrl_list.add(ctrl_7);
    ctrl_list.add(ctrl_8);
    ctrl_list.add(ctrl_9);
    ctrl_list.add(ctrl_10);
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
          child: Column(
            children: [
              Default_Logo(),
              Container(
                height: screenHeight * 0.82,
                width: screenWidth * 0.88,
                decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.7),
                    borderRadius: BorderRadius.all(Radius.circular(15))),
                child: Column(
                  children: [
                    Row(
                      children: [
                        Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: Text('약 종류 설정하기',
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
                                    child: Icon(Icons.mode_edit_outlined,
                                        color: Colors.black, size: 18),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(left: 10),
                                    child: Text('복용 알림 설정하기',
                                        style: TextStyle(
                                            color: Colors.black, fontSize: 10)),
                                  ),
                                ],
                              ),
                              style: ButtonStyle(
                                  backgroundColor:
                                      MaterialStateProperty.all<Color>(
                                          Colors.transparent),
                                  shadowColor: MaterialStateProperty.all<Color>(
                                      Colors.transparent))),
                        )
                      ],
                    ),
                    state == 1
                        ? Column(
                            children: [
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
                                    isTodayHighlighted: true),
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
                              ),
                              Container(
                                child: medicine_list(),
                                width: screenWidth * 0.8,
                                height: screenHeight * 0.55,
                              ),
                            ],
                          )
                        : Container(),
                    state == 2 ? Container() : Container()
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget medicine_list() {
    return ValueListenableBuilder<List<Medicine>>(
        valueListenable: _selectedMedicines,
        builder: (context, medicines, _) {
          return Expanded(
              child: ListView.builder(
                  itemCount: medicines.length,
                  padding: EdgeInsets.all(0),
                  itemBuilder: (context, index) {
                    return Row(children: [
                      Icon(Icons.circle,
                          size: 14, color: medicines[index].color),
                      SizedBox(width: 10),
                      Text(medicines[index].name),
                      Spacer(),
                      ElevatedButton(
                          onPressed: () {
                            if (Day_Medicine[_selectedDay]![index].check !=
                                true) {
                              setState() {
                                Day_Medicine[_selectedDay]![index].check = true;
                              }

                              ;
                            } else {
                              setState() {
                                Day_Medicine[_selectedDay]![index].check = true;
                              }

                              ;
                            }
                          },
                          child: Day_Medicine[_selectedDay]![index].check
                              ? Text('a')
                              : Text('b')),
                      Checkbox(
                          value: Day_Medicine[_selectedDay]![index].check,
                          onChanged: (value) {
                            setState(() {
                              changemedicine(
                                  Day_Medicine,
                                  _selectedDay,
                                  Medicine(
                                      medicines[index].name,
                                      medicines[index].group,
                                      medicines[index].color,
                                      true));
                            });
                          })
                    ]);
                  }));
        });
  }
}

class Medicine {
  String name;
  String group;
  Color color;
  bool check;

  Medicine(this.name, this.group, this.color, this.check);
}
