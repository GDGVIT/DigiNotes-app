import 'package:flutter/material.dart';
import 'package:diginotes_app/src/utils/details.dart';
import 'package:diginotes_app/src/utils/content_model.dart';
import 'package:diginotes_app/src/pres/widgets/note_tile.dart';
import 'package:diginotes_app/src/repos/notes_model.dart';
import 'package:diginotes_app/src/services/database.dart';
import 'package:diginotes_app/src/pres/screens/edit_note.dart';
import 'package:diginotes_app/src/pres/widgets/faderoute.dart';
import 'package:diginotes_app/src/pres/screens/view_note.dart';
import 'package:diginotes_app/src/pres/screens/info.dart';

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<NotesModel> notesList = [];
  TextEditingController searchController = TextEditingController();

  bool isSearchEmpty = true;

  @override
  void initState() {
    super.initState();
    NotesDatabaseService.db.init();
    setNotesFromDB();
  }

  setNotesFromDB() async {
    print("Entered setNotes");
    var fetchedNotes = await NotesDatabaseService.db.getNotesFromDB();
    setState(
      () {
        notesList = fetchedNotes;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        image: DecorationImage(
          image: AssetImage("assets/images/Background.png"),
          fit: BoxFit.cover,
        ),
      ),
      child: Scaffold(
        backgroundColor: Colors.transparent,
        floatingActionButton: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 10, 15),
          child: FloatingActionButton(
            onPressed: () {
              gotoEditNote();
            },
            child: const Icon(Icons.add),
            backgroundColor: green,
          ),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.info_outline,
                      size: 26,
                      color: white,
                    ),
                    onPressed: gotoInfoPage,
                  ),
                ],
              ),
              Text(
                text1,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                  color: white,
                  letterSpacing: 1,
                ),
              ),
              SizedBox(height: scrhei * 0.003),
              Text(
                text2,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Poppins',
                  fontSize: 12,
                  color: tgreen,
                ),
              ),
              SizedBox(height: scrhei * 0.012),
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                child: AnimatedContainer(
                  duration: Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  padding: EdgeInsets.only(left: 16),
                  height: scrhei * 0.02,
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Colors.grey.shade300,
                    ),
                    borderRadius: BorderRadius.all(
                      Radius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Expanded(
                        child: TextField(
                          cursorColor: Colors.transparent,
                          cursorWidth: 0,
                          controller: searchController,
                          maxLines: 1,
                          onChanged: (value) {
                            handleSearch(value);
                          },
                          autofocus: false,
                          keyboardType: TextInputType.text,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 18,
                            color: white,
                            //fontWeight: FontWeight.bold,
                          ),
                          textInputAction: TextInputAction.search,
                          decoration: InputDecoration.collapsed(
                            hintText: 'Search',
                            hintStyle: TextStyle(
                              color: Colors.grey.shade300,
                              fontSize: 18,
                              fontWeight: FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      IconButton(
                        icon: Icon(
                          isSearchEmpty ? Icons.search : Icons.clear,
                          color: Colors.grey.shade300,
                        ),
                        onPressed: cancelSearch,
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: scrhei * 0.01),
              Expanded(
                child: SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: <Widget>[
                      ...buildNoteComponentsList(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget testListItem(Color color) {
    return new NoteTile(
      noteData: NotesModel.random(),
    );
  }

  List<Widget> buildNoteComponentsList() {
    List<Widget> noteComponentsList = [];
    notesList.sort(
      (a, b) {
        return b.date.compareTo(a.date);
      },
    );
    if (searchController.text.isNotEmpty) {
      notesList.forEach(
        (note) {
          if (note.title
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()) ||
              note.content
                  .toLowerCase()
                  .contains(searchController.text.toLowerCase()))
            noteComponentsList.add(
              NoteTile(
                noteData: note,
                onTapAction: openNoteToRead,
              ),
            );
        },
      );
      return noteComponentsList;
    }

    notesList.forEach(
      (note) {
        noteComponentsList.add(
          NoteTile(
            noteData: note,
            onTapAction: openNoteToRead,
          ),
        );
      },
    );
    return noteComponentsList;
  }

  void handleSearch(String value) {
    if (value.isNotEmpty) {
      setState(
        () {
          isSearchEmpty = false;
        },
      );
    } else {
      setState(
        () {
          isSearchEmpty = true;
        },
      );
    }
  }

  void gotoEditNote() {
    Navigator.push(
      context,
      FadeRoute(
        page: EditNotePage(
          triggerRefetch: refetchNotesFromDB,
        ),
      ),
    );
  }

  void gotoInfoPage() {
    Navigator.push(
      context,
      FadeRoute(
        page: InfoPage(),
      ),
    );
  }

  void refetchNotesFromDB() async {
    await setNotesFromDB();
    print("Refetched notes");
  }

  openNoteToRead(NotesModel noteData) {
    Navigator.push(
      context,
      FadeRoute(
        page: ViewNotePage(
          triggerRefetch: refetchNotesFromDB,
          currentNote: noteData,
        ),
      ),
    );
  }

  void cancelSearch() {
    FocusScope.of(context).requestFocus(new FocusNode());
    setState(
      () {
        searchController.clear();
        isSearchEmpty = true;
      },
    );
  }
}
