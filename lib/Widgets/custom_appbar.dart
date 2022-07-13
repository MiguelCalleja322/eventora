import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  // ignore: prefer_const_constructors_in_immutables
  CustomAppBar(
      {Key? key,
      this.height = 70,
      required this.title,
      this.customBackArrowFunc,
      this.hideBackButton = false})
      : super(key: key);
  final double height;
  final String title;
  final VoidCallback? customBackArrowFunc;
  final bool hideBackButton;
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 2.5, color: Colors.grey[200]!))),
      child: PreferredSize(
        preferredSize: preferredSize,
        child: AppBar(
          centerTitle: false,
          automaticallyImplyLeading: false,
          surfaceTintColor: Colors.white,
          backgroundColor: Colors.white,
          title: Text(
            title,
            style: TextStyle(color: Colors.grey[800], fontSize: 30.0),
          ),
          actions: [
            hideBackButton
                ? const SizedBox.shrink()
                : OutlinedButton(
                    style: OutlinedButton.styleFrom(
                        side: const BorderSide(
                            width: 0, color: Colors.transparent),
                        primary: Colors.grey[700],
                        backgroundColor: Colors.transparent,
                        shape: const RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(5.0)))),
                    onPressed: customBackArrowFunc ??
                        () {
                          Navigator.pop(context);
                        },
                    child: const Icon(
                      Icons.chevron_left,
                      size: 30,
                    ),
                  ),
          ],
        ),
      ),
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}
