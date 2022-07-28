// ignore_for_file: non_constant_identifier_names

import 'dart:async';
import 'dart:io';
import 'dart:math';
import 'package:eventora/controllers/user_event_controller.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart' as p;
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_button.dart';
import 'package:eventora/Widgets/custom_icon_button.dart';
import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:eventora/controllers/location_controller.dart';
import 'package:eventora/utils/s3.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ionicons/ionicons.dart';

class CreateUserEvents extends StatefulWidget {
  CreateUserEvents({Key? key}) : super(key: key);

  @override
  State<CreateUserEvents> createState() => _CreateUserEventsState();
}

class _CreateUserEventsState extends State<CreateUserEvents> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();

  final FocusNode _titlefocusNode = FocusNode();
  final FocusNode _descriptionfocusNode = FocusNode();

  late GoogleMapController googleMapController;

  final ImagePicker imagePicker = ImagePicker();
  List<File>? imageFileList = [];
  late String scheduleStart = '';
  late String scheduleEnd = '';
  late List<String> dressCode = [];
  late double? latitude = 0.0;
  late double? longitude = 0.0;
  late Map<String, dynamic>? locationDetails = {};
  late Set<Marker> _markers = <Marker>{};
  late GooglePlace googlePlace;
  late List<AutocompletePrediction>? predictions = [];
  late Timer? _debounce = Timer(const Duration(milliseconds: 1000), () {});
  late bool loading = false;
  late int timestamp = DateTime.now().millisecondsSinceEpoch;
  late List<XFile> selectedImages = [];
  late Map<String, dynamic> eventData = {};

  List options = [
    {'title': 'Sweatwear', 'isActive': false},
    {'title': 'Casual', 'isActive': false},
    {'title': 'Business Casual', 'isActive': false},
    {'title': 'Smart Casual', 'isActive': false},
    {'title': 'Business Informal', 'isActive': false},
    {'title': 'Semi-formal', 'isActive': false},
  ];

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

  changeState(item) {
    if (dressCode.contains(item['title'])) {
      dressCode.remove(item['title']);
    } else {
      dressCode.add(item['title']);
    }

    setState(() {
      item['isActive'] = !item['isActive'];
    });
  }

  customBoxDecoration(isActive) {
    return BoxDecoration(
      color: isActive ? const Color(0xff1763DD) : Colors.white,
      border: const Border(
          left: BorderSide(color: Colors.black12, width: 1.0),
          bottom: BorderSide(color: Colors.black12, width: 1.0),
          top: BorderSide(color: Colors.black12, width: 1.0),
          right: BorderSide(color: Colors.black12, width: 1.0)),
      borderRadius: const BorderRadius.all(
        Radius.circular(5.0),
      ),
    );
  }

  @override
  void initState() {
    googlePlaceInit();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    predictions!.clear();
    _debounce!.cancel();
    _titleController.dispose();
    _descriptionController.dispose();
    _fullAddressController.dispose();
    _locationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Create User Event',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: Column(
              children: [
                imageFileList!.isEmpty
                    ? DecoratedBox(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(
                                color: const Color.fromARGB(255, 132, 132, 132),
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
                                                    BorderRadius.circular(10))),
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
                                return BuildImage(imageFileList![index], index);
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
                  height: 15.0,
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
                  height: 15.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Details:',
                    style: TextStyle(color: Colors.grey[800], fontSize: 30.0),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
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
                  height: 15.0,
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
                  height: 15.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Schedule:',
                    style: TextStyle(color: Colors.grey[800], fontSize: 30.0),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
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
                              minTime: DateTime.now(),
                              maxTime: DateTime(2040, 6, 7), onConfirm: (date) {
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
                        text:
                            scheduleStart == '' ? 'Select Date' : scheduleStart,
                        elevation: 0,
                      ),
                    ),
                    Expanded(
                      child: CustomButton(
                        title: 'End Date:',
                        backgroundColor: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10.0),
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime.now(),
                              maxTime: DateTime(2040, 6, 7), onConfirm: (date) {
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
                  height: 15.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Dress Code:',
                    style: TextStyle(color: Colors.grey[800], fontSize: 30.0),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Wrap(
                    spacing: 10.0,
                    runSpacing: 20.0,
                    children: options
                        .map((option) => Container(
                            decoration: customBoxDecoration(option['isActive']),
                            child: InkWell(
                                onTap: () {
                                  changeState(option);
                                },
                                child: Container(
                                    padding: const EdgeInsets.all(10),
                                    child: Text('${option['title']}',
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            fontWeight: FontWeight.normal,
                                            color: option['isActive']
                                                ? Colors.white
                                                : Colors.black87))))))
                        .toList()),
                const SizedBox(
                  height: 15.0,
                ),
                const SizedBox(
                  height: 15.0,
                ),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Venue',
                    style: TextStyle(color: Colors.grey[800], fontSize: 30.0),
                  ),
                ),
                const SizedBox(
                  height: 15.0,
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
                  height: 15.0,
                ),
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: predictions!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            leading: const Icon(Ionicons.pin),
                            onTap: () {
                              fetchLocationAndGo(predictions![index].placeId!);
                              setState(() {
                                _fullAddressController.text =
                                    predictions![index].description!.toString();
                                predictions!.clear();
                                _debounce!.cancel();
                                FocusManager.instance.primaryFocus?.unfocus();
                              });
                            },
                            title: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(predictions![index].description!))),
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
                  height: 15.0,
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

  openImages() async {
    setState(() {
      loading = true;
    });
    try {
      selectedImages = await imagePicker.pickMultiImage() ?? [];
      setState(() {
        for (var element in selectedImages) {
          imageFileList!.add(File(element.path));
        }
      });
    } catch (e) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: 'Unknown problem occured.',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[500],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);

      return;
    }

    setState(() {
      loading = false;
    });
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

  void store(context) async {
    List<String> fileImages = [];

    if (_titleController.text.isEmpty) {
      return _titlefocusNode.requestFocus();
    }

    if (_descriptionController.text.isEmpty) {
      return _descriptionfocusNode.requestFocus();
    }

    if (dressCode.isEmpty) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: 'Please at least 1 dress code',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[500],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);

      return;
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
      'title': _titleController.text,
      'description': _descriptionController.text,
      'schedule_start': scheduleStart,
      'schedule_end': scheduleEnd,
      'dresscode': dressCode,
      'images': fileImages,
      'full_address': _fullAddressController.text,
      'location': _locationController.text,
    };

    Map<String, dynamic>? response = await UserEventController.store(eventData);

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
