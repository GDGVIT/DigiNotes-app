import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/painting.dart';
import 'package:flutter/widgets.dart';
import 'package:diginotes_app/src/repos/notes_model.dart';
import 'package:diginotes_app/src/pres/screens/edit_note.dart';
import 'package:diginotes_app/src/services/database.dart';
import 'package:share/share.dart';
import 'package:diginotes_app/src/utils/details.dart';
import 'package:diginotes_app/src/pres/widgets/faderoute.dart';

class ViewNotePage extends StatefulWidget {
  Function() triggerRefetch;
  NotesModel currentNote;
  ViewNotePage({Key key, Function() triggerRefetch, NotesModel currentNote})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.currentNote = currentNote;
  }
  @override
  _ViewNotePageState createState() => _ViewNotePageState();
}

class _ViewNotePageState extends State<ViewNotePage> {
  @override
  void initState() {
    super.initState();
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
        body: SafeArea(
          child: Column(
            children: [
              Row(
                children: [
                  IconButton(
                    icon: Icon(
                      Icons.arrow_back_ios_rounded,
                      color: white,
                    ),
                    onPressed: () {
                      handleBack();
                    },
                  ),
                  Spacer(),
                  IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: white,
                    ),
                    onPressed: handleDelete,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.share_outlined,
                      color: white,
                    ),
                    onPressed: handleShare,
                  ),
                  IconButton(
                    icon: Icon(
                      Icons.edit_outlined,
                      color: white,
                    ),
                    onPressed: handleEdit,
                  ),
                ],
              ),
              SizedBox(height: scrwid * 0.01),
              Text(
                widget.currentNote.title,
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 25,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  color: white,
                ),
              ),
              SizedBox(height: scrwid * 0.03),
              Expanded(
                child: Container(
                  width: scrwid,
                  margin: EdgeInsets.only(left: 10, right: 10),
                  padding: EdgeInsets.fromLTRB(25, 30, 25, 40),
                  decoration: BoxDecoration(
                    color: blue.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Text(
                    widget.currentNote.content,
                    style: TextStyle(
                      color: white,
                      fontSize: 11,
                      fontFamily: 'Poppins',
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleSave() async {
    await NotesDatabaseService.db.updateNoteInDB(widget.currentNote);
    widget.triggerRefetch();
  }

  void handleEdit() {
    Navigator.pushReplacement(
      context,
      FadeRoute(
        page: EditNotePage(
          existingNote: widget.currentNote,
          triggerRefetch: widget.triggerRefetch,
        ),
      ),
    );
  }

  void handleShare() {
    Share.share(
        '${widget.currentNote.title.trim()}\n(On: ${widget.currentNote.date.toIso8601String().substring(0, 10)})\n\n${widget.currentNote.content}');
  }

  void handleBack() {
    Navigator.pop(context);
  }

  void handleDelete() async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          backgroundColor: blue,
          title: Text(
            'Delete Note',
            style: TextStyle(
              color: white,
              fontSize: 20,
              fontFamily: 'Poppins',
              fontWeight: FontWeight.bold,
              letterSpacing: 1,
            ),
          ),
          content: Text(
            'This note will be deleted permanently',
            style: TextStyle(
              color: white.withOpacity(0.7),
              fontSize: 15,
              fontFamily: 'Poppins',
            ),
          ),
          actions: <Widget>[
            FlatButton(
              child: Text(
                'DELETE',
                style: TextStyle(
                  color: Colors.red.shade300,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2,
                ),
              ),
              onPressed: () async {
                await NotesDatabaseService.db
                    .deleteNoteInDB(widget.currentNote);
                widget.triggerRefetch();
                Navigator.pop(context);
                Navigator.pop(context);
              },
            ),
            FlatButton(
              child: Text(
                'CANCEL',
                style: TextStyle(
                  color: lgreen,
                  fontFamily: 'Poppins',
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                ),
              ),
              onPressed: () {
                Navigator.pop(context);
              },
            )
          ],
        );
      },
    );
  }
}
