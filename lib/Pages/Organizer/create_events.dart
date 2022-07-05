// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names, avoid_print

import 'dart:async';
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
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
// ignore: depend_on_referenced_packages
import 'package:path/path.dart' as p;

import '../../controllers/location_controller.dart';

class CreateEvents extends StatefulWidget {
  const CreateEvents({Key? key}) : super(key: key);

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  final ImagePicker imagePicker = ImagePicker();
  List<File>? imageFileList = [];
  late List<bool> isSelected = [true, false];
  late List<bool> isEventPrivate = [true, false];
  late List<bool> isEventAvailable = [true, false];
  late String eventType = '';
  late bool isPrivate = false;
  late bool isAvailable = true;
  late String scheduleStart = '';
  late String scheduleEnd = '';
  late int timestamp = DateTime.now().millisecondsSinceEpoch;
  late Map<String, dynamic>? fetchedCategories = {};
  late List<dynamic>? eventCategories = [];
  late String? selectedCategory = 'Corporate';
  late String? overallColor = '';
  late bool isVenue = false;

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _registrationLinkController =
      TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();

  final FocusNode _titlefocusNode = FocusNode();
  final FocusNode _descriptionfocusNode = FocusNode();
  final FocusNode _registrationLinkfocusNode = FocusNode();
  final FocusNode _feesfocusNode = FocusNode();

  // final TextEditingController _locationController = TextEditingController();
  late GoogleMapController googleMapController;

  final TextEditingController _searchController = TextEditingController();
  late double? latitude = 0.0;
  late double? longitude = 0.0;
  late Map<String, dynamic>? locationDetails = {};
  late Set<Marker> _markers = <Marker>{};
  late GooglePlace googlePlace;
  late List<AutocompletePrediction>? predictions = [];
  late Timer? _debounce = Timer(const Duration(milliseconds: 1000), () {});

  late bool loading = false;
  openImages() async {
    setState(() {
      loading = true;
    });
    try {
      final List<XFile>? selectedImages = await imagePicker.pickMultiImage();
      setState(() {
        selectedImages!.forEach((element) {
          imageFileList!.add(File(element.path));
        });
      });
    } catch (e) {
      print('No images were picked. $e');
    }

    setState(() {
      loading = false;
    });
  }

  static const CameraPosition _kGooglePlex = CameraPosition(
    target: LatLng(37.43296265331129, -122.08832357078792),
    zoom: 14.4746,
  );

  void googlePlaceInit() async {
    await dotenv.load(fileName: ".env");
    final String? key = dotenv.env['GOOGLE_API'];
    googlePlace = GooglePlace(key!);
  }

  void autoCompleteSearch(String value) async {
    var results = await googlePlace.autocomplete.get(value);
    if (results != null && results.predictions != null && mounted) {
      setState(() {
        predictions = results.predictions!;
      });
    }
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
    googlePlaceInit();
    super.initState();
    getEventCategories();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    predictions!.clear();
    _fullAddressController.dispose();
    _searchController.dispose();
    _debounce!.cancel();
    _titleController.dispose();
    _descriptionController.dispose();
    _feesController.dispose();
    _registrationLinkController.dispose();

    // _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isVenue == false
          ? SafeArea(
              child: SingleChildScrollView(
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
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
                                    items:
                                        eventCategories!.map((eventCatedory) {
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
                        Row(
                          children: [
                            Expanded(
                              child: CustomButton(
                                height: 50.0,
                                width: 200.0,
                                backgroundColor: Colors.grey[800],
                                borderRadius: BorderRadius.circular(25.0),
                                onPressed: () {
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2022, 3, 5),
                                      maxTime: DateTime(2030, 6, 7),
                                      onConfirm: (date) {
                                    var inputFormat =
                                        DateFormat('yyyy/MM/dd HH:mm');
                                    setState(() {
                                      scheduleStart = inputFormat.format(date);
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                padding: const EdgeInsets.all(15.0),
                                alignment: Alignment.center,
                                text: scheduleStart == ''
                                    ? 'Start Date'
                                    : scheduleStart,
                                color: Colors.grey[100],
                                letterSpacing: 2.0,
                                fontSize: 12.0,
                                fit: BoxFit.none,
                                elevation: 0,
                              ),
                            ),
                            Expanded(
                              child: CustomButton(
                                height: 50.0,
                                width: 200.0,
                                backgroundColor: Colors.grey[800],
                                borderRadius: BorderRadius.circular(25.0),
                                onPressed: () {
                                  DatePicker.showDateTimePicker(context,
                                      showTitleActions: true,
                                      minTime: DateTime(2022, 3, 5),
                                      maxTime: DateTime(2030, 6, 7),
                                      onConfirm: (date) {
                                    var inputFormat =
                                        DateFormat('yyyy/MM/dd HH:mm');
                                    setState(() {
                                      scheduleEnd = inputFormat.format(date);
                                    });
                                  },
                                      currentTime: DateTime.now(),
                                      locale: LocaleType.en);
                                },
                                padding: const EdgeInsets.all(15.0),
                                alignment: Alignment.center,
                                text: scheduleEnd == ''
                                    ? 'End Date'
                                    : scheduleEnd,
                                color: Colors.grey[100],
                                letterSpacing: 2.0,
                                fontSize: 12.0,
                                fit: BoxFit.none,
                                elevation: 0,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(
                          height: 15.0,
                        ),
                        const Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                                'Event Availability: (Default: Available)')),
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
                            child:
                                Text('Make the event private? (Default: No)')),
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
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            height: 50.0,
                            width: 100.0,
                            backgroundColor: Colors.grey[800],
                            borderRadius: BorderRadius.circular(25.0),
                            onPressed: () {
                              setState(() {
                                isVenue = true;
                              });
                            },
                            padding: const EdgeInsets.all(0.0),
                            alignment: Alignment.center,
                            text: 'Next',
                            color: Colors.grey[100],
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fit: BoxFit.scaleDown,
                            elevation: 18.0,
                          ),
                        ),
                      ],
                    )),
              ),
            )
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(15.0),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 15.0,
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Venue',
                        style:
                            TextStyle(color: Colors.grey[800], fontSize: 30.0),
                      ),
                    ),
                    Row(children: <Widget>[
                      Expanded(
                          child: TextField(
                        onChanged: (value) {
                          if (value.isNotEmpty) {
                            if (_debounce?.isActive ?? false) {
                              _debounce!.cancel();
                            }
                            _debounce =
                                Timer(const Duration(milliseconds: 2000), () {
                              autoCompleteSearch(value);
                            });
                          } else {
                            setState(() {
                              _searchController.text = '';
                              predictions!.clear();
                            });
                          }
                        },
                        controller: _searchController,
                        textCapitalization: TextCapitalization.words,
                        decoration: const InputDecoration(hintText: 'Search'),
                      )),
                      IconButton(
                          onPressed: () {
                            _searchController.text = '';
                            predictions!.clear();
                          },
                          icon: const Icon(FeatherIcons.x))
                    ]),
                    const SizedBox(
                      height: 15.0,
                    ),
                    ListView.builder(
                        shrinkWrap: true,
                        itemCount: predictions!.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: ListTile(
                                leading: const Icon(FeatherIcons.mapPin),
                                onTap: () {
                                  fetchLocationAndGo(
                                      predictions![index].placeId!);
                                  setState(() {
                                    _searchController.text = predictions![index]
                                        .description!
                                        .toString();
                                    predictions!.clear();
                                  });
                                },
                                title: Align(
                                    alignment: Alignment.centerLeft,
                                    child: Text(
                                        predictions![index].description!))),
                          );
                        }),
                    Expanded(
                      child: GoogleMap(
                          mapType: MapType.satellite,
                          markers: _markers,
                          initialCameraPosition: _kGooglePlex,
                          onMapCreated: (GoogleMapController controller) {
                            googleMapController = controller;
                          }),
                    ),
                    const SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: CustomButton(
                            height: 50.0,
                            width: 100.0,
                            backgroundColor: Colors.grey[800],
                            borderRadius: BorderRadius.circular(25.0),
                            onPressed: () {
                              setState(() {
                                googleMapController.dispose();
                                isVenue = false;
                              });
                            },
                            padding: const EdgeInsets.all(0.0),
                            alignment: Alignment.center,
                            text: 'Back',
                            color: Colors.grey[100],
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fit: BoxFit.none,
                            elevation: 18.0,
                          ),
                        ),
                        Expanded(
                          child: CustomButton(
                            height: 50.0,
                            width: 100.0,
                            backgroundColor: Colors.grey[800],
                            borderRadius: BorderRadius.circular(25.0),
                            onPressed: () {
                              setState(() {
                                store();
                              });
                            },
                            padding: const EdgeInsets.all(0.0),
                            alignment: Alignment.center,
                            text: 'Save',
                            color: Colors.grey[100],
                            letterSpacing: 2.0,
                            fontSize: 15.0,
                            fit: BoxFit.none,
                            elevation: 18.0,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  void setMarker(LatLng point) async {
    setState(() {
      _markers = {};
      _markers.add(Marker(markerId: const MarkerId('marker'), position: point));
    });
  }

  void fetchLocationAndGo(String placeId) async {
    locationDetails = await LocationController().getPlace(placeId);

    if (locationDetails!.isNotEmpty) {
      setState(() {
        latitude = locationDetails!['geometry']['location']['lat'];
        longitude = locationDetails!['geometry']['location']['lng'];
      });
    }

    setMarker(LatLng(latitude!, longitude!));

    googleMapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(latitude!, longitude!),
      ),
    );
  }

  Widget BuildImage(File assetImage, int index) => Container(
        color: Colors.grey[500],
        child: Image.file(
          assetImage,
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

    if (scheduleStart.isEmpty && scheduleEnd.isEmpty) {
      Fluttertoast.showToast(
          msg: 'Please provide start date or end date',
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

    Map<String, dynamic> eventData = {
      'title': _titleController.text,
      'description': _descriptionController.text,
      'is_available': isAvailable,
      'fees': _feesController.text,
      'images': fileImages,
      'is_private': isPrivate,
      'schedule_start': scheduleStart,
      'schedule_end': scheduleEnd,
      'overallColor': overallColor,
      'event_type': eventType,
      'type': 'photo',
      'event_category': selectedCategory,
      'full_address': _fullAddressController.text,
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
      return;
    }

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
