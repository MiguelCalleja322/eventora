import '../../Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  Signup({Key? key}) : super(key: key);

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  DateTime selectedDate = DateTime.now();

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(1970, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  TextEditingController miguel = TextEditingController();
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Eventora',
                  style: TextStyle(color: Colors.grey[800], fontSize: 40.0),
                ),
                const SizedBox(height: 70),
                CustomTextField(
                  onChanged: (value) => text = value,
                  label: 'Email',
                ),
                const SizedBox(height: 15),
                Row(
                  children: [
                    Expanded(
                      child: CustomTextField(
                        onChanged: (value) => text = value,
                        label: 'Username',
                      ),
                    ),
                    const SizedBox(
                      width: 15,
                    ),
                    Expanded(
                      child: CustomTextField(
                        onChanged: (value) => text = value,
                        label: 'Mobile',
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  obscureText: true,
                  onChanged: (value) => text = value,
                  label: 'Password',
                ),
                const SizedBox(height: 15),
                CustomTextField(
                  obscureText: true,
                  onChanged: (value) => text = value,
                  label: 'Confirm Password',
                ),
                const SizedBox(height: 15),
                Row(
                  children: <Widget>[
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () => _selectDate(context),
                        child: const Text('Select date'),
                      ),
                    ),
                    const SizedBox(
                      width: 20.0,
                    ),
                    Expanded(
                        child: Text("${selectedDate.toLocal()}".split(' ')[0])),
                  ],
                ),
                const SizedBox(height: 15),
                SizedBox(
                  height: 50,
                  width: double.infinity,
                  child: OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                        primary: const Color(0xFFF7F8FB),
                        backgroundColor: const Color(0xFF114F5A),
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)))),
                    child: const Text(
                      'Signup',
                      style: TextStyle(fontSize: 15.0),
                    ),
                  ),
                ),
                const SizedBox(height: 15),
                Center(
                  child: TextButton(
                    onPressed: () =>
                        Navigator.pushReplacementNamed(context, '/'),
                    child: const Text('Click Here to Login'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
