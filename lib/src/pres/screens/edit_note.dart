import 'dart:convert';
import 'dart:ui';
import 'dart:io';
import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:dio/dio.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:diginotes_app/src/repos/notes_model.dart';
import 'package:diginotes_app/src/pres/screens/camera.dart';
import 'package:diginotes_app/src/services/database.dart';
import 'package:diginotes_app/src/utils/details.dart';
import 'package:diginotes_app/src/pres/screens/view_note.dart';
import 'package:diginotes_app/src/pres/widgets/faderoute.dart';
import 'package:diginotes_app/src/repos/jsontodart.dart';
import 'package:diginotes_app/src/pres/widgets/expandableFAB.dart';
import 'package:diginotes_app/src/pres/widgets/loading_indicator.dart';
import 'package:permission_handler/permission_handler.dart';

class EditNotePage extends StatefulWidget {
  Function() triggerRefetch;
  NotesModel existingNote;
  EditNotePage({Key key, Function() triggerRefetch, NotesModel existingNote})
      : super(key: key) {
    this.triggerRefetch = triggerRefetch;
    this.existingNote = existingNote;
  }
  @override
  _EditNotePageState createState() => _EditNotePageState();
}

class _EditNotePageState extends State<EditNotePage> {
  bool isDirty = false;
  bool isNoteNew = true;
  bool isLoading = false;
  FocusNode titleFocus = FocusNode();
  FocusNode contentFocus = FocusNode();
  Function() triggerRefetch;
  NotesModel currentNote;
  TextEditingController titleController = TextEditingController();
  TextEditingController contentController = TextEditingController();
  var imagePath;

  @override
  void initState() {
    super.initState();
    if (widget.existingNote == null) {
      currentNote = NotesModel(
        content: '',
        title: '',
        date: DateTime.now(),
      );
      isNoteNew = true;
    } else {
      currentNote = widget.existingNote;
      isNoteNew = false;
    }
    titleController.text = currentNote.title;
    contentController.text = currentNote.content;
  }

  File _image;

  Future<Response> _upload(File file) async {
    String fileName = file.path.split('/').last;
    FormData data = FormData.fromMap({
      "file": await MultipartFile.fromFile(
        file.path,
        filename: fileName,
      ),
    });
    Dio dio = new Dio();
    setState(() {
      isLoading = true;
    });
    DialogBuilder(context).showLoadingIndicator();
    final resp = await dio
        .post('https://diginotes1310.herokuapp.com/predict/image', data: data)
        .then((response) => response)
        .catchError((error) => print(error));
    DialogBuilder(context).hideOpenDialog();
    setState(() {
      isLoading = false;
    });
    return resp;
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
          child: ExpandableFab(
            distance: 70,
            children: [
              ActionButton(
                onPressed: () => getImage(context, 0),
                icon: const Icon(Icons.insert_photo),
              ),
              ActionButton(
                onPressed: () => getCamImage(context),
                icon: const Icon(Icons.add_a_photo),
              ),
            ],
          ),
        ),
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
                    onPressed: () {
                      handleDelete();
                    },
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 200),
                    width: isDirty ? 50 : 0,
                    curve: Curves.decelerate,
                    child: IconButton(
                      icon: Icon(Icons.check),
                      color: white,
                      onPressed: () {
                        handleSave();
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: scrwid * 0.01),
              Padding(
                padding: const EdgeInsets.only(left: 3.8),
                child: TextField(
                  cursorColor: green,
                  textAlign: TextAlign.center,
                  focusNode: titleFocus,
                  controller: titleController,
                  keyboardType: TextInputType.multiline,
                  maxLines: null,
                  onSubmitted: (text) {
                    titleFocus.unfocus();
                    FocusScope.of(context).requestFocus(contentFocus);
                    titleController.text = currentNote.title;
                  },
                  onChanged: (value) {
                    markTitleAsDirty(value);
                  },
                  textInputAction: TextInputAction.next,
                  style: TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 25,
                    color: white,
                    fontWeight: FontWeight.bold,
                  ),
                  decoration: InputDecoration.collapsed(
                    hintText: 'Title',
                    hintStyle: TextStyle(
                      color: Colors.grey.shade400,
                      fontSize: 25,
                      fontFamily: 'Poppins',
                      fontWeight: FontWeight.bold,
                    ),
                    border: InputBorder.none,
                  ),
                ),
              ),
              SizedBox(height: scrwid * 0.03),
              Expanded(
                child: Container(
                  width: scrwid,
                  margin: EdgeInsets.only(left: 8, right: 8, bottom: 4),
                  padding: EdgeInsets.fromLTRB(25, 30, 25, 40),
                  decoration: BoxDecoration(
                    color: blue.withOpacity(0.95),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: TextField(
                    cursorColor: green,
                    focusNode: contentFocus,
                    controller: contentController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    onChanged: (value) {
                      markContentAsDirty(value);
                    },
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      fontSize: 11,
                      color: white,
                    ),
                    decoration: InputDecoration.collapsed(
                      hintText: 'Start Typing',
                      hintStyle: TextStyle(
                        fontFamily: 'Poppins',
                        color: Colors.grey.shade400,
                        fontSize: 11,
                      ),
                      border: InputBorder.none,
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

  Future getCamImage(context) async {
    if (await Permission.camera.request().isGranted) {
      imagePath = await Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => TakePictureScreen(),
        ),
      );
      if (imagePath != null) {
        setState(
          () {
            _image = File(imagePath);
          },
        );
        var resp1 = await _upload(_image);
        if (resp1 != null) {
          print('${resp1.data}');
          dynamic convertedResp = Posts.fromJson(resp1.data);
          String str = '';
          convertedResp.sentences.forEach(
            (element) {
              str += element;
              str += '\n';
            },
          );
          setState(
            () {
              if (currentNote != null) {
                contentController.text += str;
                isDirty = true;
              }
              print(contentController.text);
            },
          );
        }
      }
    }
  }

  Future getImage(context, i) async {
    File image;
    final picker = ImagePicker();
    var _pickedFile = await picker.getImage(
        source: (i == 0 ? ImageSource.gallery : ImageSource.camera));
    if (_pickedFile != null) {
      image = File(_pickedFile.path);
      setState(
        () {
          _image = image;
        },
      );
      var resp1 = await _upload(_image);
      if (resp1 != null) {
        print('${resp1.data}');
        var convertedResp = Posts.fromJson(resp1.data);
        String str='';
        convertedResp.sentences.forEach((element) 
        {
          str+=element;
          str+='\n';
          },);
        setState(
          () {
            if (currentNote != null) {
              contentController.text+=str;
              isDirty = true;
            }
            print(contentController.text);
          },
        );
      }
    }
  }

  void showLoadingIndicator() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(10.0),
              ),
            ),
            backgroundColor: blue,
            content: LoadingIndicator(),
          ),
        );
      },
    );
  }

  void handleSave() async {
    setState(
      () {
        currentNote.title = titleController.text;
        currentNote.content = contentController.text;
        print('Hey there ${currentNote.content}');
      },
    );
    if (isNoteNew) {
      var latestNote = await NotesDatabaseService.db.addNoteInDB(currentNote);
      setState(() {
        currentNote = latestNote;
      });
    } else {
      await NotesDatabaseService.db.updateNoteInDB(currentNote);
    }
    setState(
      () {
        isNoteNew = false;
        isDirty = false;
      },
    );
    widget.triggerRefetch();
    titleFocus.unfocus();
    contentFocus.unfocus();

    {
      Navigator.pushReplacement(
        context,
        FadeRoute(
          page: ViewNotePage(
            triggerRefetch: widget.triggerRefetch,
            currentNote: currentNote,
          ),
        ),
      );
    }
  }

  void markTitleAsDirty(String title) {
    setState(
      () {
        isDirty = true;
      },
    );
  }

  void markContentAsDirty(String content) {
    setState(
      () {
        isDirty = true;
      },
    );
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
                await NotesDatabaseService.db.deleteNoteInDB(currentNote);
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

  void handleBack() {
    Navigator.pop(context);
  }
}

class DialogBuilder {
  DialogBuilder(this.context);

  final BuildContext context;

  void showLoadingIndicator([String text]) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => false,
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(
                Radius.circular(8.0),
              ),
            ),
            backgroundColor: blue,
            content: LoadingIndicator(),
          ),
        );
      },
    );
  }

  void hideOpenDialog() {
    Navigator.of(context).pop();
  }
}
