import 'package:eventora/controllers/note_controller.dart';
import 'package:eventora/models/notes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:settings_ui/settings_ui.dart';

import '../../Widgets/custom_appbar.dart';

class CreateAndListNotes extends ConsumerStatefulWidget {
  const CreateAndListNotes({Key? key}) : super(key: key);

  @override
  CreateAndListNotesState createState() => CreateAndListNotesState();
}

final notesProvider = FutureProvider.autoDispose<Notes?>((ref) {
  return NoteController.index();
});

class CreateAndListNotesState extends ConsumerState<CreateAndListNotes> {
  late List<dynamic>? notes = [];
  late bool? loading = false;

  void deleteNote(int? id) async {
    await NoteController().delete(id!);
    ref.refresh(notesProvider);
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final noteData = ref.watch(notesProvider);
    return Scaffold(
        appBar: CustomAppBar(title: 'List Notes'),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.popAndPushNamed(context, '/create_notes');
          },
          backgroundColor: Colors.grey[850],
          child: const Icon(
            Icons.note_add_outlined,
            color: Colors.white,
          ),
        ),
        body: SafeArea(
          child: RefreshIndicator(
            onRefresh: () async {
              ref.refresh(notesProvider);
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: noteData.when(
                  data: (notes) {
                    notes = notes;
                    return notes == null
                        ? const Center(
                            child: Text(
                              'No Notes Created',
                              style: TextStyle(
                                  fontSize: 23, color: Colors.black54),
                            ),
                          )
                        : SingleChildScrollView(
                            child: StaggeredGrid.count(
                              crossAxisCount: 4,
                              children:
                                  List.generate(notes.notes!.length, (index) {
                                final Note note = notes!.notes![index];
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
                                                                    deleteNote(
                                                                        note.id);

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
                                                'title': note.title,
                                                'description': note.description,
                                              });
                                        },
                                        child: Padding(
                                          padding: const EdgeInsets.all(10),
                                          child: Column(
                                            children: [
                                              Align(
                                                alignment: Alignment.centerLeft,
                                                child: Text(
                                                  note.title,
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
                                                  note.description,
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
                          );
                  },
                  error: (_, __) => const Align(
                      alignment: Alignment.center,
                      child: Text(
                        'No Notes Created',
                        style: TextStyle(fontSize: 23, color: Colors.black54),
                      )),
                  loading: () => Center(
                        child: SpinKitCircle(
                          size: 50.0,
                          color: Colors.grey[700],
                        ),
                      )),
            ),
          ),
        ));
  }
}
