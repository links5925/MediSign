// ignore_for_file: sized_box_for_whitespace, non_constant_identifier_names, file_names, library_private_types_in_public_api

import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';

class Calendar extends StatefulWidget {
  @override
  _CalendarState createState() => _CalendarState();
}

class _CalendarState extends State<Calendar> {
  late CalendarFormat _calendarFormat;
  late DateTime _focusedDay;
  late DateTime _selectedDay;
  late ValueNotifier<List<Medicine>> _selectedEvents;
  void _onFormatToggled(bool isWeek) {
    setState(() {
      _calendarFormat = isWeek ? CalendarFormat.week : CalendarFormat.month;
    });
  }

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvents =
        ValueNotifier<List<Medicine>>(_getEventsForDay(_selectedDay));
  }

  Map<DateTime, List<Medicine>> events = {
    DateTime.utc(2023, 8, 7): [Medicine('title')],
    DateTime.utc(2023, 8, 13): [Medicine('title'), Medicine('title2')],
    DateTime.utc(2023, 8, 14): [Medicine('title3')]
  };

  List<Medicine> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('내가 약을 먹을 날짜를 확인하세요'),
            ToggleButtons(
              constraints: BoxConstraints(
                  maxWidth: screenWidth * 0.1,
                  maxHeight: screenHeight * 0.05,
                  minHeight: screenHeight * 0.05,
                  minWidth: screenWidth * 0.1),
              children: [Text('월'), Text('주')],
              isSelected: [
                _calendarFormat == CalendarFormat.month,
                _calendarFormat == CalendarFormat.week,
              ],
              onPressed: (index) {
                setState(() {
                  _onFormatToggled(index == 1);
                });
              },
            ),
          ],
        ),
        TableCalendar(
          calendarStyle: CalendarStyle(
            cellMargin: EdgeInsets.all(6),
            cellPadding: EdgeInsets.all(0),
            isTodayHighlighted: true,
          ),
          locale: 'ko_KR',
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2024, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          eventLoader: _getEventsForDay,
          headerVisible: false,
          headerStyle: HeaderStyle(
              leftChevronVisible: false,
              rightChevronVisible: false,
              titleTextStyle: TextStyle(fontSize: 0),
              headerPadding: EdgeInsets.only(left: 100, right: 100),
              formatButtonVisible: true,
              formatButtonDecoration: BoxDecoration()),
          availableGestures: AvailableGestures.none,
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
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
      ],
    );
  }
}

class Medicine {
  final String name;
  final String group;
  final String color;
  final bool check;

  Medicine(this.name, {this.group = '', this.color = '', this.check = false});
}
