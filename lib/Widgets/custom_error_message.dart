import 'package:flutter/material.dart';

class CustomErrorMessage extends StatelessWidget {
  CustomErrorMessage({Key? key, required this.message}) : super(key: key);

  late String message = '';

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10.0),
          border: Border.all(
              color: const Color.fromARGB(255, 132, 132, 132),
              width: 2.0,
              style: BorderStyle.solid)),
      child: SizedBox(
        height: 150,
        width: (MediaQuery.of(context).size.width),
        child: Align(
            alignment: Alignment.center,
            child: Text(
              message,
              style: const TextStyle(fontSize: 20),
            )),
      ),
    );
  }
}
