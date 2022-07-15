import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ViewTask extends StatelessWidget {
  const ViewTask({Key? key, this.title, this.description, this.dateTime})
      : super(key: key);
  final String? title;
  final String? description;
  final String? dateTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Task',
        hideBackButton: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Align(
                  alignment: Alignment.center,
                  child: Text(
                    title!,
                    style: const TextStyle(
                        fontSize: 25, fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 15),
                Text(
                  description!,
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 20),
                Text(
                  'Date: ${dateTime!}',
                  style: const TextStyle(
                      fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
