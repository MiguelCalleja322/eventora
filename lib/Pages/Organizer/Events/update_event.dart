import 'dart:async';
import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_icon_button.dart';
import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:eventora/controllers/events_controller.dart';
import 'package:eventora/controllers/location_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';

import '../../../Widgets/custom_button.dart';

class UpdateEvent extends StatefulWidget {
  const UpdateEvent(
      {Key? key,
      required this.slug,
      this.title,
      this.description,
      this.scheduleStart,
      this.scheduleEnd})
      : super(key: key);

  final String slug;
  final String? title;
  final String? description;
  final DateTime? scheduleStart;
  final DateTime? scheduleEnd;

  @override
  State<UpdateEvent> createState() => _UpdateEventState();
}

class _UpdateEventState extends State<UpdateEvent> {
  late List<bool> isSelected = [false, false];
  late String eventType = '';
  late double? latitude = 0.0;
  late double? longitude = 0.0;
  late Map<String, dynamic>? locationDetails = {};
  late Set<Marker> _markers = <Marker>{};
  late GooglePlace googlePlace;
  late List<AutocompletePrediction>? predictions = [];
  late String scheduleStart = '';
  late String scheduleEnd = '';
  late Timer? _debounce = Timer(const Duration(milliseconds: 1000), () {});
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

  @override
  void initState() {
    DateFormat inputFormat = DateFormat('yyyy-MM-dd HH:mm');
    _titleController.text = widget.title!;
    _descriptionController.text = widget.description!;
    scheduleStart = inputFormat.format(widget.scheduleStart!);
    scheduleEnd = inputFormat.format(widget.scheduleEnd!);

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
        title: 'Update Event',
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: [
                CustomTextField(
                  textAlign: TextAlign.left,
                  letterSpacing: 1.0,
                  label: 'Title',
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
                              maxTime: DateTime(2030, 6, 7), onConfirm: (date) {
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
                        title: 'Event End:',
                        backgroundColor: Colors.grey[800],
                        borderRadius: BorderRadius.circular(10.0),
                        onPressed: () {
                          DatePicker.showDateTimePicker(context,
                              showTitleActions: true,
                              minTime: DateTime(2022, 3, 5),
                              maxTime: DateTime(2030, 6, 7), onConfirm: (date) {
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
                    child: Text('Paid or Free event?',
                        style: TextStyle(fontSize: 18))),
                const SizedBox(
                  height: 10.0,
                ),
                ToggleButtons(
                  onPressed: (int newIndex) {
                    setState(() {
                      for (int index = 0; index < isSelected.length; index++) {
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
                ListView.builder(
                    shrinkWrap: true,
                    itemCount: predictions!.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: ListTile(
                            leading: const Icon(Ionicons.pin_outline),
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
                const SizedBox(
                  height: 10.0,
                ),
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
                CustomButton(
                  backgroundColor: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10.0),
                  onPressed: () {
                    update(context);
                  },
                  padding: const EdgeInsets.all(0.0),
                  alignment: Alignment.center,
                  text: 'Update',
                  elevation: 0,
                ),
              ],
            ),
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

    _locationController.text = '$latitude, $longitude';

    setMarker(LatLng(latitude!, longitude!));

    googleMapController.animateCamera(
      CameraUpdate.newLatLng(
        LatLng(latitude!, longitude!),
      ),
    );
  }

  void update(context) async {
    Map<String, dynamic> dataToUpdate = {
      'slug': widget.slug,
      'title': _titleController.text,
      'description': _descriptionController.text,
      'registration_link': _registrationLinkController.text,
      'fees': _feesController.text,
      'schedule_start': scheduleStart,
      'schedule_end': scheduleEnd,
      'event_type': eventType.toString(),
      'location': _locationController.text,
      'full_address': _fullAddressController.text,
    };

    Map<String, dynamic>? response =
        await EventController().update(dataToUpdate);

    if (response!['message'].isNotEmpty) {
      Fluttertoast.cancel();
      await Fluttertoast.showToast(
          msg: response['message'],
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.grey[800],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);

      Navigator.pop(context);
      return;
    } else {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: response['error'],
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[500],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);

      Navigator.pop(context);
      return;
    }
  }
}
