import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key? key, this.onChanged, this.label, this.obscureText = false})
      : super(key: key);

  final TextEditingController? controller = TextEditingController();
  final ValueChanged? onChanged;
  final String? label;
  final bool obscureText;

  @override
  Widget build(BuildContext context) {
    return TextField(
      obscureText: obscureText,
      controller: controller,
      decoration: InputDecoration(
          border: const OutlineInputBorder(
              borderSide: BorderSide(
            color: Color(0xFF114F5A),
          )),
          focusedBorder: const OutlineInputBorder(
              borderSide: BorderSide(
            width: 2,
            color: Color(0xFF114F5A),
          )),
          labelText: label,
          labelStyle: const TextStyle(
            color: Color(0xFF114F5A),
          )),
      onChanged: onChanged,
    );
  }
}
