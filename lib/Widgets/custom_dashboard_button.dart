import 'package:flutter/material.dart';

class CustomDashboardButton extends StatelessWidget {
  CustomDashboardButton({
    Key? key,
    required this.height,
    required this.width,
    required this.backgroundColor,
    required this.borderRadius,
    required this.onPressed,
    required this.padding,
    required this.alignment,
    this.letterSpacing,
    this.fontSize,
    this.color,
    this.fontWeight,
    required this.text,
    required this.fit,
    required this.elevation,
  }) : super(key: key);

  final double? height;
  final double? width;
  final Color? backgroundColor;
  final BorderRadius borderRadius;
  final VoidCallback onPressed;
  final EdgeInsetsGeometry padding;
  final AlignmentGeometry alignment;
  final double? letterSpacing;
  final double? fontSize;
  final Color? color;
  final FontWeight? fontWeight;
  final String text;
  final BoxFit fit;
  final double elevation;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: height,
      width: width,
      child: FittedBox(
        fit: fit,
        child: Material(
          shape: RoundedRectangleBorder(borderRadius: borderRadius),
          elevation: elevation,
          color: backgroundColor,
          child: MaterialButton(
              onPressed: onPressed,
              child: Padding(
                padding: padding,
                child: Column(
                  children: [
                    Align(
                      alignment: alignment,
                      child: Text(
                        text,
                        style: TextStyle(
                          letterSpacing: letterSpacing,
                          fontSize: fontSize,
                          color: color,
                          fontWeight: fontWeight,
                        ),
                      ),
                    )
                  ],
                ),
              )),
        ),
      ),
    );
  }
}
