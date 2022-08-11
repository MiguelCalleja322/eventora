import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomNotificationCard extends ConsumerStatefulWidget {
  const CustomNotificationCard({Key? key}) : super(key: key);

  @override
  CustomNotificationCardState createState() => CustomNotificationCardState();
}

class CustomNotificationCardState
    extends ConsumerState<CustomNotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: CachedNetworkImage(
                imageUrl:
                    'https://yt3.ggpht.com/ytc/AMLnZu9aYRtojYe75GWRc-gyWL9Je6ezH_unHTZBHWN7OA=s900-c-k-c0x00ffffff-no-rj',
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
                width: 50,
                height: 50,
              ),
            )),
        const SizedBox(width: 10.0),
        Expanded(
            child: SizedBox(
          height: 75,
          child: DecoratedBox(
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(10)),
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Column(
                children: <Widget>[
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text('Liza Soberano followed you',
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
                          child: Text('schedule here',
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
    );
  }
}
