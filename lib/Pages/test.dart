import 'dart:collection';

import 'package:eventora/utils/testCalendar.dart';
import 'package:flutter/material.dart';
import 'package:get/route_manager.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/calendar.dart';

class TestCalendar extends StatefulWidget {
  TestCalendar({Key? key}) : super(key: key);

  @override
  State<TestCalendar> createState() => _TestCalendarState();
}

class _TestCalendarState extends State<TestCalendar> {
  late Map<DateTime, List<Event>> selectedEvents = {};
  late DateTime _selectedDay = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  final TextEditingController _eventController = TextEditingController();

  late CalendarFormat _calendarFormat = CalendarFormat.month;

  @override
  void initState() {
    super.initState();
    selectedEvents = {};
  }

  @override
  void dispose() {
    super.dispose();
    _eventController.dispose();
  }

  List<Event> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(15.0),
          child: Column(
            children: [
              TableCalendar(
                //basic for
                firstDay: DateTime.utc(2010, 10, 16),
                lastDay: DateTime.utc(2030, 3, 14),
                focusedDay: _focusedDay,
                selectedDayPredicate: (day) {
                  return isSameDay(_selectedDay, day);
                },
                onDaySelected: (selectedDay, focusedDay) {
                  setState(() {
                    _selectedDay = selectedDay;
                    _focusedDay = focusedDay;
                  });
                },
                calendarFormat: _calendarFormat,
                onFormatChanged: (format) {
                  setState(() {
                    _calendarFormat = format;
                  });
                },
                //events list
                eventLoader: _getEventsFromDay,
                //styling
                calendarStyle: CalendarStyle(
                  isTodayHighlighted: true,
                  selectedDecoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0)),
                  selectedTextStyle: const TextStyle(color: Colors.white),
                  todayDecoration: BoxDecoration(
                      color: Colors.purpleAccent,
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0)),
                  defaultDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0)),
                  weekendDecoration: BoxDecoration(
                      shape: BoxShape.rectangle,
                      borderRadius: BorderRadius.circular(5.0)),
                ),
                //month weeks day styling
                headerStyle: HeaderStyle(
                    formatButtonVisible: true,
                    titleCentered: true,
                    formatButtonShowsNext: false,
                    formatButtonDecoration: BoxDecoration(
                        color: Colors.blue,
                        borderRadius: BorderRadius.circular(5.0)),
                    formatButtonTextStyle:
                        const TextStyle(color: Colors.white)),
              ),
              ..._getEventsFromDay(_selectedDay)
                  .map((Event event) => Text(event.title))
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            showDialog(
                context: context,
                builder: (context) => AlertDialog(
                      title: const Text('Add Event'),
                      content: TextFormField(
                        controller: _eventController,
                      ),
                      actions: [
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text('Cancel')),
                        TextButton(
                            onPressed: () {
                              if (_eventController.text.isEmpty) {
                                Navigator.pop(context);
                                return;
                              } else {
                                if (selectedEvents[_selectedDay] != null) {
                                  selectedEvents[_selectedDay]?.add(
                                      Event(title: _eventController.text));
                                } else {
                                  selectedEvents[_selectedDay] = [
                                    Event(title: _eventController.text),
                                  ];
                                }
                              }
                              Navigator.pop(context);
                              _eventController.clear();
                              setState(() {});
                              return;
                            },
                            child: const Text('Ok'))
                      ],
                    ));
          },
          label: const Text('add event')),
    );
  }
}
