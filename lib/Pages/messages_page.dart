import 'dart:convert';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

import '../utils/helpers.dart';

class MessagesPage extends StatefulWidget {
  const MessagesPage({Key? key}) : super(key: key);

  @override
  State<MessagesPage> createState() => _MessagesPageState();
}

class _MessagesPageState extends State<MessagesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: Scrollbar(
          // controller: scrollController,
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
            child:
                // SmartRefresher(
                //   controller: _refreshController,
                //   enablePullDown: false,
                //   enablePullUp: true,
                //   onLoading: () async {
                //     await controller.loadOlderMessages();
                //     _refreshController.loadComplete();
                //   },
                //   child:
                ListView.builder(
                    reverse: true,
                    // controller: scrollController,
                    itemCount: 5,
                    itemBuilder: (context, index) {
                      final reversedIndex = 5 - 1 - index;
                      final Map<String, dynamic> message = {};
                      // controller.messages[reversedIndex];
                      bool nextSenderIsMe = false;
                      bool previousSenderIsMe = false;
                      bool lastMessage = false;
                      int nextIndex = reversedIndex + 1;
                      int previousIndex = reversedIndex - 1;
                      // if (nextIndex < controller.messages.length) {
                      //   nextSenderIsMe = controller.messages[nextIndex]
                      //           ['user_id'] ==
                      //       currentUser?.id;
                      // } else {
                      //   lastMessage = true;
                      // }

                      // if (previousIndex >= 0) {
                      //   previousSenderIsMe = controller
                      //           .messages[previousIndex]['user_id'] ==
                      //       currentUser?.id;
                      // }
                      return Container(
                        padding:
                            EdgeInsets.only(top: reversedIndex == 0 ? 15.0 : 0),
                        child: ChatBubble(
                          message: message,
                          isMe: true,
                          nextSenderIsMe: nextSenderIsMe,
                          lastMessage: lastMessage,
                          previousSenderIsMe: previousSenderIsMe,
                          goToPostMessage:
                              message['type'] == 'post' ? () {} : null,
                        ),
                      );
                    }),
          ),
        ),
      ),
    );
  }
}

class ChatBubble extends StatelessWidget {
  final Map<String, dynamic> message;
  final bool isMe;
  final bool previousSenderIsMe;
  final bool nextSenderIsMe;
  final bool lastMessage;
  final VoidCallback? goToPostMessage;
  final double? progress;
  const ChatBubble({
    Key? key,
    required this.message,
    required this.isMe,
    required this.nextSenderIsMe,
    required this.previousSenderIsMe,
    required this.lastMessage,
    this.goToPostMessage,
    this.progress,
  }) : super(key: key);
  // final
  @override
  Widget build(BuildContext context) {
    final bool isEmoji = Helpers.isEmoji(message['message']);
    final bool isDeleted = message['deleted_at'] != null;
    if (isDeleted == true) {
      message['message'] = 'Message deleted';
      message['type'] = 'text';
      message['link_preview'] = null;
    }

    BorderRadius? borderRadius = isMe
        ? BorderRadius.only(
            bottomLeft: Radius.circular(25),
            bottomRight:
                nextSenderIsMe ? Radius.circular(3) : Radius.circular(25),
            topLeft: Radius.circular(25),
            topRight:
                previousSenderIsMe ? Radius.circular(3) : Radius.circular(25),
          )
        : BorderRadius.only(
            bottomLeft: lastMessage
                ? Radius.circular(25)
                : nextSenderIsMe == false
                    ? Radius.circular(3)
                    : Radius.circular(25),
            bottomRight: Radius.circular(25),
            topRight: Radius.circular(25),
            topLeft: previousSenderIsMe == false
                ? Radius.circular(3)
                : Radius.circular(25),
          );
    return AbsorbPointer(
      absorbing: isDeleted || message['pending'] == true,
      child: Opacity(
        opacity: isDeleted || message['pending'] == true ? 0.5 : 1,
        child: Container(
          margin: isMe
              ? EdgeInsets.only(
                  right: 5,
                  bottom: nextSenderIsMe ? 2 : 15,
                )
              : EdgeInsets.only(
                  left: 5,
                  bottom: lastMessage
                      ? 15
                      : nextSenderIsMe
                          ? 15
                          : 2),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                mainAxisAlignment:
                    isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Flexible(
                    child: PhysicalModel(
                      color: Colors.transparent,
                      clipBehavior: Clip.hardEdge,
                      borderRadius: borderRadius,
                      child: Material(
                        color: Colors.white,
                        child: Ink(
                          decoration: BoxDecoration(
                            color: message['type'] == 'text'
                                ? isEmoji
                                    ? Colors.transparent
                                    : isMe
                                        ? Theme.of(context).primaryColor
                                        : const Color(0xFFedeff5)
                                : const Color(0xFFedeff5),
                            borderRadius: borderRadius,
                          ),
                          child: InkWell(
                            onLongPress: () {
                              // HapticFeedback.mediumImpact();
                              // messageActions(context, message);
                            },
                            customBorder: RoundedRectangleBorder(
                                borderRadius: borderRadius),
                            onTap: () => {},
                            child: Container(
                              constraints: BoxConstraints(maxWidth: 260),
                              padding: message['type'] == 'text'
                                  ? isEmoji
                                      ? const EdgeInsets.all(0)
                                      : message['link_preview'] != null
                                          ? const EdgeInsets.all(0)
                                          : const EdgeInsets.symmetric(
                                              horizontal: 15, vertical: 10)
                                  : null,
                              child: messageCard(
                                message,
                                context,
                                isEmoji,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
              // lastMessage && isMe && message['is_read'] == true
              //     ? Icon(FeatherIcons.eye, size: 13)
              //     : SizedBox.shrink(),
            ],
          ),
        ),
      ),
    );
  }

  Widget messageCard(
      Map<String, dynamic> message, BuildContext context, bool isEmoji) {
    if (message['type'] == 'text') {
      // if (message['link_preview'] != null) {
      //   Map<String, dynamic> linkPreview = {};
      //   if (message['link_preview'] is String) {
      //     linkPreview = jsonDecode(message['link_preview']);
      //   } else {
      //     linkPreview = message['link_preview'];
      //   }
      //   final uri = Uri.parse(linkPreview['url']);
      //   return Column(
      //     crossAxisAlignment: CrossAxisAlignment.start,
      //     children: [
      //       Padding(
      //         padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      //         child: Linkify(
      //           text: message['message'],
      //           options: LinkifyOptions(humanize: false),
      //           onOpen: (link) => _launchURL(link.url),
      //           linkStyle: TextStyle(
      //               fontSize: 15,
      //               fontWeight: FontWeight.w500,
      //               color: isMe ? Colors.white : Colors.black),
      //           style: TextStyle(
      //               fontSize: 15,
      //               fontWeight: FontWeight.w500,
      //               color: isMe ? Colors.white : Colors.black),
      //         ),
      //       ),
      //       GestureDetector(
      //         onTap: () => {_launchURL(linkPreview['url'])},
      //         child: Column(
      //           children: [
      //             CachedNetworkImage(
      //               imageUrl: linkPreview['image'],
      //               height: 130,
      //               width: double.infinity,
      //               fit: BoxFit.cover,
      //               fadeInDuration: Duration(seconds: 0),
      //               fadeOutDuration: Duration(seconds: 0),
      //               errorWidget: (context, error, _) {
      //                 return Container(
      //                   color: Colors.grey[300],
      //                   alignment: Alignment.center,
      //                   child: Text('Failed to load image.',
      //                       style:
      //                           TextStyle(fontSize: 15, color: Colors.black54)),
      //                 );
      //               },
      //               placeholder: (context, url) {
      //                 return Center(
      //                   child: SizedBox(),
      //                 );
      //               },
      //             ),
      //             Container(
      //               color: Colors.grey[200],
      //               width: double.infinity,
      //               padding: const EdgeInsets.symmetric(
      //                   horizontal: 13, vertical: 10),
      //               child: Column(
      //                 crossAxisAlignment: CrossAxisAlignment.start,
      //                 children: [
      //                   Text(
      //                     linkPreview['title'],
      //                     maxLines: 2,
      //                     overflow: TextOverflow.ellipsis,
      //                     style: TextStyle(
      //                         fontSize: 15,
      //                         height: 1.2,
      //                         fontWeight: FontWeight.bold,
      //                         color: Colors.black87),
      //                   ),
      //                   SizedBox(
      //                     height: 5,
      //                   ),
      //                   Text(
      //                     uri.host,
      //                     style:
      //                         TextStyle(fontSize: 13.5, color: Colors.black54),
      //                   )
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //       )
      //     ],
      //   );
      // }
      return Text(
        message['message'],
        style: TextStyle(
          fontSize: isEmoji ? 60 : 16,
          height: 1.2,
          fontWeight: FontWeight.w500,
          color: isMe ? Colors.white : Colors.black87,
        ),
      );
    } else if (message['type'] == 'photo') {
      Map<String, dynamic>? metadata;
      if (message['metadata'] is String) {
        metadata = jsonDecode(message['metadata']);
      } else {
        metadata = message['metadata'];
      }
      Widget heroImage = message['thumbnail'] != null
          ? Stack(
              children: [
                message['preview'] != null
                    ? Image.file(message['preview'])
                    : SizedBox.shrink(),
                message['thumbnail'] is String
                    ? CachedNetworkImage(
                        imageUrl: message['thumbnail'],
                        fadeInDuration: Duration(seconds: 0),
                        placeholderFadeInDuration: Duration(seconds: 0),
                        fadeOutDuration: Duration(seconds: 0),
                        placeholder: (context, url) => Container(
                          decoration: BoxDecoration(
                              image: DecorationImage(
                                  image: CachedNetworkImageProvider(
                                      message['thumbnail']))),
                          child: CachedNetworkImage(
                            imageUrl: message['thumbnail'],
                            fadeInDuration: Duration(seconds: 0),
                            placeholderFadeInDuration: Duration(seconds: 0),
                            fadeOutDuration: Duration(seconds: 0),
                            fit: BoxFit.cover,
                            width: double.infinity,
                          ),
                        ),
                        width: double.infinity,
                        errorWidget: (context, error, _) {
                          return Container(
                            color: Colors.grey[300],
                            alignment: Alignment.center,
                            child: Text(
                              'Failed to load content.',
                              style: TextStyle(
                                  fontSize: 15, color: Colors.black54),
                            ),
                          );
                        },
                      )
                    : SizedBox.shrink(),
              ],
            )
          : Container();
    }
    return Container(
      child: Container(),
    );
  }

  // void _launchURL(url) async =>
  //     await canLaunch(url) ? await launch(url) : throw 'Could not launch $url';

}
