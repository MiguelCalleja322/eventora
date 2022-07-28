import 'package:eventora/Widgets/custom_icon_button.dart';
import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppBar(
      {Key? key,
      this.height = 70,
      this.title,
      this.customBackArrowFunc,
      this.hideSearchBar = true,
      this.hideBackButton = false})
      : super(key: key);

  final double? height;
  final String? title;
  final VoidCallback? customBackArrowFunc;
  final bool? hideBackButton;
  final bool? hideSearchBar;

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(height!);
}

class _CustomAppBarState extends State<CustomAppBar> {
  final TextEditingController _titleController = TextEditingController();
  final FocusNode _titleNode = FocusNode();
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          border:
              Border(bottom: BorderSide(width: 2.5, color: Colors.grey[200]!))),
      child: Column(
        children: [
          PreferredSize(
            preferredSize: widget.preferredSize,
            child: AppBar(
              centerTitle: false,
              automaticallyImplyLeading: false,
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              title: Text(
                widget.title!,
                style: TextStyle(color: Colors.grey[800], fontSize: 30.0),
              ),
              actions: [
                widget.hideBackButton! == true
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
                        onPressed: widget.customBackArrowFunc ??
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
          widget.hideSearchBar == true
              ? const SizedBox.shrink()
              : Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                    child: CustomTextField(
                      onChanged: (value) => value,
                      textAlign: TextAlign.left,
                      maxLine: 1,
                      suffixIcon: CustomIconButton(
                          icon: Ionicons.search_outline,
                          onPressed: () {
                            search();
                          }),
                      focusNode: _titleNode,
                      letterSpacing: 1.0,
                      controller: _titleController,
                    ),
                  ),
                ),
        ],
      ),
    );
  }

  void search() {
    if (_titleController.text.isEmpty) {
      return _titleNode.requestFocus();
    }

    Navigator.pushNamed(context, '/search',
        arguments: {'title': _titleController.text});
  }
}
