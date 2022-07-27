// ignore_for_file: avoid_function_literals_in_foreach_calls, non_constant_identifier_names, avoid_print, depend_on_referenced_packages

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventora/Widgets/custom_button.dart';
import 'package:eventora/Widgets/custom_icon_button.dart';
import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:eventora/controllers/event_categories_controller.dart';
import 'package:eventora/controllers/events_controller.dart';
import 'package:eventora/utils/s3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
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
import 'package:ionicons/ionicons.dart';
import 'package:path/path.dart' as p;
import '../../../Widgets/custom_appbar.dart';
import '../../../controllers/location_controller.dart';

class CreateEvents extends StatefulWidget {
  const CreateEvents({Key? key}) : super(key: key);

  @override
  State<CreateEvents> createState() => _CreateEventsState();
}

class _CreateEventsState extends State<CreateEvents> {
  final ImagePicker imagePicker = ImagePicker();
  List<File>? imageFileList = [];
  late List<bool> isSelected = [false, false];
  late List<bool> isSelectedFeatures = [false, false, false, false, false];
  late List<bool> isEventPrivate = [false, false];
  late List<bool> isEventAvailable = [false, false];
  late List<String> features = ['Taxi'];
  late String eventType = '';
  late bool isPrivate = false;
  late bool isAvailable = true;
  late String scheduleStart = '';
  late String scheduleEnd = '';
  late int timestamp = DateTime.now().millisecondsSinceEpoch;
  late Map<String, dynamic>? fetchedCategories = {};
  late List<dynamic>? eventCategories = [];
  late String? selectedCategory = 'Business';
  late String? overallColor = '0xFF0090B8';
  late double? latitude = 0.0;
  late double? longitude = 0.0;
  late Map<String, dynamic>? locationDetails = {};
  late Set<Marker> _markers = <Marker>{};
  late GooglePlace googlePlace;
  late List<AutocompletePrediction>? predictions = [];
  late Timer? _debounce = Timer(const Duration(milliseconds: 1000), () {});
  late Map<String, dynamic> eventData = {};
  late List<XFile> selectedImages = [];

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _feesController = TextEditingController();
  final TextEditingController _registrationLinkController =
      TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  late GoogleMapController googleMapController;

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
      selectedImages = await imagePicker.pickMultiImage() ?? [];
      setState(() {
        selectedImages.forEach((element) {
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
    _debounce!.cancel();
    _titleController.dispose();
    _descriptionController.dispose();
    _feesController.dispose();
    _registrationLinkController.dispose();
    _fullAddressController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
          title: 'Create Event',
          hideBackButton: false,
        ),
        body: SafeArea(
          child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Event Category:',
                        style:
                            TextStyle(color: Colors.grey[800], fontSize: 20.0),
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
                                  if (newValue == 'Education') {
                                    overallColor = '0xFFBA2200';
                                  } else if (newValue == 'Business') {
                                    overallColor = '0xFF0090B8';
                                  } else if (newValue == 'Leisure') {
                                    overallColor = '0xFF007FEE';
                                  } else if (newValue == 'Family') {
                                    overallColor = '0xFFCC00A7';
                                  } else if (newValue == 'Lifestyle') {
                                    overallColor = '0xFF009039';
                                  } else if (newValue == 'Culture') {
                                    overallColor = '0xFFE97C00';
                                  } else if (newValue == 'Arts') {
                                    overallColor = '0xFFF5D400';
                                  } else if (newValue == 'Sports') {
                                    overallColor = '0xFF969696';
                                  } else if (newValue == 'Virtual') {
                                    overallColor = '0xFF900045';
                                  } else {
                                    overallColor = '0xFF9CD000';
                                  }

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
                    height: 10.0,
                  ),
                  imageFileList!.isEmpty
                      ? DecoratedBox(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                  color:
                                      const Color.fromARGB(255, 132, 132, 132),
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
                                    : SizedBox(
                                        height: 200,
                                        width: double.infinity,
                                        child: OutlinedButton(
                                          style: OutlinedButton.styleFrom(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10))),
                                          onPressed: () {
                                            openImages();
                                          },
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              Icon(
                                                Icons.image,
                                                color: Colors.grey[700],
                                              ),
                                              const SizedBox(width: 15),
                                              Text(
                                                'Choose Image',
                                                style: TextStyle(
                                                  color: Colors.grey[700],
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
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
                                  autoPlayInterval: const Duration(seconds: 2),
                                )),
                          ),
                        ]),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomButton(
                    backgroundColor: Colors.grey[800],
                    borderRadius: BorderRadius.circular(10.0),
                    onPressed: () {
                      setState(() {
                        imageFileList!.clear();
                        loading = false;
                      });
                    },
                    padding: const EdgeInsets.all(15.0),
                    alignment: Alignment.center,
                    text: 'Clear Selections',
                    elevation: 18.0,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Details:',
                      style: TextStyle(color: Colors.grey[800], fontSize: 30.0),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    textAlign: TextAlign.left,
                    letterSpacing: 1.0,
                    label: 'Title',
                    maxLine: 1,
                    controller: _titleController,
                    focusNode: _titlefocusNode,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                    textAlign: TextAlign.left,
                    letterSpacing: 1.0,
                    label: 'Description',
                    maxLine: 12,
                    controller: _descriptionController,
                    focusNode: _descriptionfocusNode,
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: CustomButton(
                          title: 'Event Start:',
                          backgroundColor: Colors.grey[800],
                          borderRadius: BorderRadius.circular(10.0),
                          onPressed: () {
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(2022, 3, 5),
                                maxTime: DateTime(2030, 6, 7),
                                onConfirm: (date) {
                              var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                              setState(() {
                                scheduleStart = inputFormat.format(date);
                              });
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          padding: const EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                          text: scheduleStart == ''
                              ? 'Select Date'
                              : scheduleStart,
                          elevation: 0,
                        ),
                      ),
                      Expanded(
                        child: CustomButton(
                          title: 'End Date:',
                          backgroundColor: Colors.grey[800],
                          borderRadius: BorderRadius.circular(10.0),
                          onPressed: () {
                            DateTime minTime = DateTime.parse(scheduleStart);
                            DatePicker.showDateTimePicker(context,
                                showTitleActions: true,
                                minTime: DateTime(
                                    minTime.year, minTime.month, minTime.day),
                                maxTime: DateTime(2030, 6, 7),
                                onConfirm: (date) {
                              var inputFormat = DateFormat('yyyy-MM-dd HH:mm');
                              setState(() {
                                scheduleEnd = inputFormat.format(date);
                              });
                            },
                                currentTime: DateTime.now(),
                                locale: LocaleType.en);
                          },
                          padding: const EdgeInsets.all(0.0),
                          alignment: Alignment.center,
                          text: scheduleEnd == '' ? 'Select Date' : scheduleEnd,
                          elevation: 0,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Event Features:',
                        style: TextStyle(fontSize: 18),
                      )),
                  const SizedBox(
                    height: 10.0,
                  ),
                  ToggleButtons(
                    selectedColor: Colors.grey[700],
                    splashColor: Colors.grey[700],
                    selectedBorderColor: Colors.grey[700],
                    borderWidth: 1,
                    onPressed: (int newIndex) {
                      setState(() {
                        isSelectedFeatures[newIndex] =
                            !isSelectedFeatures[newIndex];

                        if (newIndex == 0) {
                          if (features.contains('Monetize')) {
                            features.remove('Monetize');
                          } else {
                            features.add('Monetize');
                          }
                        } else if (newIndex == 1) {
                          if (features.contains('Wifi')) {
                            features.remove('Wifi');
                          } else {
                            features.add('Wifi');
                          }
                        } else if (newIndex == 2) {
                          if (features.contains('Train')) {
                            features.remove('Train');
                          } else {
                            features.add('Train');
                          }
                        } else if (newIndex == 3) {
                          if (features.contains('Good Sound')) {
                            features.remove('Good Sound');
                          } else {
                            features.add('Good Sound');
                          }
                        } else {
                          if (features.contains('Cool')) {
                            features.remove('Cool');
                          } else {
                            features.add('Cool');
                          }
                        }
                      });
                    },
                    isSelected: isSelectedFeatures,
                    children: const <Widget>[
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(Icons.paid_outlined),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(Icons.wifi),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(Icons.train_outlined),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(Icons.spatial_audio),
                      ),
                      Padding(
                        padding: EdgeInsets.all(5.0),
                        child: Icon(Icons.ac_unit),
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Event Availability:',
                          style: TextStyle(fontSize: 18))),
                  const SizedBox(
                    height: 10.0,
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
                    height: 10.0,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Make the event private?',
                          style: TextStyle(fontSize: 18))),
                  const SizedBox(
                    height: 10.0,
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
                    height: 10.0,
                  ),
                  const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Paid or Free event?',
                          style: TextStyle(fontSize: 18))),
                  const SizedBox(
                    height: 10.0,
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
                    height: 10.0,
                  ),
                  eventType == 'registration'
                      ? CustomTextField(
                          textAlign: TextAlign.left,
                          letterSpacing: 1.0,
                          label: 'Event Link',
                          controller: _registrationLinkController,
                          focusNode: _registrationLinkfocusNode,
                          maxLine: 1,
                        )
                      : eventType == 'ticketed'
                          ? CustomTextField(
                              textAlign: TextAlign.left,
                              letterSpacing: 1.0,
                              label: 'Fees',
                              controller: _feesController,
                              focusNode: _feesfocusNode,
                              maxLine: 1,
                            )
                          : Container(),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      'Venue',
                      style: TextStyle(color: Colors.grey[800], fontSize: 30.0),
                    ),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  CustomTextField(
                      controller: _fullAddressController,
                      textCapitalization: TextCapitalization.words,
                      textAlign: TextAlign.left,
                      maxLine: 1,
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
                            _fullAddressController.text = '';
                            predictions!.clear();
                          });
                        }
                      },
                      suffixIcon: CustomIconButton(
                          icon: Ionicons.close_outline,
                          onPressed: () {
                            _fullAddressController.text = '';
                            predictions!.clear();
                          }),
                      letterSpacing: 1),
                  const SizedBox(
                    height: 10.0,
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
                                  _fullAddressController.text =
                                      predictions![index]
                                          .description!
                                          .toString();
                                  predictions!.clear();
                                  _debounce!.cancel();
                                  FocusManager.instance.primaryFocus?.unfocus();
                                });
                              },
                              title: Align(
                                  alignment: Alignment.centerLeft,
                                  child:
                                      Text(predictions![index].description!))),
                        );
                      }),
                  SizedBox(
                    height: 400,
                    child: GoogleMap(
                        mapType: MapType.normal,
                        markers: _markers,
                        scrollGesturesEnabled: true,
                        zoomGesturesEnabled: true,
                        myLocationButtonEnabled: false,
                        initialCameraPosition: _kGooglePlex,
                        gestureRecognizers: <
                            Factory<OneSequenceGestureRecognizer>>{
                          Factory<OneSequenceGestureRecognizer>(
                            () => EagerGestureRecognizer(),
                          ),
                        },
                        onMapCreated: (GoogleMapController controller) {
                          googleMapController = controller;
                        }),
                  ),
                  const SizedBox(
                    height: 10.0,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Align(
                          alignment: Alignment.centerRight,
                          child: CustomButton(
                            backgroundColor: Colors.grey[800],
                            borderRadius: BorderRadius.circular(10.0),
                            onPressed: () {
                              setState(() {
                                store(context);
                              });
                            },
                            padding: const EdgeInsets.all(0.0),
                            alignment: Alignment.center,
                            text: 'Save',
                            elevation: 18.0,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ));
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

    _locationController.text = '$latitude, $longitude';

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

  void store(context) async {
    List<String> fileImages = [];

    if (_titleController.text.isEmpty) {
      return _titlefocusNode.requestFocus();
    }

    if (_descriptionController.text.isEmpty) {
      return _descriptionfocusNode.requestFocus();
    }

    if (scheduleStart.isEmpty && scheduleEnd.isEmpty) {
      Fluttertoast.cancel();
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
      Fluttertoast.cancel();
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
      Fluttertoast.cancel();
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

    eventData = {
      'event_category': selectedCategory,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'schedule_start': scheduleStart,
      'schedule_end': scheduleEnd,
      'bgcolor': overallColor,
      'is_available': isAvailable,
      'fees': _feesController.text,
      'images': fileImages,
      'features': features,
      'registration_link': _registrationLinkController.text,
      'event_type': eventType,
      'is_private': isPrivate,
      'type': 'photo',
      'full_address': _fullAddressController.text,
      'location': _locationController.text,
    };

    Map<String, dynamic>? response = await EventController().store(eventData);

    if (response!['message'] != null) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: response['message'],
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[500],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);
      return;
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: 'Done',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[700],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);
      setState(() {
        _titleController.clear();
        _descriptionController.clear();
        _feesController.clear();
        _registrationLinkController.clear();
        _fullAddressController.clear();
        _locationController.clear();
        scheduleStart = '';
        scheduleEnd = '';
        isAvailable = false;
        fileImages = [];
        eventType = '';
        isPrivate = false;
        latitude = 0.0;
        longitude = 0.0;
        features = ['Taxi'];
        selectedImages.clear();
        imageFileList!.clear();
        selectedCategory = 'Business';
        overallColor = '0xFF0090B8';
        isSelected = [false, false];
        isSelectedFeatures = [false, false, false, false, false];
        isEventPrivate = [false, false];
        isEventAvailable = [false, false];
      });
      Navigator.pop(context);
    }
  }

  static randomString() {
    const chars =
        'AaBbCcDdEeFfGgHhIiJjKkLlMmNnOoPpQqRrSsTtUuVvWwXxYyZz1234567890';
    Random rnd = Random();
    return String.fromCharCodes(Iterable.generate(
        32, (_) => chars.codeUnitAt(rnd.nextInt(chars.length))));
  }
}
