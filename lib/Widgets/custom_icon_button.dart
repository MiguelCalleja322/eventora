import 'package:flutter/material.dart';

class CustomIconButton extends StatelessWidget {
  const CustomIconButton(
      {Key? key, required this.icon, required this.onPressed})
      : super(key: key);
  final IconData icon;
  final VoidCallback onPressed;
  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      style: OutlinedButton.styleFrom(
          side: const BorderSide(width: 0, color: Colors.transparent),
          primary: Colors.grey[700],
          backgroundColor: Colors.transparent,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(5.0)))),
      onPressed: onPressed,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(0, 15, 0, 15),
        child: Icon(
          icon,
          size: 20,
          color: Colors.grey[700],
        ),
      ),
    );
  }
}
