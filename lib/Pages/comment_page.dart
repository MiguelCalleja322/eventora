// ignore_for_file: must_be_immutable

import 'package:eventora/Widgets/custom_appbar.dart';
import 'package:eventora/Widgets/custom_comment_card.dart';
import 'package:eventora/Widgets/custom_icon_button.dart';
import 'package:eventora/Widgets/custom_textfield.dart';
import 'package:eventora/controllers/comment_controller.dart';
import 'package:eventora/models/comment.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:ionicons/ionicons.dart';

class CommentPage extends ConsumerStatefulWidget {
  CommentPage({Key? key, this.slug = ''}) : super(key: key);

  late String slug;

  @override
  CommentPageState createState() => CommentPageState();
}

class CommentPageState extends ConsumerState<CommentPage> {
  late TextEditingController labelController = TextEditingController();
  late FocusNode labelNode = FocusNode();
  late AutoDisposeFutureProvider commentProvider;
  late bool? loading = false;
  late List<dynamic> commentsList = [];
  late String? cloudFrontUri = '';

  void fetchCloudFrontUri() async {
    await dotenv.load(fileName: ".env");
    setState(() {
      cloudFrontUri = dotenv.env['CLOUDFRONT_URI'];
    });
  }

  void fetchComments() {
    setState(() {
      loading = true;
    });

    commentProvider = FutureProvider.autoDispose<Comments?>((ref) {
      return CommentController.index(widget.slug);
    });

    setState(() {
      loading = false;
    });
  }

  @override
  void initState() {
    fetchCloudFrontUri();
    fetchComments();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final comments = ref.watch(commentProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Comments',
        hideBackButton: true,
      ),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async => ref.refresh(commentProvider),
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  CustomTextField(
                    onChanged: (value) => value,
                    textAlign: TextAlign.left,
                    letterSpacing: 1.0,
                    label: 'Comment',
                    controller: labelController,
                    focusNode: labelNode,
                    suffixIcon: CustomIconButton(
                        icon: Ionicons.checkmark_done,
                        onPressed: () {
                          store();
                        }),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  SizedBox(
                    child: Divider(
                      color: Colors.grey[400],
                      thickness: 0.5,
                    ),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  comments.when(
                      data: (comment) {
                        commentsList = comment.comments;

                        return ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: commentsList.length,
                            itemBuilder: (context, index) {
                              return CustomCommentCard(
                                avatar:
                                    '$cloudFrontUri${commentsList[index].user.avatar}',
                                username: commentsList[index].user.username,
                                label: commentsList[index].label,
                                id: commentsList[index].id,
                                commentLikesCount:
                                    commentsList[index].commentLikesCount,
                              );
                            });
                      },
                      error: (_, __) => const Align(
                          alignment: Alignment.center,
                          child: Text(
                            'No Comments',
                            style:
                                TextStyle(fontSize: 23, color: Colors.black54),
                          )),
                      loading: () => Center(
                            child: SpinKitCircle(
                              size: 50.0,
                              color: Colors.grey[700],
                            ),
                          ))
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  void store() async {
    if (labelController.text.isEmpty == true) {
      labelNode.requestFocus();
      return;
    }

    Map<String, dynamic> commentData = {
      'event_slug': widget.slug,
      'label': labelController.text
    };

    Map<String, dynamic> response = await CommentController.store(commentData);

    if (response['message'] != null) {
      CustomFlutterToast.showErrorToast(response['message']);
    } else {
      CustomFlutterToast.showOkayToast(response['comment']);
    }
  }

  void delete(int id) async {
    Map<String, dynamic> response = await CommentController.delete(id);

    if (response['message'] != null) {
      CustomFlutterToast.showErrorToast(response['message']);
    } else {
      CustomFlutterToast.showOkayToast(response['comment']);
    }
  }
}
