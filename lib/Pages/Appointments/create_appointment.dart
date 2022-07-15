import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:eventora/controllers/appointment_controller.dart';
import 'package:eventora/controllers/task_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';

class CreateAppointment extends StatefulWidget {
  CreateAppointment({Key? key}) : super(key: key);

  @override
  State<CreateAppointment> createState() => _CreateAppointmentState();
}

class _CreateAppointmentState extends State<CreateAppointment> {
  final TextEditingController appointmentTitle = TextEditingController();
  final TextEditingController appointmentDescription = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  late FocusNode titleNode = FocusNode();
  late FocusNode descrioptionNode = FocusNode();

  void saveNote(context) async {
    if (appointmentTitle.text.isEmpty) {
      titleNode.requestFocus();
      return;
    }

    if (appointmentDescription.text.isEmpty) {
      descrioptionNode.requestFocus();
      return;
    }

    if (_dateController.text.isEmpty) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: 'Date is required',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[500],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);

      return;
    }

    Map<String, dynamic> appointment = {
      'title': appointmentTitle.text,
      'description': appointmentDescription.text,
      'date_time': _dateController.text,
    };

    Map<String, dynamic>? response =
        await AppointmentController().store(appointment);

    Fluttertoast.cancel();
    Fluttertoast.showToast(
        msg: response!['appointment'].toString(),
        gravity: ToastGravity.BOTTOM,
        backgroundColor: Colors.grey[800],
        textColor: Colors.white,
        timeInSecForIosWeb: 3,
        toastLength: Toast.LENGTH_LONG,
        fontSize: 16.0);

    appointmentTitle.clear();
    appointmentDescription.clear();
    Navigator.pushNamed(context, '/home');
    return;
  }

  @override
  void dispose() {
    appointmentTitle.dispose();
    appointmentDescription.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          saveNote(context);
        },
        backgroundColor: Colors.grey[850],
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      appBar: CustomAppBar(
        title: 'Create Appointment',
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                CustomTextField(
                  textAlign: TextAlign.left,
                  letterSpacing: 1.0,
                  label: 'Title',
                  controller: appointmentTitle,
                  focusNode: titleNode,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  maxLine: 9,
                  textAlign: TextAlign.left,
                  letterSpacing: 1.0,
                  label: 'Description',
                  controller: appointmentDescription,
                  focusNode: descrioptionNode,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextButton(
                    onPressed: () {
                      DatePicker.showDateTimePicker(
                        context,
                        showTitleActions: true,
                        minTime: DateTime(1950, 1, 1),
                        maxTime: DateTime(2030, 12, 31),
                        onConfirm: (date) {
                          var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                          setState(() {
                            _dateController.text = inputFormat.format(date);
                          });
                        },
                      );
                    },
                    child: Text(_dateController.text == ''
                        ? 'Choose Date:'
                        : _dateController.text)),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
