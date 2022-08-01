// ignore_for_file: must_be_immutable

import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventora/controllers/events_controller.dart';
import 'package:eventora/controllers/user_preference_controller.dart';
import 'package:eventora/utils/custom_flutter_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:settings_ui/settings_ui.dart';

class CustomEventCard extends ConsumerStatefulWidget {
  CustomEventCard(
      {Key? key,
      this.role = '',
      this.slug = '',
      this.bgColor = 0,
      this.imageUrl = '',
      this.eventType = '',
      this.title = '',
      this.description = '',
      this.dateTime = '',
      this.eventCategory = '',
      this.model,
      this.scheduleStart,
      this.scheduleEnd,
      this.isOptionsButton = false})
      : super(key: key);
  final String? slug;
  final String? role;
  final int? bgColor;
  final String? imageUrl;
  final String? eventType;
  final String? title;
  final String? description;
  final String? dateTime;
  final bool? isOptionsButton;
  late DateTime? scheduleStart;
  late DateTime? scheduleEnd;
  final ProviderBase<dynamic>? model;
  final String? eventCategory;

  @override
  CustomEventCardState createState() => CustomEventCardState();
}

class CustomEventCardState extends ConsumerState<CustomEventCard> {
  void updateUserPreference(String eventCat) async {
    if (eventCat == '') {
      return;
    } else {
      await UserPreferenceController.store(eventCat);
    }
    return;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
        child: Card(
      elevation: 2,
      semanticContainer: true,
      clipBehavior: Clip.antiAliasWithSaveLayer,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      margin: const EdgeInsets.all(10),
      child: InkWell(
        onTap: () {
          if (widget.role == 'user') {
            Navigator.pushNamed(context, '/user_custom_event_full', arguments: {
              'slug': widget.slug!,
            });
          } else {
            updateUserPreference(widget.eventCategory!);
            Navigator.pushNamed(context, '/custom_event_full', arguments: {
              'slug': widget.slug!,
            });
          }
        },
        child: Column(
          children: [
            CachedNetworkImage(
              imageUrl: widget.imageUrl!,
              errorWidget: (context, url, error) => const Icon(Icons.error),
              height: 200,
              width: double.infinity,
              fit: BoxFit.fill,
            ),
            Padding(
              padding: const EdgeInsets.all(15.0),
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                      widget.isOptionsButton! == true
                          ? Align(
                              alignment: Alignment.centerRight,
                              child: TextButton(
                                  style: OutlinedButton.styleFrom(
                                      primary: Colors.grey[800],
                                      shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(10))),
                                  onPressed: () {
                                    showMaterialModalBottomSheet(
                                        context: context,
                                        builder: (BuildContext context) {
                                          return StatefulBuilder(builder:
                                              (BuildContext context,
                                                  StateSetter mystate) {
                                            return SingleChildScrollView(
                                              controller:
                                                  ModalScrollController.of(
                                                      context),
                                              child: SizedBox(
                                                child: Padding(
                                                  padding: const EdgeInsets.all(
                                                      15.0),
                                                  child: SettingsList(
                                                    lightTheme: const SettingsThemeData(
                                                        settingsListBackground:
                                                            Colors.transparent,
                                                        settingsSectionBackground:
                                                            Colors.transparent),
                                                    shrinkWrap: true,
                                                    sections: [
                                                      SettingsSection(
                                                        margin:
                                                            EdgeInsetsDirectional
                                                                .zero,
                                                        tiles: <SettingsTile>[
                                                          SettingsTile
                                                              .navigation(
                                                            onPressed:
                                                                (context) {
                                                              Navigator.pushNamed(
                                                                  context,
                                                                  '/update_event',
                                                                  arguments: {
                                                                    'slug': widget
                                                                        .slug,
                                                                    'title': widget
                                                                        .title,
                                                                    'description':
                                                                        widget
                                                                            .description,
                                                                    'scheduleStart':
                                                                        widget
                                                                            .scheduleStart,
                                                                    'scheduleEnd':
                                                                        widget
                                                                            .scheduleEnd
                                                                  });
                                                            },
                                                            leading: const Icon(
                                                                Ionicons
                                                                    .refresh),
                                                            title: const Text(
                                                                'Update'),
                                                          ),
                                                          SettingsTile
                                                              .navigation(
                                                            onPressed:
                                                                (context) async {
                                                              ref.refresh(widget
                                                                  .model!);
                                                              availability(
                                                                  widget.slug!);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            leading: const Icon(
                                                                Ionicons
                                                                    .close_outline),
                                                            title: const Text(
                                                                'Mark as Available / Unavailable'),
                                                          ),
                                                          SettingsTile
                                                              .navigation(
                                                            onPressed:
                                                                (context) {
                                                              ref.refresh(widget
                                                                  .model!);
                                                              markAsPrivate(
                                                                  widget.slug!);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            leading: const Icon(
                                                                Ionicons
                                                                    .lock_closed_outline),
                                                            title: const Text(
                                                                'Mark as Private / Not Private'),
                                                          ),
                                                          SettingsTile
                                                              .navigation(
                                                            onPressed:
                                                                (context) {
                                                              ref.refresh(widget
                                                                  .model!);
                                                              delete(
                                                                  widget.slug!);
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            leading: const Icon(
                                                                Ionicons
                                                                    .trash_bin_outline),
                                                            title: const Text(
                                                                'Delete'),
                                                          ),
                                                        ],
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ),
                                            );
                                          });
                                        });
                                  },
                                  child: const Icon(Ionicons.list_outline)),
                            )
                          : const SizedBox.shrink()
                    ],
                  ),
                  widget.role == 'organizer'
                      ? SizedBox(
                          height: 10,
                          child: Divider(
                            color: Colors.grey[600],
                          ),
                        )
                      : const SizedBox.shrink(),
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

  void markAsPrivate(String slug) async {
    Map<String, dynamic>? response =
        await EventController().markAsPrivate(slug);
    await CustomFlutterToast.showOkayToast(response!['message']);
  }

  void availability(String slug) async {
    Map<String, dynamic>? response = await EventController().availability(slug);

    await CustomFlutterToast.showOkayToast(response!['message']);
  }

  void delete(String slug) async {
    Map<String, dynamic>? response = await EventController().delete(slug);

    await CustomFlutterToast.showOkayToast(response!['message']);
  }
}
