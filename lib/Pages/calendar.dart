// // Copyright 2019 Aleksander Woźniak
// // SPDX-License-Identifier: Apache-2.0

// import 'package:eventora/controllers/appointment_controller.dart';
// import 'package:eventora/controllers/note_controller.dart';
// import 'package:eventora/controllers/task_controller.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:intl/intl.dart';
// import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
// import 'package:table_calendar/table_calendar.dart';

// import '../Widgets/custom_dashboard_button.dart';
// import '../Widgets/custom_textformfield.dart';
// import '../utils/calendar.dart';

// class CalendarPage extends StatefulWidget {
//   CalendarPage({Key? key}) : super(key: key);

//   @override
//   State<CalendarPage> createState() => _CalendarPageState();
// }

// class _CalendarPageState extends State<CalendarPage> {
//   @override
//   late final ValueNotifier<List<Event>> _selectedEvents;
//   CalendarFormat _calendarFormat = CalendarFormat.month;
//   RangeSelectionMode _rangeSelectionMode = RangeSelectionMode
//       .toggledOff; // Can be toggled on/off by longpressing a date
//   DateTime _focusedDay = DateTime.now();
//   DateTime? _selectedDay;
//   DateTime? _rangeStart;
//   DateTime? _rangeEnd;
//   final TextEditingController _titleController = TextEditingController();
//   final TextEditingController _descriptionController = TextEditingController();
//   final TextEditingController _dateController = TextEditingController();
//   @override
//   void initState() {
//     super.initState();

//     _selectedDay = _focusedDay;
//     _selectedEvents = ValueNotifier(_getEventsForDay(_selectedDay!));
//   }

//   @override
//   void dispose() {
//     _selectedEvents.dispose();
//     super.dispose();
//   }

//   List<Event> _getEventsForDay(DateTime day) {
//     // Implementation example

//     return kEvents[day] ?? [];
//   }

//   //selecting the day in calendar
//   void _onDaySelected(DateTime selectedDay, DateTime focusedDay) {
//     if (!isSameDay(_selectedDay, selectedDay)) {
//       setState(() {
//         _selectedDay = selectedDay;
//         _focusedDay = focusedDay;
//         _rangeStart = null; // Important to clean those
//         _rangeEnd = null;
//         _rangeSelectionMode = RangeSelectionMode.toggledOff;
//       });

//       _selectedEvents.value = _getEventsForDay(selectedDay);

//       print(_selectedDay);
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Padding(
//           padding: const EdgeInsets.fromLTRB(30.0, 40.0, 30.0, 0.0),
//           child: Column(
//             children: [
//               Text('Calendar',
//                   style: TextStyle(color: Colors.grey[800], fontSize: 40.0)),
//               const SizedBox(height: 10.0),
//               TableCalendar<Event>(
//                 firstDay: kFirstDay,
//                 lastDay: kLastDay,
//                 focusedDay: _focusedDay,
//                 selectedDayPredicate: (day) => isSameDay(_selectedDay, day),
//                 rangeStartDay: _rangeStart,
//                 rangeEndDay: _rangeEnd,
//                 calendarFormat: _calendarFormat,
//                 rangeSelectionMode: _rangeSelectionMode,
//                 eventLoader: _getEventsForDay,
//                 startingDayOfWeek: StartingDayOfWeek.monday,
//                 calendarStyle: const CalendarStyle(
//                   // Use `CalendarStyle` to customize the UI
//                   outsideDaysVisible: false,
//                 ),
//                 onDaySelected: _onDaySelected,
//                 onFormatChanged: (format) {
//                   if (_calendarFormat != format) {
//                     setState(() {
//                       _calendarFormat = format;
//                     });
//                   }
//                 },
//                 onPageChanged: (focusedDay) {
//                   _focusedDay = focusedDay;
//                 },
//               ),
//               const SizedBox(height: 15.0),
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                 children: <Widget>[
//                   TextButton(
//                       onPressed: () {
//                         showMaterialModalBottomSheet(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return StatefulBuilder(builder:
//                                   (BuildContext context, StateSetter mystate) {
//                                 return SingleChildScrollView(
//                                   controller: ModalScrollController.of(context),
//                                   child: SizedBox(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(15.0),
//                                       child: Column(
//                                         children: <Widget>[
//                                           Align(
//                                             alignment: Alignment.centerLeft,
//                                             child: Text('Tasks',
//                                                 style: TextStyle(
//                                                     color: Colors.grey[800],
//                                                     fontSize: 40.0)),
//                                           ),
//                                           SizedBox(
//                                             height: 40,
//                                             child: Divider(
//                                               color: Colors.grey[600],
//                                             ),
//                                           ),
//                                           CustomTextFormField(
//                                             label: 'Task Title:',
//                                             controller: _titleController,
//                                           ),
//                                           const SizedBox(height: 15),
//                                           CustomTextFormField(
//                                             label: 'Task Description:',
//                                             controller: _descriptionController,
//                                           ),
//                                           const SizedBox(height: 15),
//                                           TextButton(
//                                               onPressed: () {
//                                                 DatePicker.showDateTimePicker(
//                                                   context,
//                                                   showTitleActions: true,
//                                                   minTime: DateTime(1950, 1, 1),
//                                                   maxTime:
//                                                       DateTime(2030, 12, 31),
//                                                   onConfirm: (date) {
//                                                     var inputFormat =
//                                                         DateFormat(
//                                                             'yyyy-MM-dd HH:mm');
//                                                     mystate(() {
//                                                       _dateController.text =
//                                                           inputFormat
//                                                               .format(date);
//                                                     });
//                                                   },
//                                                 );
//                                               },
//                                               child: Text(
//                                                   _dateController.text == ''
//                                                       ? 'Choose Date:'
//                                                       : _dateController.text)),
//                                           const SizedBox(height: 15),
//                                           OutlinedButton(
//                                               onPressed: () {
//                                                 store('tasks');
//                                               },
//                                               child: const Text('Save'))
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               });
//                             });
//                       },
//                       child: Column(
//                         children: const [
//                           Icon(Icons.task_alt_outlined),
//                           Text('Tasks'),
//                         ],
//                       )),
//                   TextButton(
//                       onPressed: () {
//                         showMaterialModalBottomSheet(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return StatefulBuilder(builder:
//                                   (BuildContext context, StateSetter mystate) {
//                                 return SingleChildScrollView(
//                                   controller: ModalScrollController.of(context),
//                                   child: SizedBox(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(15.0),
//                                       child: Column(
//                                         children: <Widget>[
//                                           Align(
//                                             alignment: Alignment.centerLeft,
//                                             child: Text('Appointments',
//                                                 style: TextStyle(
//                                                     color: Colors.grey[800],
//                                                     fontSize: 40.0)),
//                                           ),
//                                           SizedBox(
//                                             height: 40,
//                                             child: Divider(
//                                               color: Colors.grey[600],
//                                             ),
//                                           ),
//                                           CustomTextFormField(
//                                             label: 'Task Title:',
//                                             controller: _titleController,
//                                           ),
//                                           const SizedBox(height: 15),
//                                           CustomTextFormField(
//                                             label: 'Task Description:',
//                                             controller: _descriptionController,
//                                           ),
//                                           const SizedBox(height: 15),
//                                           TextButton(
//                                               onPressed: () {
//                                                 DatePicker.showDateTimePicker(
//                                                   context,
//                                                   showTitleActions: true,
//                                                   minTime: DateTime(1950, 1, 1),
//                                                   maxTime:
//                                                       DateTime(2030, 12, 31),
//                                                   onConfirm: (date) {
//                                                     var inputFormat =
//                                                         DateFormat(
//                                                             'yyyy-MM-dd HH:mm');
//                                                     mystate(() {
//                                                       _dateController.text =
//                                                           inputFormat
//                                                               .format(date);
//                                                     });
//                                                   },
//                                                 );
//                                               },
//                                               child: Text(
//                                                   _dateController.text == ''
//                                                       ? 'Choose Date:'
//                                                       : _dateController.text)),
//                                           const SizedBox(height: 15),
//                                           OutlinedButton(
//                                               onPressed: () {
//                                                 store('appointments');
//                                               },
//                                               child: const Text('Save'))
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               });
//                             });
//                       },
//                       child: Column(
//                         children: const [
//                           Icon(Icons.calendar_month_outlined),
//                           Text('Appointments')
//                         ],
//                       )),
//                   TextButton(
//                       onPressed: () {
//                         showMaterialModalBottomSheet(
//                             context: context,
//                             builder: (BuildContext context) {
//                               return StatefulBuilder(builder:
//                                   (BuildContext context, StateSetter mystate) {
//                                 return SingleChildScrollView(
//                                   controller: ModalScrollController.of(context),
//                                   child: SizedBox(
//                                     child: Padding(
//                                       padding: const EdgeInsets.all(15.0),
//                                       child: Column(
//                                         children: <Widget>[
//                                           Align(
//                                             alignment: Alignment.centerLeft,
//                                             child: Text('Notes',
//                                                 style: TextStyle(
//                                                     color: Colors.grey[800],
//                                                     fontSize: 40.0)),
//                                           ),
//                                           SizedBox(
//                                             height: 40,
//                                             child: Divider(
//                                               color: Colors.grey[600],
//                                             ),
//                                           ),
//                                           CustomTextFormField(
//                                             label: 'Task Title:',
//                                             controller: _titleController,
//                                           ),
//                                           const SizedBox(height: 15),
//                                           CustomTextFormField(
//                                             label: 'Task Description:',
//                                             controller: _descriptionController,
//                                           ),
//                                           const SizedBox(height: 15),
//                                           OutlinedButton(
//                                               onPressed: () {
//                                                 store('notes');
//                                               },
//                                               child: const Text('Save'))
//                                         ],
//                                       ),
//                                     ),
//                                   ),
//                                 );
//                               });
//                             });
//                       },
//                       child: Column(
//                         children: const [
//                           Icon(Icons.note_add_outlined),
//                           Text('Notes')
//                         ],
//                       )),
//                 ],
//               ),
//               const SizedBox(height: 15.0),
//               Expanded(
//                 child: ValueListenableBuilder<List<Event>>(
//                   valueListenable: _selectedEvents,
//                   builder: (context, value, _) {
//                     return ListView.builder(
//                       itemCount: value.length,
//                       itemBuilder: (context, index) {
//                         return Container(
//                           margin: const EdgeInsets.symmetric(
//                             horizontal: 12.0,
//                             vertical: 4.0,
//                           ),
//                           decoration: BoxDecoration(
//                             border: Border.all(),
//                             borderRadius: BorderRadius.circular(12.0),
//                           ),
//                           child: ListTile(
//                             onTap: () => print('${value[index]}'),
//                             title: Text('${value[index]}'),
//                           ),
//                         );
//                       },
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   void store(String? model) async {
//     Map<String, dynamic> modelData = {};
//     Map<String, dynamic>? response = {};
//     if (_titleController.text == '') {
//       Fluttertoast.showToast(
//           msg: 'Title is required.',
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.grey[500],
//           textColor: Colors.white,
//           timeInSecForIosWeb: 3,
//           toastLength: Toast.LENGTH_LONG,
//           fontSize: 16.0);
//       return;
//     }

//     if (_descriptionController.text == '') {
//       Fluttertoast.showToast(
//           msg: 'Description is required.',
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red[500],
//           textColor: Colors.white,
//           timeInSecForIosWeb: 3,
//           toastLength: Toast.LENGTH_LONG,
//           fontSize: 16.0);
//       return;
//     }

//     if (model == 'tasks' || model == 'appointments') {
//       if (_dateController.text == '') {
//         Fluttertoast.showToast(
//             msg: 'Date is required.',
//             gravity: ToastGravity.BOTTOM,
//             backgroundColor: Colors.red[500],
//             textColor: Colors.white,
//             timeInSecForIosWeb: 3,
//             toastLength: Toast.LENGTH_LONG,
//             fontSize: 16.0);
//         return;
//       }

//       modelData = {
//         'title': _titleController.text,
//         'description': _descriptionController.text,
//         'date_time': _dateController.text
//       };

//       if (model == 'tasks') {
//         response = await TaskController().store(modelData);
//       } else {
//         response = await AppointmentController().store(modelData);
//       }
//     } else {
//       modelData = {
//         'title': _titleController.text,
//         'description': _descriptionController.text,
//       };
//       response = await NoteController().store(modelData);
//     }

//     setState(() {
//       _titleController.text = '';
//       _descriptionController.text = '';
//       _dateController.text = '';
//     });

//     if (response!.isNotEmpty) {
//       Fluttertoast.showToast(
//           msg: response['message'],
//           gravity: ToastGravity.BOTTOM,
//           backgroundColor: Colors.red[500],
//           textColor: Colors.white,
//           timeInSecForIosWeb: 3,
//           toastLength: Toast.LENGTH_LONG,
//           fontSize: 16.0);
//       return;
//     }
//   }
// }
