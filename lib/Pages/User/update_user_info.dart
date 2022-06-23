import 'package:eventora/Widgets/custom_textformfield.dart';
import 'package:eventora/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import '../../Widgets/custom_dashboard_button.dart';
import '../../Widgets/custom_textfield.dart';
import '../../utils/email_validation.dart';
import 'package:country_picker/country_picker.dart';

class UpdateUserInfo extends StatefulWidget {
  const UpdateUserInfo({Key? key}) : super(key: key);

  @override
  State<UpdateUserInfo> createState() => _UpdateUserInfoState();
}

class _UpdateUserInfoState extends State<UpdateUserInfo> {
  late String? phoneCode = '';
  late int isAgeOver18 = 0;
  late Map<String, dynamic>? response = {};
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _oldPasswordController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _passwordConfirmationController =
      TextEditingController();
  final TextEditingController _birthdateController = TextEditingController();
  final TextEditingController _unitNoController = TextEditingController();
  final TextEditingController _streetNoController = TextEditingController();
  final TextEditingController _streetNameController = TextEditingController();
  final TextEditingController _countryController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _zipcodeController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _socialController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Basic Information:',
                          style: TextStyle(
                              color: Colors.grey[800], fontSize: 20.0)),
                    ),
                    TextButton(
                        onPressed: () => Navigator.pushNamedAndRemoveUntil(
                            context,
                            '/settings',
                            (Route<dynamic> route) => false),
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.grey[700],
                        ))
                  ],
                ),
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
                    CustomButton(
                      height: 65.0,
                      width: 100.0,
                      backgroundColor: Colors.grey[800],
                      borderRadius: BorderRadius.circular(10.0),
                      onPressed: () {
                        showCountryPicker(
                          context: context,
                          showPhoneCode: true,
                          onSelect: (Country countryPhoneCode) {
                            setState(() {
                              phoneCode = '+${countryPhoneCode.phoneCode}';
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
                                  color:
                                      const Color(0xFF8C98A8).withOpacity(0.2),
                                ),
                              ),
                            ),
                          ),
                        );
                      },
                      padding: const EdgeInsets.all(10.0),
                      alignment: Alignment.center,
                      text: phoneCode == '' ? '+0' : phoneCode!,
                      color: Colors.grey[100],
                      letterSpacing: 2.0,
                      fontSize: 15.0,
                      fit: BoxFit.none,
                      elevation: 0.0,
                    ),
                    const SizedBox(width: 15.0),
                    Expanded(
                      child: CustomTextField(
                        onChanged: (value) => value,
                        textAlign: TextAlign.left,
                        letterSpacing: 1.0,
                        label: 'Mobile',
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
                      height: 50.0,
                      width: 200.0,
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
                      text: _birthdateController.text == ''
                          ? 'Birthdate'
                          : _birthdateController.text,
                      color: Colors.grey[100],
                      letterSpacing: 2.0,
                      fontSize: 12.0,
                      fit: BoxFit.none,
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
                              color: const Color(0xFF8C98A8).withOpacity(0.2),
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
                const SizedBox(height: 15),
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
                const SizedBox(height: 15),
                Align(
                  alignment: Alignment.centerLeft,
                  child: Text('Other Contact Information:',
                      style:
                          TextStyle(color: Colors.grey[800], fontSize: 20.0)),
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  onChanged: (value) => value,
                  textAlign: TextAlign.left,
                  letterSpacing: 1.0,
                  label: 'Social Media Account:',
                  controller: _socialController,
                ),
                const SizedBox(height: 15),
                CustomButton(
                  height: 65.0,
                  width: 100.0,
                  backgroundColor: Colors.grey[800],
                  borderRadius: BorderRadius.circular(10.0),
                  onPressed: () {
                    updateInfo();
                  },
                  padding: const EdgeInsets.all(10.0),
                  alignment: Alignment.center,
                  text: 'Update',
                  color: Colors.grey[100],
                  letterSpacing: 2.0,
                  fontSize: 15.0,
                  fit: BoxFit.none,
                  elevation: 0.0,
                ),
              ],
            ),
          ),
        ),
      )),
    );
  }

  void updateInfo() async {
    if (isAgeOver18 != 0 && isAgeOver18 < 18) {
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
      'unit_no': _unitNoController.text,
      'street_no': _streetNoController.text,
      'street_name': _streetNameController.text,
      'country': _countryController.text,
      'state': _stateController.text,
      'city': _cityController.text,
      'zipcode': _zipcodeController.text,
      'mobile': _mobileController.text,
      'social': _socialController.text,
    };

    response = await AuthController().userUpdate(userInfo);

    print(response!['message']);

    if (response!.isNotEmpty) {
      if (response!['message'] != null) {
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
          _birthdateController.text = 'Birthdate';
          _unitNoController.clear();
          _streetNoController.clear();
          _streetNameController.clear();
          _countryController.text = 'Select Country';
          _stateController.clear();
          _cityController.clear();
          _zipcodeController.clear();
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
