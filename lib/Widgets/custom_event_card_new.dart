import 'package:flutter/material.dart';

class CustomEventCard extends StatefulWidget {
  CustomEventCard({
    Key? key,
    required this.slug,
    required this.bgColor,
    required this.imageUrl,
    required this.eventType,
    required this.title,
    required this.description,
    required this.dateTime,
    // required this.address,
  }) : super(key: key);
  late String? slug = '';
  late int? bgColor = 0;
  late String? imageUrl = '';
  late String? eventType = '';
  late String? title = '';
  late String? description = '';
  late String? dateTime = '';
  late String? address = '';
  @override
  State<CustomEventCard> createState() => _CustomEventCardState();
}

class _CustomEventCardState extends State<CustomEventCard> {
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
        onTap: () {
          Navigator.pushReplacementNamed(context, '/custom_event_full',
              arguments: {'slug': widget.slug!});
        },
        child: Column(
          children: [
            Image.network(
              widget.imageUrl!,
              height: 200,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.eventType!,
                      style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Color(widget.bgColor!)),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                    child: Divider(
                      color: Colors.grey[600],
                    ),
                  ),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.title!,
                      style: const TextStyle(
                          fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      widget.description!,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey[600]),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Row(
                          children: [
                            Icon(
                              Icons.access_time_sharp,
                              color: Colors.purple[800],
                            ),
                            const SizedBox(width: 10.0),
                            Flexible(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(widget.dateTime!,
                                    style: TextStyle(
                                        color: Colors.purple[800],
                                        fontSize: 12.0,
                                        fontStyle: FontStyle.normal)),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Expanded(
                      //   child: Row(
                      //     children: [
                      //       Icon(
                      //         Icons.location_on,
                      //         color: Colors.purple[800],
                      //       ),
                      //       const SizedBox(width: 10.0),
                      //       Flexible(
                      //         child: Align(
                      //           alignment: Alignment.centerLeft,
                      //           child: Text('Lipa City Batangas Philippines',
                      //               maxLines: 1,
                      //               overflow: TextOverflow.ellipsis,
                      //               style: TextStyle(
                      //                   color: Colors.purple[800],
                      //                   fontSize: 12.0,
                      //                   fontStyle: FontStyle.normal)),
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    ));
  }
}
