import 'dart:async';

import 'package:eventora/Widgets/custom_textformfield.dart';
import 'package:eventora/controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_feather_icons/flutter_feather_icons.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:google_place/google_place.dart';
import 'package:intl/intl.dart';
import 'package:ionicons/ionicons.dart';
import '../../Widgets/custom_appbar.dart';
import '../../Widgets/custom_button.dart';
import '../../Widgets/custom_textfield.dart';
import '../../controllers/location_controller.dart';
import '../../utils/email_validation.dart';

class UpdateUserInfo extends StatefulWidget {
  const UpdateUserInfo({Key? key}) : super(key: key);

  @override
  State<UpdateUserInfo> createState() => _UpdateUserInfoState();
}

class _UpdateUserInfoState extends State<UpdateUserInfo> {
  late String? phoneCode = '';
  late int isAgeOver18 = 0;
  late Set<Marker> _markers = <Marker>{};
  late GooglePlace googlePlace;
  late List<AutocompletePrediction>? predictions = [];
  late Timer? _debounce = Timer(const Duration(milliseconds: 1000), () {});
  late double? latitude = 0.0;
  late double? longitude = 0.0;
  late Map<String, dynamic>? locationDetails = {};
  late Map<String, dynamic>? response = {};
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final TextEditingController _fullAddressController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _socialController = TextEditingController();
  late GoogleMapController googleMapController;

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
    googlePlaceInit();
    super.initState();
  }

  @override
  void dispose() {
    googleMapController.dispose();
    predictions!.clear();
    _debounce!.cancel();
    _usernameController.dispose();
    _emailController.dispose();
    _oldPasswordController.dispose();
    _passwordController.dispose();
    _passwordConfirmationController.dispose();
    _birthdateController.dispose();
    _fullAddressController.dispose();
    _locationController.dispose();
    _mobileController.dispose();
    _socialController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Basic Information',
      ),
      body: SafeArea(
          child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: ConstrainedBox(
            constraints: BoxConstraints(
                minHeight: (MediaQuery.of(context).size.height),
                minWidth: (MediaQuery.of(context).size.width)),
            child: Column(
              children: <Widget>[
                // Align(
                //   alignment: Alignment.centerLeft,
                //   child: Text('User Information',
                //       style:
                //           TextStyle(color: Colors.grey[800], fontSize: 40.0)),
                // ),
                // SizedBox(
                //   height: 40,
                //   child: Divider(
                //     color: Colors.grey[600],
                //   ),
                // ),

                const SizedBox(height: 15),
                CustomTextFormField(
                  onChanged: (value) => value,
                  label: 'Email',
                  controller: _emailController,
                  validator: (value) =>
                      EmailServiceChecker().isEmailValid(value!),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  onChanged: (value) => value,
                  textAlign: TextAlign.left,
                  letterSpacing: 1.0,
                  label: 'Username',
                  controller: _usernameController,
                  inputFormatters: [
                    FilteringTextInputFormatter.allow(RegExp(r'[a-zA-Z0-9]'))
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // CustomButton(
                    //   height: 65.0,
                    //   width: 100.0,
                    //   backgroundColor: Colors.grey[800],
                    //   borderRadius: BorderRadius.circular(10.0),
                    //   onPressed: () {
                    //     showCountryPicker(
                    //       context: context,
                    //       showPhoneCode: true,
                    //       onSelect: (Country countryPhoneCode) {
                    //         setState(() {
                    //           phoneCode = '+${countryPhoneCode.phoneCode}';
                    //         });
                    //       },
                    //       countryListTheme: CountryListThemeData(
                    //         borderRadius: const BorderRadius.only(
                    //           topLeft: Radius.circular(40.0),
                    //           topRight: Radius.circular(40.0),
                    //         ),
                    //         inputDecoration: InputDecoration(
                    //           labelText: 'Search',
                    //           hintText: 'Start typing to search',
                    //           prefixIcon: const Icon(Icons.search),
                    //           border: OutlineInputBorder(
                    //             borderSide: BorderSide(
                    //               color:
                    //                   const Color(0xFF8C98A8).withOpacity(0.2),
                    //             ),
                    //           ),
                    //         ),
                    //       ),
                    //     );
                    //   },
                    //   padding: const EdgeInsets.all(10.0),
                    //   alignment: Alignment.center,
                    //   text: phoneCode == '' ? '+0' : phoneCode!,
                    //   color: Colors.grey[100],
                    //   letterSpacing: 2.0,
                    //   fontSize: 15.0,
                    //   fit: BoxFit.none,
                    //   elevation: 0.0,
                    // ),
                    // const SizedBox(width: 15.0),
                    Expanded(
                      child: CustomTextField(
                        onChanged: (value) => value,
                        textAlign: TextAlign.left,
                        letterSpacing: 1.0,
                        label: 'Mobile: +974',
                        controller: _mobileController,
                        inputFormatters: [
                          FilteringTextInputFormatter.allow(RegExp(r'[0-9]'))
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(
                  height: 15,
                ),
                Row(
                  children: [
                    const Text('Select a birthdate:'),
                    const SizedBox(
                      width: 15,
                    ),
                    CustomButton(
                      isIcon: true,
                      icon: Ionicons.calendar,
                      backgroundColor: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10.0),
                      onPressed: () {
                        DatePicker.showDatePicker(context,
                            showTitleActions: true,
                            minTime: DateTime(1950, 1, 1),
                            maxTime: DateTime(2030, 12, 31), onConfirm: (date) {
                          var inputFormat = DateFormat('yyyy-MM-dd');
                          setState(() {
                            _birthdateController.text =
                                inputFormat.format(date);

                            final difference = DateTime.now().difference(date);
                            isAgeOver18 = (difference.inDays / 365).floor();
                          });
                        }, currentTime: DateTime.now(), locale: LocaleType.en);
                      },
                      padding: const EdgeInsets.all(15.0),
                      alignment: Alignment.center,
                      // text: _birthdateController.text == ''
                      //     ? 'Birthdate'
                      //     : _birthdateController.text,
                      elevation: 0,
                    ),
                  ],
                ),
                const SizedBox(height: 15.0),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Password:',
                      style:
                          TextStyle(color: Colors.grey[800], fontSize: 20.0)),
                ),
                const SizedBox(height: 15.0),
                CustomTextFormField(
                  obscureText: true,
                  onChanged: (value) => value,
                  label: 'Old Password',
                  controller: _oldPasswordController,
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  obscureText: true,
                  onChanged: (value) => value,
                  label: 'Password',
                  controller: _passwordController,
                ),
                const SizedBox(height: 15),
                CustomTextFormField(
                  obscureText: true,
                  onChanged: (value) => value,
                  label: 'Password Confirmation',
                  controller: _passwordConfirmationController,
                ),
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Address:',
                      style:
                          TextStyle(color: Colors.grey[800], fontSize: 20.0)),
                ),
                const SizedBox(height: 15),
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
                          _fullAddressController.text = '';
                          predictions!.clear();
                        });
                      }
                    },
                    controller: _fullAddressController,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(hintText: 'Search'),
                  )),
                  IconButton(
                      onPressed: () {
                        _fullAddressController.text = '';
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
                const SizedBox(height: 15),
                CustomButton(
                  backgroundColor: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10.0),
                  onPressed: () {
                    updateInfo();
                  },
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  text: 'Update',
                  elevation: 0.0,
                ),
              ],
            ),
          ),
        ),
      )),
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

  void updateInfo() async {
    if (isAgeOver18 != 0 && isAgeOver18 < 18) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: 'Age must be over 18',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[500],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);
    }

    if (_passwordController.text != _passwordConfirmationController.text) {
      Fluttertoast.cancel();
      Fluttertoast.showToast(
          msg: 'Password did not match!',
          gravity: ToastGravity.BOTTOM,
          backgroundColor: Colors.red[500],
          textColor: Colors.white,
          timeInSecForIosWeb: 3,
          toastLength: Toast.LENGTH_LONG,
          fontSize: 16.0);
      return;
    }

    Map<String, dynamic> userInfo = {
      'username': _usernameController.text,
      'email': _emailController.text,
      'old_password': _oldPasswordController.text,
      'password': _passwordController.text,
      'password_confirmation': _passwordConfirmationController.text,
      'birthdate': _birthdateController.text,
      'mobile': '+974${_mobileController.text}',
      'social': _socialController.text,
      'full_address': _fullAddressController.text,
      'location': _locationController.text,
    };

    response = await AuthController().userUpdate(userInfo);

    if (response!.isNotEmpty) {
      if (response!['message'] != null) {
        Fluttertoast.cancel();
        Fluttertoast.showToast(
            msg: response!['message'].toString(),
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[500],
            textColor: Colors.white,
            timeInSecForIosWeb: 3,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0);
        setState(() {
          _usernameController.clear();
          _emailController.clear();
          _oldPasswordController.clear();
          _passwordController.clear();
          _passwordConfirmationController.clear();
          _mobileController.clear();
          _socialController.clear();
        });

        return;
      }

      if (response!['error'] != null) {
        Fluttertoast.showToast(
            msg: response!['error'],
            gravity: ToastGravity.BOTTOM,
            backgroundColor: Colors.grey[500],
            textColor: Colors.white,
            timeInSecForIosWeb: 3,
            toastLength: Toast.LENGTH_LONG,
            fontSize: 16.0);
        return;
      }
    }
  }
}
