import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomFeaturedEvents extends StatelessWidget {
  const CustomFeaturedEvents({
    Key? key,
    required this.imageUrl,
    required this.slug,
    required this.bgColor,
    required this.title,
    required this.scheduleStart,
  }) : super(key: key);

  final String? imageUrl;
  final String? slug;
  final int? bgColor;
  final String? title;
  final String? scheduleStart;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(0.0),
          border: Border.all(width: 0.0, style: BorderStyle.none)),
      child: OutlinedButton(
        style: OutlinedButton.styleFrom(
            primary: Colors.transparent,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10))),
        onPressed: () {
          Navigator.pushNamed(context, '/custom_event_full', arguments: {
            'bgColor': bgColor,
            'slug': slug,
            'title': title,
            'scheduleStart': scheduleStart,
          });
        },
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 0, 10),
          child: Row(
            children: <Widget>[
              DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(width: 0, style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: CachedNetworkImage(
                      imageUrl: imageUrl!,
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                      width: 75,
                      height: 75,
                    ),
                  )),
              const SizedBox(width: 10.0),
              Expanded(
                  child: SizedBox(
                height: 75,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      border: Border.all(
                          color: Color(bgColor!),
                          width: 1.5,
                          style: BorderStyle.solid),
                      borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(title!,
                              overflow: TextOverflow.ellipsis,
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14.0,
                                  fontStyle: FontStyle.normal)),
                        ),
                        const SizedBox(height: 10.0),
                        Row(
                          children: [
                            Icon(
                              Icons.access_time_sharp,
                              color: Colors.grey[500],
                            ),
                            const SizedBox(width: 10.0),
                            Flexible(
                              child: Align(
                                alignment: Alignment.centerLeft,
                                child: Text(scheduleStart!,
                                    style: TextStyle(
                                        color: Colors.grey[700],
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
              )),
            ],
          ),
        ),
      ),
    );
  }
}
