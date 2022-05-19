import 'package:flutter/material.dart';
import '../Widgets/custom_textfield.dart';

class Login extends StatefulWidget {
  Login({Key? key}) : super(key: key);

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  TextEditingController miguel = TextEditingController();
  String text = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
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
              CustomTextField(
                obscureText: true,
                onChanged: (value) => text = value,
                label: 'Password',
              ),
              const SizedBox(height: 15),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 50,
                      child: OutlinedButton(
                        onPressed: () {},
                        style: OutlinedButton.styleFrom(
                            primary: Colors.grey[900],
                            backgroundColor: Colors.grey[100],
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(5.0)))),
                        child: const Text(
                          'Login',
                          style: TextStyle(fontSize: 15.0),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 15),
              const Text("Don't have an account?"),
              TextButton(
                onPressed: () =>
                    Navigator.pushReplacementNamed(context, '/signup'),
                child: const Text('Click Here to Signup'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
