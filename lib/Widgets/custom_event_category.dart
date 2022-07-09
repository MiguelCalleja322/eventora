import 'package:flutter/material.dart';

class CustomEventCategory extends StatelessWidget {
  CustomEventCategory({
    Key? key,
    required this.type,
  }) : super(key: key);

  late String? type = '';

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Card(
        semanticContainer: true,
        clipBehavior: Clip.antiAliasWithSaveLayer,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        margin: const EdgeInsets.all(10),
        child: InkWell(
          onTap: () {},
          child: Column(
            children: [
              Image.asset(
                'assets/images/event_categories/$type.jpg',
                height: 110,
                width: double.infinity,
                fit: BoxFit.fill,
              ),
              const SizedBox(
                height: 10,
              ),
              SizedBox(
                child: Text(
                  type!,
                  style: const TextStyle(fontSize: 16),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
