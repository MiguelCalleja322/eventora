import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

class CustomCommentCard extends StatefulWidget {
  CustomCommentCard({
    Key? key,
    this.avatar = '',
    this.username = '',
    this.label = '',
    this.commentLikesCount = 0,
    this.id = 0,
  }) : super(key: key);

  late String? avatar;
  late String? username;
  late String? label;
  late int? commentLikesCount;
  late int? id;

  @override
  State<CustomCommentCard> createState() => _CustomCommentCardState();
}

class _CustomCommentCardState extends State<CustomCommentCard> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: Column(
        children: [
          OutlinedButton(
            onPressed: () {},
            onLongPress: () {},
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
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
                        width: 40,
                        height: 40,
                      ),
                    )),
                Expanded(
                    child: Padding(
                  padding: const EdgeInsets.fromLTRB(15, 0, 15, 0),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.username!,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14.0,
                                fontStyle: FontStyle.normal)),
                      ),
                      const SizedBox(height: 10.0),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(widget.label!,
                            style: TextStyle(
                                color: Colors.grey[700],
                                fontSize: 14.0,
                                fontStyle: FontStyle.normal)),
                      ),
                      const SizedBox(height: 10.0),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Align(
                              alignment: Alignment.bottomRight,
                              child: TextButton(
                                  style: TextButton.styleFrom(
                                      splashFactory: NoSplash.splashFactory,
                                      padding: EdgeInsets.zero,
                                      minimumSize: const Size(10, 10),
                                      tapTargetSize:
                                          MaterialTapTargetSize.shrinkWrap,
                                      alignment: Alignment.centerLeft),
                                  onPressed: () {},
                                  child: const Text('Like'))),
                          Text('No. of Likes: ${widget.commentLikesCount}',
                              style: TextStyle(
                                  color: Colors.grey[700],
                                  fontSize: 14.0,
                                  fontStyle: FontStyle.normal))
                        ],
                      ),
                    ],
                  ),
                )),
              ],
            ),
          ),
          SizedBox(
            child: Divider(
              color: Colors.grey[400],
              thickness: 0.5,
            ),
          ),
        ],
      ),
    );
  }
}
