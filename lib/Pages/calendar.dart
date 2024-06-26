import 'dart:collection';
import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/controllers/appointment_controller.dart';
import 'package:eventora/controllers/note_controller.dart';
import 'package:eventora/controllers/task_controller.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:settings_ui/settings_ui.dart';
import 'package:table_calendar/table_calendar.dart';
import '../controllers/calendar_controller.dart';
import '../models/calendar.dart';

class CalendarPage extends StatefulWidget {
  const CalendarPage({Key? key}) : super(key: key);

  @override
  State<CalendarPage> createState() => _CalendarPageState();
}

class _CalendarPageState extends State<CalendarPage> {
  late Map<DateTime, List<Calendar>> selectedEvents = {};
  late Map<String, dynamic>? calendarData = {};
  late List<dynamic>? listOfAppointments = [];
  late List<dynamic>? listOfTasks = [];
  late DateTime _selectedDay = DateTime.now();
  late DateTime _focusedDay = DateTime.now();
  late String? model = '';
  late bool loading = false;
  late bool saving = false;
  late CalendarFormat _calendarFormat = CalendarFormat.month;
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();

  void generateCalendarData() async {
    setState(() {
      loading = true;
    });

    getCalendarData();

    _selectedDay = _focusedDay;
  }

  @override
  void initState() {
    if (mounted) {
      generateCalendarData();
    }
    super.initState();
  }

  @override
  void dispose() {
    selectedEvents.clear();
    _titleController.dispose();
    _descriptionController.dispose();
    _dateController.dispose();
    super.dispose();
  }

  List<Calendar> _getEventsFromDay(DateTime date) {
    return selectedEvents[date] ?? [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Calendar',
        hideBackButton: true,
      ),
      body: SafeArea(
        child: loading == true
            ? SpinKitCircle(
                size: 50.0,
                color: Colors.grey[700],
              )
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: RefreshIndicator(
                    onRefresh: () {
                      selectedEvents = {};
                      return getCalendarData();
                    },
                    child: Column(
                      children: [
                        TableCalendar(
                          calendarFormat: _calendarFormat,
                          onFormatChanged: (format) {
                            setState(() {
                              _calendarFormat = format;
                            });
                          },
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
                          eventLoader: _getEventsFromDay,
                          calendarStyle: CalendarStyle(
                              isTodayHighlighted: true,
                              selectedDecoration: BoxDecoration(
                                  color: Colors.blue,
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5.0)),
                              selectedTextStyle:
                                  const TextStyle(color: Colors.white),
                              todayDecoration: BoxDecoration(
                                  color: Colors.grey[850],
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5.0)),
                              defaultDecoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5.0)),
                              weekendDecoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5.0)),
                              outsideDecoration: BoxDecoration(
                                  shape: BoxShape.rectangle,
                                  borderRadius: BorderRadius.circular(5.0))),
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
                        const SizedBox(height: 15.0),
                        saving == true
                            ? AlertDialog(
                                content: SpinKitCircle(
                                size: 50.0,
                                color: Colors.grey[700],
                              ))
                            : const SizedBox(height: 15.0),
                        ..._getEventsFromDay(_selectedDay).map(
                          (Calendar event) => Container(
                              margin: const EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 1,
                                    blurRadius: 1,
                                    offset: const Offset(
                                        0, 3), // changes position of shadow
                                  ),
                                ],
                              ),
                              child: OutlinedButton(
                                style: OutlinedButton.styleFrom(
                                    shape: const RoundedRectangleBorder(
                                        borderRadius: BorderRadius.zero)),
                                onPressed: () {
                                  if (event.model == 'Task') {
                                    Navigator.pushNamed(context, '/view_task',
                                        arguments: {
                                          'title': event.title,
                                          'description': event.description,
                                          'dateTime': event.dateTime,
                                        });
                                  } else {
                                    Navigator.pushNamed(
                                        context, '/view_appointment',
                                        arguments: {
                                          'title': event.title,
                                          'description': event.description,
                                          'dateTime': event.dateTime,
                                        });
                                  }
                                },
                                onLongPress: () {
                                  showMaterialModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return StatefulBuilder(builder:
                                            (BuildContext context,
                                                StateSetter mystate) {
                                          return SingleChildScrollView(
                                            controller:
                                                ModalScrollController.of(
                                                    context),
                                            child: SizedBox(
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(15.0),
                                                child: SettingsList(
                                                  shrinkWrap: true,
                                                  lightTheme:
                                                      const SettingsThemeData(
                                                    settingsSectionBackground:
                                                        Colors.white,
                                                    settingsListBackground:
                                                        Colors.white,
                                                  ),
                                                  sections: [
                                                    SettingsSection(
                                                      tiles: <SettingsTile>[
                                                        SettingsTile.navigation(
                                                          onPressed: (context) {
                                                            delete(event.id,
                                                                event.model);
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          leading: const Icon(
                                                              Ionicons
                                                                  .trash_bin_outline),
                                                          title: const Text(
                                                              'Delete'),
                                                        ),
                                                        SettingsTile.navigation(
                                                          onPressed: (context) {
                                                            Navigator.pushNamed(
                                                                context,
                                                                '/update_calendar',
                                                                arguments: {
                                                                  'model': event
                                                                      .model,
                                                                  'id':
                                                                      event.id,
                                                                  'title': event
                                                                      .title,
                                                                  'description':
                                                                      event
                                                                          .description,
                                                                  'schedule': event
                                                                      .dateTime,
                                                                });
                                                          },
                                                          leading: const Icon(
                                                              Ionicons.refresh),
                                                          title: const Text(
                                                              'Update'),
                                                        ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                          );
                                        });
                                      });
                                },
                                child: SizedBox(
                                  child: Padding(
                                    padding: const EdgeInsets.all(15.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            '${event.model}: ${event.title}',
                                            style: TextStyle(
                                                color: Colors.grey[800],
                                                fontSize: 15.0,
                                                fontWeight: FontWeight.bold),
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            event.description,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 14.0,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 5.0),
                                        Align(
                                          alignment: Alignment.centerLeft,
                                          child: Text(
                                            event.dateTime,
                                            style: TextStyle(
                                              color: Colors.grey[800],
                                              fontSize: 12.0,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              )),
                        )
                      ],
                    ),
                  ),
                ),
              ),
      ),
    );
  }

  Future<void> getCalendarData() async {
    calendarData = await CalendarController.index() ?? {};
    listOfAppointments = calendarData!['appointments'] ?? [];
    listOfTasks = calendarData!['tasks'] ?? [];
    DateFormat actualDateAndTimeOfATFormat = DateFormat('yyyy-MM-dd HH:mm');
    DateFormat actualDateFormat = DateFormat('yyyy-MM-dd');
    String? actualDateString = '';
    DateTime actualDate;

    int getHashCode(DateTime key) {
      return key.day * 1000000 + key.month * 10000 + key.year;
    }

    setState(() {
      listOfAppointments!.map((appointments) {
        DateTime date = DateTime.parse(appointments['date_time']);
        actualDateString = actualDateFormat.format(date);
        actualDate = DateTime.parse(actualDateString!);

        if (selectedEvents[actualDate] != null) {
          selectedEvents[actualDate]?.add(Calendar(
              appointments['id'],
              'Appointment',
              appointments['title'],
              appointments['description'],
              actualDateAndTimeOfATFormat.format(date).toString()));
        } else {
          selectedEvents[actualDate] = [
            Calendar(
                appointments['id'],
                'Appointment',
                appointments['title'],
                appointments['description'],
                actualDateAndTimeOfATFormat.format(date).toString()),
          ];
        }
      }).toList();

      listOfTasks!.map((task) {
        DateTime date = DateTime.parse(task['date_time']);
        actualDateString = actualDateFormat.format(date);
        actualDate = DateTime.parse(actualDateString!);

        if (selectedEvents[actualDate] != null) {
          selectedEvents[actualDate]?.add(Calendar(
              task['id'],
              'Task',
              task['title'],
              task['description'],
              actualDateAndTimeOfATFormat.format(date).toString()));
        } else {
          selectedEvents[actualDate] = [
            Calendar(task['id'], 'Task', task['title'], task['description'],
                actualDateAndTimeOfATFormat.format(date).toString()),
          ];
        }
      }).toList();

      setState(() {
        loading = false;
      });
    });

    selectedEvents = LinkedHashMap<DateTime, List<Calendar>>(
      equals: isSameDay,
      hashCode: getHashCode,
    )..addAll(selectedEvents);
  }

  void store(context, model) async {
    Map<String, dynamic> modelData = {};
    Map<String, dynamic>? response = {};

    DateFormat actualDateAndTimeOfAT = DateFormat('yyyy/MM/dd HH:mm');

    if (_titleController.text.isEmpty) {
      CustomFlutterToast.showErrorToast('Title is required.');

      return;
    }

    if (_descriptionController.text.isEmpty) {
      CustomFlutterToast.showErrorToast('Description is required.');

      return;
    }

    if (model == 'Task' || model == 'Appointment') {
      if (_dateController.text.isEmpty) {
        CustomFlutterToast.showErrorToast('Date is required.');

        return;
      }

      DateTime date = DateTime.parse(_dateController.text);
      modelData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
        'date_time': _dateController.text
      };

      if (model == 'Task') {
        response = await TaskController.store(modelData);

        if (selectedEvents[date] != null) {
          selectedEvents[date]?.add(Calendar(
              response!['task']['id'],
              model,
              _titleController.text,
              _descriptionController.text,
              actualDateAndTimeOfAT.format(date)));
        } else {
          selectedEvents[date] = [
            Calendar(
                response!['task']['id'],
                model,
                _titleController.text,
                _descriptionController.text,
                actualDateAndTimeOfAT.format(date).toString()),
          ];
        }
      } else {
        response = await AppointmentController.store(modelData);

        if (selectedEvents[date] != null) {
          selectedEvents[date]?.add(Calendar(
              response!['appointment']['id'],
              model,
              _titleController.text,
              _descriptionController.text,
              actualDateAndTimeOfAT.format(date).toString()));
        } else {
          selectedEvents[date] = [
            Calendar(
                response!['appointment']['id'],
                model,
                _titleController.text,
                _descriptionController.text,
                actualDateAndTimeOfAT.format(date).toString()),
          ];
        }
      }
    } else {
      modelData = {
        'title': _titleController.text,
        'description': _descriptionController.text,
      };
      response = await NoteController().store(modelData);
    }
    Navigator.pop(context);
    setState(() {
      _titleController.text = '';
      _descriptionController.text = '';
      _dateController.text = '';
    });
  }

  void delete(int id, model) async {
    if (model == 'Task') {
      await TaskController.delete(id);
    } else {
      await AppointmentController.delete(id);
    }

    setState(() {
      calendarData = {};
      listOfAppointments = [];
      listOfTasks = [];
      selectedEvents = {};
    });

    await getCalendarData();
  }
}
