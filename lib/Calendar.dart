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
  late ValueNotifier<List<Event>> _selectedEvents;

  @override
  void initState() {
    super.initState();
    _calendarFormat = CalendarFormat.month;
    _focusedDay = DateTime.now();
    _selectedDay = _focusedDay;
    _selectedEvents =
        ValueNotifier<List<Event>>(_getEventsForDay(_selectedDay));
  }

  // Future<void> _saveRegisterInfo() async {
  // SharedPreferences user_info = await SharedPreferences.getInstance();

  // user_info.setStringList('Calendaer_alra', );
  // }

  Map<DateTime, List<Event>> events = {
    DateTime.utc(2023, 8, 7): [Event('title')],
    DateTime.utc(2023, 8, 13): [Event('title'), Event('title2')],
    DateTime.utc(2023, 8, 14): [Event('title3')],
  };

  List<Event> _getEventsForDay(DateTime day) {
    return events[day] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        TableCalendar(
          calendarStyle: CalendarStyle(
            cellMargin: EdgeInsets.all(6),
            cellPadding: EdgeInsets.all(0),
            isTodayHighlighted: true,
          ),
          rowHeight: 31,
          locale: 'ko_KR',
          firstDay: DateTime.utc(2023, 1, 1),
          lastDay: DateTime.utc(2024, 12, 31),
          focusedDay: _focusedDay,
          calendarFormat: _calendarFormat,
          eventLoader: _getEventsForDay,
          headerStyle: HeaderStyle(
            leftChevronVisible: false,
            rightChevronVisible: false,
            formatButtonVisible: false,
            titleTextStyle: TextStyle(
              fontSize: screenWidth * 0,
              color: Colors.black,
            ),
          ),
          selectedDayPredicate: (day) {
            return isSameDay(_selectedDay, day);
          },
          onDaySelected: (selectedDay, focusedDay) {
            setState(() {
              _selectedDay = selectedDay;
              _focusedDay = focusedDay;
              _selectedEvents.value = _getEventsForDay(selectedDay);
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
        SizedBox(height: screenHeight * 0.05),
        ValueListenableBuilder<List<Event>>(
          valueListenable: _selectedEvents,
          builder: (context, events, _) {
            return Container(
              height: 0.1 * screenHeight,
              child: Expanded(
                child: ListView.builder(
                  itemCount: events.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(events[index].title),
                    );
                    // SizedBox(height: screenHeight*0.05),
                    // ValueListenableBuilder<List<Event>>(
                    // valueListenable: _selectedEvents,
                    // builder: (context, events, _) {
                    // return Expanded(
                    // child: ListView.builder(
                    // itemCount: events.length,
                    // itemBuilder: (context, index) {
                    // return ListTile(
                    // title: Text(events[index].title),
                    // 여기에 이벤트에 대한 추가 정보를 표시할 수 있습니다.
                    // 예: 시간, 장소 등
                    // );
                    // },
                    // ),
                    // );
                    // },
                    // ),
                  },
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}

class Event {
  final String title;
  final String medicine;
  final String Medinfo;
  final String MEdimage;

  Event(this.title,
      {this.medicine = '', this.MEdimage = '', this.Medinfo = ''});
}
