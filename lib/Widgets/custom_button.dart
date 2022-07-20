import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  const CustomButton(
      {Key? key,
      required this.backgroundColor,
      required this.borderRadius,
      required this.onPressed,
      required this.padding,
      required this.alignment,
      this.title = '',
      this.text,
      this.elevation,
      this.icon,
      this.isIcon = false})
      : super(key: key);

  final String? title;
  final Color? backgroundColor;
  final BorderRadius? borderRadius;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final IconData? icon;
  final String? text;
  final double? elevation;
  final bool? isIcon;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
        style: OutlinedButton.styleFrom(
            backgroundColor: backgroundColor,
            primary: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(5))),
        onPressed: onPressed,
        child: Padding(
            padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
            child: Column(
              children: [
                title == ''
                    ? const SizedBox.shrink()
                    : Align(
                        alignment: Alignment.topLeft,
                        child: Text(
                          title!,
                          style: const TextStyle(
                              fontWeight: FontWeight.w400, fontSize: 10),
                        )),
                title == ''
                    ? const SizedBox.shrink()
                    : const SizedBox(height: 10),
                isIcon == false
                    ? Align(
                        alignment: alignment,
                        child: Text(
                          text!,
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Align(
                        alignment: alignment,
                        child: Icon(icon!),
                      ),
              ],
            )));
  }
}
