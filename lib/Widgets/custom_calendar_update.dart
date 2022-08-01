import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_button.dart';
import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:eventora/controllers/appointment_controller.dart';
import 'package:eventora/controllers/task_controller.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';

class CustomCalendarUpdatePage extends StatefulWidget {
  const CustomCalendarUpdatePage(
      {Key? key,
      required this.title,
      required this.description,
      required this.dateTime,
      required this.id,
      required this.model})
      : super(key: key);

  final String title;
  final String description;
  final String dateTime;
  final String model;
  final int id;
  @override
  State<CustomCalendarUpdatePage> createState() =>
      _CustomCalendarUpdatePageState();
}

class _CustomCalendarUpdatePageState extends State<CustomCalendarUpdatePage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _dateTimeController = TextEditingController();

  final FocusNode _titleFocusNode = FocusNode();
  final FocusNode _descriptionFocusNode = FocusNode();

  @override
  void initState() {
    _titleController.text = widget.title;
    _descriptionController.text = widget.description;
    _dateTimeController.text = widget.dateTime;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Update ${widget.model}',
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          update(widget.model, context);
        },
        backgroundColor: Colors.grey[850],
        child: const Icon(
          Icons.save,
          color: Colors.white,
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              children: <Widget>[
                CustomTextField(
                  label: 'Title',
                  textAlign: TextAlign.left,
                  maxLine: 1,
                  controller: _titleController,
                  focusNode: _titleFocusNode,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomTextField(
                  label: 'Description',
                  textAlign: TextAlign.left,
                  maxLine: 10,
                  controller: _descriptionController,
                  focusNode: _descriptionFocusNode,
                ),
                const SizedBox(
                  height: 10,
                ),
                CustomButton(
                  title: 'Schedule:',
                  backgroundColor: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10.0),
                  onPressed: () {
                    DatePicker.showDateTimePicker(
                      context,
                      showTitleActions: true,
                      minTime: DateTime(1950, 1, 1),
                      maxTime: DateTime(2030, 12, 31),
                      onConfirm: (date) {
                        var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                        setState(() {
                          _dateTimeController.text = inputFormat.format(date);
                        });
                      },
                    );
                  },
                  padding: const EdgeInsets.all(0.0),
                  alignment: Alignment.center,
                  text: _dateTimeController.text == ''
                      ? 'Select Date'
                      : _dateTimeController.text,
                  elevation: 0,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void update(String model, context) async {
    Map<String, dynamic> response = {};

    if (_titleController.text.isEmpty) {
      CustomFlutterToast.showErrorToast('Title is required.');
      return;
    }

    if (_descriptionController.text.isEmpty) {
      CustomFlutterToast.showErrorToast('description is required.');
      return;
    }

    if (_dateTimeController.text.isEmpty) {
      CustomFlutterToast.showErrorToast('Date and time is required.');
      return;
    }

    Map<String, dynamic> data = {
      'id': widget.id,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'date_time': _dateTimeController.text,
    };

    if (model == 'Task') {
      response = await TaskController.update(data);

      if (response['message'] != null) {
        CustomFlutterToast.showErrorToast(response['message']);
        return;
      } else {
        CustomFlutterToast.showOkayToast(response['task']);
        Navigator.pop(context);
        return;
      }
    } else {
      response = await AppointmentController.update(data);

      if (response['message'] != null) {
        CustomFlutterToast.showErrorToast(response['message']);
        return;
      }

      CustomFlutterToast.showOkayToast(response['appointment']);
      Navigator.pop(context);
      return;
    }
  }
}
