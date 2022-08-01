// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  CustomTextField(
      {Key? key,
      this.onChanged,
      this.label,
      this.obscureText = false,
      this.controller,
      this.focusNode,
      this.maxLine,
      this.suffixIcon,
      this.textAlign,
      this.letterSpacing,
      this.textCapitalization = TextCapitalization.none,
      this.inputFormatters})
      : super(key: key);

  late TextEditingController? controller = TextEditingController();
  final ValueChanged? onChanged;
  final String? label;
  final int? maxLine;
  final bool obscureText;
  final FocusNode? focusNode;
  final List<TextInputFormatter>? inputFormatters;
  final TextAlign? textAlign;
  final double? letterSpacing;
  final TextCapitalization? textCapitalization;
  final Widget? suffixIcon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: suffixIcon == null
          ? const EdgeInsets.fromLTRB(10, 0, 10, 0)
          : const EdgeInsets.fromLTRB(10, 0, 0, 0),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          border: Border.all(color: Colors.grey)),
      child: TextField(
        onChanged: onChanged,
        textCapitalization: textCapitalization!,
        maxLines: maxLine,
        focusNode: focusNode,
        obscureText: obscureText,
        controller: controller,
        textAlign: textAlign!,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          suffixIcon: suffixIcon,
          floatingLabelBehavior: FloatingLabelBehavior.always,
          border: InputBorder.none,
          labelText: label,
          labelStyle: TextStyle(color: Colors.grey[800]),
          prefixIconConstraints:
              const BoxConstraints(minWidth: 0, minHeight: 0),
        ),
      ),
    );
  }
}
