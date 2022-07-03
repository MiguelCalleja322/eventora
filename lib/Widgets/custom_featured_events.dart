import 'package:flutter/material.dart';

class CustomFeaturedEvents extends StatelessWidget {
  CustomFeaturedEvents({
    Key? key,
  }) : super(key: key);

  late String imageUrl = '';
  late String title = '';
  late String schedule = '';

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
        children: <Widget>[
          SizedBox(
              height: 75,
              width: 75,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: Image.network(
                    'https://pyxis.nymag.com/v1/imgs/7aa/21a/c1de2c521f1519c6933fcf0d08e0a26fef-27-spongebob-squarepants.rsquare.w700.jpg'),
              )),
          const SizedBox(width: 10.0),
          Expanded(
              child: SizedBox(
            height: 75,
            child: DecoratedBox(
              decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.cyan, width: 1.5, style: BorderStyle.solid),
                  borderRadius: BorderRadius.circular(10)),
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: <Widget>[
                    const Align(
                      alignment: Alignment.centerLeft,
                      child: Text('Qatar Travel Mart - QTM2020',
                          style: TextStyle(
                              fontSize: 12.0, fontStyle: FontStyle.normal)),
                    ),
                    const SizedBox(height: 10.0),
                    Row(
                      children: [
                        Icon(
                          Icons.access_time_filled_sharp,
                          color: Colors.grey[500],
                        ),
                        const SizedBox(width: 10.0),
                        const Flexible(
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text('Thu, 16th Sep 2021 10:00am',
                                style: TextStyle(
                                    fontSize: 12.0,
                                    fontStyle: FontStyle.normal)),
                          ),
                        ),
                      ],
                    )
                  ],
                ),
              ),
            ),
          ))
        ],
      ),
    );
  }
}
