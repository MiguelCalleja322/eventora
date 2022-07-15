import 'package:eventora/controllers/note_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../Widgets/custom_appbar.dart';

class CreateAndListNotes extends StatefulWidget {
  const CreateAndListNotes({Key? key}) : super(key: key);

  @override
  State<CreateAndListNotes> createState() => _CreateAndListNotesState();
}

class _CreateAndListNotesState extends State<CreateAndListNotes> {
  late Map<String, dynamic>? notesData = {};
  late List<dynamic>? notes = [];
  late bool? loading = false;
  Future<void> fetchNotes() async {
    setState(() {
      loading = true;
    });

    notesData = await NoteController().index() ?? {};

    if (notesData!.isNotEmpty) {
      setState(() {
        notes = notesData!['notes'];
      });
    }

    setState(() {
      loading = false;
    });
  }

  void deleteNote(int? id) async {
    await NoteController().delete(id!);

    setState(() {
      notes = [];
      notesData = {};
    });

    await fetchNotes();
  }

  @override
  void initState() {
    fetchNotes();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'List Notes',
        customBackArrowFunc: () {
          Navigator.pushNamed(context, '/home');
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.pushNamed(context, '/create_notes');
        },
        backgroundColor: Colors.grey[850],
        child: const Icon(
          Icons.note_add_outlined,
          color: Colors.white,
        ),
      ),
      body: loading! == true
          ? Center(
              child: SpinKitCircle(
                size: 50.0,
                color: Colors.grey[700],
              ),
            )
          : notes!.isEmpty
              ? const Align(
                  alignment: Alignment.center,
                  child: Text(
                    'No Notes Created',
                    style: TextStyle(fontSize: 23, color: Colors.black54),
                  ))
              : RefreshIndicator(
                  onRefresh: () => fetchNotes(),
                  child: SafeArea(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.all(10),
                        child: Column(
                          children: <Widget>[
                            StaggeredGrid.count(
                              crossAxisCount: 4,
                              children: List.generate(notes!.length, (index) {
                                return StaggeredGridTile.fit(
                                    crossAxisCellCount: 2,
                                    child: Card(
                                      surfaceTintColor: const Color.fromARGB(
                                          0, 130, 130, 130),
                                      elevation: 5,
                                      semanticContainer: true,
                                      clipBehavior: Clip.antiAliasWithSaveLayer,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                      ),
                                      margin: const EdgeInsets.all(10),
                                      child: InkWell(
                                        onLongPress: () {
                                          showMaterialModalBottomSheet(
                                              context: context,
                                              builder: (BuildContext context) {
                                                return StatefulBuilder(builder:
                                                    (BuildContext context,
                                                        StateSetter mystate) {
                                                  return SingleChildScrollView(
                                                    controller:
                                                        ModalScrollController
                                                            .of(context),
                                                    child: SizedBox(
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                .all(15.0),
                                                        child: SettingsList(
                                                          shrinkWrap: true,
                                                          sections: [
                                                            SettingsSection(
                                                              tiles: <
                                                                  SettingsTile>[
                                                                SettingsTile
                                                                    .navigation(
                                                                  onPressed:
                                                                      (context) {
                                                                    deleteNote(notes![
                                                                            index]
                                                                        ['id']);

                                                                    Navigator.pop(
                                                                        context);
                                                                  },
                                                                  leading:
                                                                      const Icon(
                                                                          Icons
                                                                              .delete),
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
                                        onTap: () {
                                          Navigator.pushNamed(
                                              context, '/read_note',
                                              arguments: {
                                                'title': notes![index]['title'],
                                                'description': notes![index]
                                                    ['description'],
                                              });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  notes![index]['title'],
                                                  style: const TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold),
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
                                                  notes![index]['description'],
                                                  maxLines: 10,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                  style: const TextStyle(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w500),
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ));
                              }),
                            ),

                            // GridView.builder(
                            //     shrinkWrap: true,
                            //     physics: const NeverScrollableScrollPhysics(),
                            //     gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                            //       maxCrossAxisExtent: 200,
                            //       mainAxisSpacing: 5.0,
                            //       crossAxisSpacing: 5.0,
                            //     ),
                            //     clipBehavior: Clip.none,
                            //     itemCount: 10,
                            //     itemBuilder: (BuildContext context, int index) {
                            //       return SizedBox(
                            //         child: Card(
                            //           surfaceTintColor: Color.fromARGB(0, 130, 130, 130),
                            //           elevation: 5,
                            //           semanticContainer: true,
                            //           clipBehavior: Clip.antiAliasWithSaveLayer,
                            //           shape: RoundedRectangleBorder(
                            //             borderRadius: BorderRadius.circular(10.0),
                            //           ),
                            //           margin: const EdgeInsets.all(10),
                            //           child: InkWell(
                            //             onTap: () {
                            //               () {};
                            //             },
                            //             child: Padding(
                            //               padding: const EdgeInsets.all(10),
                            //               child: Column(
                            //                 children: [
                            //                   const Align(
                            //                     alignment: Alignment.centerLeft,
                            //                     child: Text(
                            //                       'test',
                            //                       style: TextStyle(
                            //                           fontSize: 16,
                            //                           fontWeight: FontWeight.bold),
                            //                     ),
                            //                   ),
                            //                   SizedBox(
                            //                     height: 10,
                            //                     child: Divider(
                            //                       color: Colors.grey[600],
                            //                     ),
                            //                   ),
                            //                   const Align(
                            //                     alignment: Alignment.centerLeft,
                            //                     child: Text(
                            //                       "Lorem Ipsum is simply dummy text of the printing and typesetting industry. Lorem Ipsum has been the industry's standard dummy text ever since the 1500s, when an unknown printer took a galley of type and scrambled it to make a type specimen book. It has survived not only five centuries, but also the leap into electronic typesetting, remaining essentially unchanged. It was popularised in the 1960s with the release of Letraset sheets containing Lorem Ipsum passages, and more recently with desktop publishing software like Aldus PageMaker including versions of Lorem Ipsum.",
                            //                       maxLines: 10,
                            //                       overflow: TextOverflow.ellipsis,
                            //                       style: TextStyle(
                            //                           fontSize: 14,
                            //                           fontWeight: FontWeight.w500),
                            //                     ),
                            //                   ),
                            //                 ],
                            //               ),
                            //             ),
                            //           ),
                            //         ),
                            //       );
                            //     }),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
    );
  }
}
