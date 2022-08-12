// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventora/controllers/notifications_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CustomNotificationCard extends ConsumerStatefulWidget {
  CustomNotificationCard({
    Key? key,
    this.username = '',
    this.name = '',
    this.avatar = '',
    this.eventSlug = '',
    this.createdAt = '',
    this.label = '',
    this.isRead = 0,
    this.id = 0,
  }) : super(key: key);
  String? username;
  String? name;
  String? avatar;
  String? eventSlug;
  String? createdAt;
  String? label;
  int? isRead;
  int? id;
  @override
  CustomNotificationCardState createState() => CustomNotificationCardState();
}

class CustomNotificationCardState
    extends ConsumerState<CustomNotificationCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlinedButton(
          style: OutlinedButton.styleFrom(
              backgroundColor:
                  widget.isRead == 0 ? Colors.grey[200] : Colors.transparent,
              primary: Colors.transparent,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10))),
          onPressed: () {
            read();
          },
          child: Row(
            children: [
              DecoratedBox(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(100),
                    child: CachedNetworkImage(
                      imageUrl: widget.avatar! != ''
                          ? widget.avatar!
                          : 'https://yt3.ggpht.com/ytc/AMLnZu9aYRtojYe75GWRc-gyWL9Je6ezH_unHTZBHWN7OA=s900-c-k-c0x00ffffff-no-rj',
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
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
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: Padding(
                    padding: const EdgeInsets.all(10.0),
                    child: Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Text(widget.label!,
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
                                child: Text(widget.createdAt!,
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
        const SizedBox(
          height: 10,
        )
      ],
    );
  }

  void read() {
    if (widget.isRead == 0) {
      setState(() {
        widget.isRead = 1;
      });

      NotificationsController.read(widget.id!);
    }

    if (widget.eventSlug == null) {
      Navigator.pushNamed(context, '/other_profile',
          arguments: {'username': widget.username});
    } else {
      Navigator.pushNamed(context, '/custom_event_full', arguments: {
        'slug': widget.eventSlug!,
      });
    }
  }
}
