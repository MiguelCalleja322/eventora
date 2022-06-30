// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names, avoid_print

import 'dart:io';
import 'dart:math';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:country_picker/country_picker.dart';
import 'package:eventora/Widgets/custom_dashboard_button.dart';
import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:eventora/controllers/event_categories_controller.dart';
import 'package:eventora/controllers/events_controller.dart';
import 'package:eventora/utils/s3.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

class CreateEvents extends StatefulWidget {
  const CreateEvents({Key? key}) : super(key: key);

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  final ImagePicker imagePicker = ImagePicker();
  List<XFile>? imageFileList = [];
  late List<bool> isSelected = [true, false];
  late List<bool> isEventPrivate = [true, false];
  late List<bool> isEventAvailable = [true, false];
  late String eventType = '';
  late bool isPrivate = false;
  late bool isAvailable = true;
  late String schedule = '';
  late int timestamp = DateTime.now().millisecondsSinceEpoch;
  late Map<String, dynamic>? fetchedCategories = {};
  late List<dynamic>? eventCategories = [];
  late String? selectedCategory = 'Corporate';
  late bool creating = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _registrationLinkController =
      TextEditingController();

  final TextEditingController _unitNoController = TextEditingController();
  final TextEditingController _streetNoController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  // final TextEditingController _locationController = TextEditingController();

  final FocusNode _titlefocusNode = FocusNode();
  final FocusNode _descriptionfocusNode = FocusNode();
  final FocusNode _registrationLinkfocusNode = FocusNode();
  final FocusNode _feesfocusNode = FocusNode();

  late bool loading = false;
  openImages() async {
    setState(() {
      loading = true;
    });
    try {
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      setState(() {
        imageFileList!.addAll(selectedImages!);
      });
    } catch (e) {
      print('No images were picked. $e');
    }

    setState(() {
      loading = false;
    });
  }

  void getEventCategories() async {
    fetchedCategories = await EventCategoriesController().index();

    if (fetchedCategories!.isNotEmpty) {
      setState(() {
        _feesController.text = '0';
        _registrationLinkController.text = '';
        eventCategories = fetchedCategories!['event_categories'] ?? [];
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getEventCategories();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    _feesController.dispose();
    _registrationLinkController.dispose();
    _unitNoController.dispose();
    _streetNoController.dispose();
    _streetNameController.dispose();
    _countryController.dispose();
    _stateController.dispose();
    _cityController.dispose();
    _zipcodeController.dispose();
    // _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: creating == false
                ? Column(
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            'Create Event',
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 40.0),
                          ),
                          TextButton(
                              onPressed: () {
                                Navigator.pushReplacementNamed(
                                    context, '/home');
                              },
                              child: Icon(Icons.chevron_left,
                                  color: Colors.grey[700]))
                        ],
                      ),
                      const Divider(
                        height: 30.0,
                        thickness: 1,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            'Event Category:',
                            style: TextStyle(
                                color: Colors.grey[800], fontSize: 20.0),
                          ),
                          selectedCategory!.isNotEmpty
                              ? DropdownButton(
                                  value: selectedCategory,
                                  items: eventCategories!.map((eventCatedory) {
                                    return DropdownMenuItem(
                                      value: eventCatedory['type'],
                                      child: Text(eventCatedory['type']),
                                    );
                                  }).toList(),
                                  onChanged: (newValue) {
                                    setState(() {
                                      selectedCategory = newValue!.toString();
                                    });
                                  },
                                )
                              : SpinKitCircle(
                                  size: 50.0,
                                  color: Colors.grey[700],
                                ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      imageFileList!.isEmpty
                          ? DecoratedBox(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(15.0),
                                  border: Border.all(
                                      color: const Color.fromARGB(
                                          255, 132, 132, 132),
                                      width: 2.0,
                                      style: BorderStyle.solid)),
                              child: SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: Center(
                                    child: loading == true
                                        ? SpinKitCircle(
                                            size: 50.0,
                                            color: Colors.grey[700],
                                          )
                                        : Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.image,
                                                color: Colors.grey[500],
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                'Choose Image',
                                                style: TextStyle(
                                                  color: Colors.grey[500],
                                                ),
                                              ),
                                            ],
                                          )),
                              ),
                            )
                          : Stack(children: [
                              SizedBox(
                                width: double.infinity,
                                height: 200,
                                child: CarouselSlider.builder(
                                    itemCount: imageFileList!.length,
                                    itemBuilder: (context, index, realIndex) {
                                      return BuildImage(
                                          imageFileList![index], index);
                                    },
                                    options: CarouselOptions(
                                      height: 300,
                                      autoPlay: true,
                                      viewportFraction: 1,
                                      autoPlayInterval:
                                          const Duration(seconds: 2),
                                    )),
                              ),
                              // Positioned(
                              //     right: -5,
                              //     top: -15,
                              //     child: IconButton(
                              //         icon: Icon(
                              //           Icons.cancel,
                              //           color: Colors.black.withOpacity(0.5),
                              //           size: 20,
                              //         ),
                              //         onPressed: () {})),
                            ]),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomButton(
                              height: 50.0,
                              width: double.infinity,
                              backgroundColor: Colors.grey[800],
                              borderRadius: BorderRadius.circular(25.0),
                              onPressed: () {
                                openImages();
                              },
                              padding: const EdgeInsets.all(15.0),
                              alignment: Alignment.center,
                              text: 'Choose Images',
                              color: Colors.grey[100],
                              letterSpacing: 2.0,
                              fontSize: 15.0,
                              fit: BoxFit.scaleDown,
                              elevation: 18.0,
                            ),
                          ),
                          const SizedBox(
                            width: 15.0,
                          ),
                          Expanded(
                            child: CustomButton(
                              height: 50.0,
                              width: double.infinity,
                              backgroundColor: Colors.grey[800],
                              borderRadius: BorderRadius.circular(25.0),
                              onPressed: () {
                                setState(() {
                                  imageFileList!.clear();
                                  loading = false;
                                });
                              },
                              padding: const EdgeInsets.all(15.0),
                              alignment: Alignment.center,
                              text: 'Clear Selections',
                              color: Colors.grey[100],
                              letterSpacing: 2.0,
                              fontSize: 15.0,
                              fit: BoxFit.scaleDown,
                              elevation: 18.0,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Details:',
                          style: TextStyle(
                              color: Colors.grey[800], fontSize: 30.0),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      CustomTextField(
                        textAlign: TextAlign.left,
                        letterSpacing: 1.0,
                        label: 'Title',
                        controller: _titleController,
                        focusNode: _titlefocusNode,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      CustomTextField(
                        textAlign: TextAlign.left,
                        letterSpacing: 1.0,
                        label: 'Description',
                        controller: _descriptionController,
                        focusNode: _descriptionfocusNode,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      CustomButton(
                        height: 50.0,
                        width: 200.0,
                        backgroundColor: Colors.grey[800],
                        borderRadius: BorderRadius.circular(25.0),
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2022, 3, 5),
                              maxTime: DateTime(2030, 6, 7), onConfirm: (date) {
                            var inputFormat = DateFormat('yyyy/MM/dd HH:mm');
                            setState(() {
                              schedule = inputFormat.format(date);
                            });
                          },
                              currentTime: DateTime.now(),
                              locale: LocaleType.en);
                        },
                        padding: const EdgeInsets.all(15.0),
                        alignment: Alignment.center,
                        text: schedule == ''
                            ? 'Choose date for the event'
                            : schedule,
                        color: Colors.grey[100],
                        letterSpacing: 2.0,
                        fontSize: 12.0,
                        fit: BoxFit.cover,
                        elevation: 0,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child:
                              Text('Event Availability: (Default: Available)')),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ToggleButtons(
                        onPressed: (int newIndex) {
                          setState(() {
                            for (int index = 0;
                                index < isEventAvailable.length;
                                index++) {
                              if (index == newIndex) {
                                setState(() {
                                  isEventAvailable[index] = true;
                                });
                              } else {
                                setState(() {
                                  isEventAvailable[index] = false;
                                });
                              }

                              if (newIndex == 0) {
                                setState(() {
                                  isAvailable = true;
                                });
                              } else {
                                setState(() {
                                  isAvailable = false;
                                });
                              }
                            }
                          });
                        },
                        isSelected: isEventAvailable,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Available'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Not Available'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Make the event private? (Default: No)')),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ToggleButtons(
                        onPressed: (int newIndex) {
                          setState(() {
                            for (int index = 0;
                                index < isEventPrivate.length;
                                index++) {
                              if (index == newIndex) {
                                setState(() {
                                  isEventPrivate[index] = true;
                                });
                              } else {
                                setState(() {
                                  isEventPrivate[index] = false;
                                });
                              }

                              if (newIndex == 0) {
                                setState(() {
                                  isPrivate = true;
                                });
                              } else {
                                setState(() {
                                  isPrivate = false;
                                });
                              }
                            }
                          });
                        },
                        isSelected: isEventPrivate,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Yes'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('No'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      const Align(
                          alignment: Alignment.centerLeft,
                          child: Text('Paid or Free event?')),
                      const SizedBox(
                        height: 15.0,
                      ),
                      ToggleButtons(
                        onPressed: (int newIndex) {
                          setState(() {
                            for (int index = 0;
                                index < isSelected.length;
                                index++) {
                              if (index == newIndex) {
                                setState(() {
                                  isSelected[index] = true;
                                });
                              } else {
                                setState(() {
                                  isSelected[index] = false;
                                });
                              }

                              if (newIndex == 0) {
                                setState(() {
                                  eventType = 'ticketed';
                                  _registrationLinkController.text = '';
                                });
                              } else {
                                setState(() {
                                  eventType = 'registration';
                                  _feesController.text = '0';
                                });
                              }
                            }
                          });
                        },
                        isSelected: isSelected,
                        children: const <Widget>[
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Paid'),
                          ),
                          Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text('Free'),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      eventType == 'registration'
                          ? CustomTextField(
                              textAlign: TextAlign.left,
                              letterSpacing: 1.0,
                              label: 'Event Link',
                              controller: _registrationLinkController,
                              focusNode: _registrationLinkfocusNode,
                            )
                          : eventType == 'ticketed'
                              ? CustomTextField(
                                  textAlign: TextAlign.left,
                                  letterSpacing: 1.0,
                                  label: 'Fees',
                                  controller: _feesController,
                                  focusNode: _feesfocusNode,
                                )
                              : Container(),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Venue:',
                          style: TextStyle(
                              color: Colors.grey[800], fontSize: 30.0),
                        ),
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      CustomButton(
                        height: 50.0,
                        width: (MediaQuery.of(context).size.width),
                        backgroundColor: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10.0),
                        onPressed: () {
                          showCountryPicker(
                            context: context,
                            onSelect: (Country country) {
                              setState(() {
                                _countryController.text = country.name;
                              });
                            },
                            countryListTheme: CountryListThemeData(
                              borderRadius: const BorderRadius.only(
                                topLeft: Radius.circular(40.0),
                                topRight: Radius.circular(40.0),
                              ),
                              inputDecoration: InputDecoration(
                                labelText: 'Search',
                                hintText: 'Start typing to search',
                                prefixIcon: const Icon(Icons.search),
                                border: OutlineInputBorder(
                                  borderSide: BorderSide(
                                    color: const Color(0xFF8C98A8)
                                        .withOpacity(0.2),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                        padding: const EdgeInsets.all(15.0),
                        alignment: Alignment.center,
                        text: _countryController.text == ''
                            ? 'Select Country'
                            : _countryController.text,
                        color: Colors.grey[100],
                        letterSpacing: 2.0,
                        fontSize: 15.0,
                        fit: BoxFit.contain,
                        elevation: 0.0,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              onChanged: (value) => value,
                              textAlign: TextAlign.left,
                              letterSpacing: 1.0,
                              label: 'State',
                              controller: _stateController,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: CustomTextField(
                              onChanged: (value) => value,
                              textAlign: TextAlign.left,
                              letterSpacing: 1.0,
                              label: 'City',
                              controller: _cityController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        onChanged: (value) => value,
                        textAlign: TextAlign.left,
                        letterSpacing: 1.0,
                        label: 'Zip Code',
                        controller: _zipcodeController,
                      ),
                      const SizedBox(height: 15),
                      Row(
                        children: [
                          Expanded(
                            child: CustomTextField(
                              onChanged: (value) => value,
                              textAlign: TextAlign.left,
                              letterSpacing: 1.0,
                              label: 'Street No.',
                              controller: _streetNoController,
                            ),
                          ),
                          const SizedBox(
                            width: 15,
                          ),
                          Expanded(
                            child: CustomTextField(
                              onChanged: (value) => value,
                              textAlign: TextAlign.left,
                              letterSpacing: 1.0,
                              label: 'Street Name:',
                              controller: _streetNameController,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      CustomTextField(
                        onChanged: (value) => value,
                        textAlign: TextAlign.left,
                        letterSpacing: 1.0,
                        label: 'Unit No.',
                        controller: _unitNoController,
                      ),
                      const SizedBox(
                        height: 15.0,
                      ),
                      CustomButton(
                        height: 50.0,
                        width: 200.0,
                        backgroundColor: Colors.grey[800],
                        borderRadius: BorderRadius.circular(25.0),
                        onPressed: () {
                          store();
                        },
                        padding: const EdgeInsets.all(15.0),
                        alignment: Alignment.center,
                        text: 'Create Event',
                        color: Colors.grey[100],
                        letterSpacing: 2.0,
                        fontSize: 15.0,
                        fit: BoxFit.scaleDown,
                        elevation: 18.0,
                      ),
                    ],
                  )
                : Center(
                    child: Column(
                      children: [
                        SpinKitCircle(
                          size: 50.0,
                          color: Colors.grey[700],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const Text('Processing'),
                      ],
                    ),
                  ),
          ),
        ),
      ),
    );
  }

  Widget BuildImage(XFile assetImage, int index) => Container(
        color: Colors.grey[500],
        child: Image.asset(
          assetImage.path,
          fit: BoxFit.cover,
        ),
      );

  void store() async {
    List<String> fileImages = [];

    if (_titleController.text.isEmpty) {
      return _titlefocusNode.requestFocus();
    }

    if (_descriptionController.text.isEmpty) {
      return _descriptionfocusNode.requestFocus();
    }

    if (schedule.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide the date or schedule',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[500],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);

      return;
    }

    if (eventType.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide the date or schedule',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[500],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);
      return;
    }

    if (eventType == 'registration') {
      if (_registrationLinkController.text.isEmpty) {
        return _registrationLinkfocusNode.requestFocus();
      }
    }

    if (eventType == 'ticketed') {
      if (_feesController.text.isEmpty) {
        return _feesfocusNode.requestFocus();
      }
    }

    if (imageFileList!.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please pick at least one picture',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[500],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);
      return;
    }

    String fileExtension = '';
    imageFileList!.forEach((images) async {
      fileExtension = p.extension(images.path);
      String newFileName =
          randomString() + '-' + timestamp.toString() + fileExtension;
      fileImages.add('events/$newFileName');
      File image = File(images.path);
      await S3.uploadFile(newFileName, image, 'events');
    });

    setState(() {
      creating = true;
    });

    Map<String, dynamic> eventData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'is_available': isAvailable,
      'fees': _feesController.text,
      'images': fileImages,
      'is_private': isPrivate,
      'schedule': schedule,
      'event_type': eventType,
      'type': 'photo',
      'event_category': selectedCategory,
      'unit_no': _unitNoController.text,
      'street_no': _streetNoController.text,
      'street_name': _streetNameController.text,
      'country': _countryController.text,
      'state': _stateController.text,
      'city': _cityController.text,
      'zipcode': _zipcodeController.text,
      // 'location': _locationController.text,
      'registration_link': _registrationLinkController.text
    };

    print(eventData);

    var test = await EventController().store(eventData);

    if (test['message'] != '') {
      Fluttertoast.showToast(
          msg: test['message'] ?? 'Done',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[500],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);
      setState(() {
        creating = false;
      });
      return;
    }

    print(test);
    setState(() {
      creating = false;
    });

    // _titleController.clear();
    // _descriptionController.clear();
    // _feesController.clear();
    // _registrationLinkController.clear();
    // _unitNoController.clear();
    // _streetNoController.clear();
    // _streetNameController.clear();
    // _countryController.clear();
    // _stateController.clear();
    // _cityController.clear();
    // _zipcodeController.clear();
  }

  static randomString() {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        32, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
