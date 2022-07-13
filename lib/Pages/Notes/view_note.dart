import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:flutter/material.dart';

class ShowNote extends StatelessWidget {
  const ShowNote({
    Key? key,
    required this.title,
    required this.description,
  }) : super(key: key);

  final String? title;
  final String? description;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Note',
        hideBackButton: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: SingleChildScrollView(
            child: Column(
              children: [
                Text(
                  title!,
                  style: const TextStyle(
                      fontSize: 25, fontWeight: FontWeight.w500),
                ),
                const SizedBox(height: 15),
                Text(
                  description!,
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
