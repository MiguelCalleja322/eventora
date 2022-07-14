import 'package:cached_network_image/cached_network_image.dart';
import 'package:eventora/controllers/events_controller.dart';
import 'package:flutter/material.dart';
import 'package:ionicons/ionicons.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:settings_ui/settings_ui.dart';

class CustomEventCard extends StatefulWidget {
  const CustomEventCard(
      {Key? key,
      required this.slug,
      required this.bgColor,
      required this.imageUrl,
      required this.eventType,
      required this.title,
      required this.description,
      required this.dateTime,
      this.isOptionsButton = false})
      : super(key: key);
  final String? slug;
  final int? bgColor;
  final String? imageUrl;
  final String? eventType;
  final String? title;
  final String? description;
  final String? dateTime;
  final bool? isOptionsButton;

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
          Navigator.pushNamed(context, '/custom_event_full', arguments: {
            'slug': widget.slug!,
          });
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
                                                                    'slug':
                                                                        widget
                                                                            .slug
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
                                                                (context) {
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

  void markAsPrivate(String slug) async {
    await EventController().markAsPrivate(slug);
  }

  void availability(String slug) async {
    await EventController().availability(slug);
  }

  void delete(String slug) async {
    await EventController().delete(slug);
  }
}
