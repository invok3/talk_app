import 'dart:typed_data';

import 'package:file_picker/_internal/file_picker_web.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:talking_cp/controllers/firebase_api.dart';
import 'package:talking_cp/pages/components/appbar.dart';
import 'package:talking_cp/pages/components/func.dart';

class EditStoryTab extends StatefulWidget {
  static String routeName = "/StoriesTab/EditStoryTab";

  const EditStoryTab({Key? key}) : super(key: key);

  @override
  State<EditStoryTab> createState() => _EditStoryTabState();
}

class _EditStoryTabState extends State<EditStoryTab> {
  late bool isProtrait;
  late TextEditingController _title;
  late TextEditingController _description;
  String? _error;
  late Map<String, String?> args;
  late TextEditingController _imageController;
  late TextEditingController _audioFileController;

  String? _imageLink;
  String? _audioFileLink;

  @override
  Widget build(BuildContext context) {
    isProtrait = isPortrait(context: context);

    try {
      args = ModalRoute.of(context)!.settings.arguments as Map<String, String?>;
    } catch (e) {
      debugPrint(e.toString());
      args = {};
    }

    try {
      _title = TextEditingController(text: args["title"]);
      _description = TextEditingController(text: args["subtitle"]);
      _imageController =
          TextEditingController(text: _imageLink ?? args["imageLink"]);
      _audioFileController =
          TextEditingController(text: _audioFileLink ?? args["audioFileLink"]);
    } catch (e) {
      debugPrint(e.toString());
      _title = TextEditingController();
      _description = TextEditingController();
      _imageController = TextEditingController(text: _imageLink);
      _audioFileController = TextEditingController(text: _audioFileLink);
    }

////////////////

    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: MyAppBar(
        //appBar: AppBar(),
        title: "Edit Element",
      ),
      body: SafeArea(
        child: args["catID"] == null ||
                args["catID"] == "" ||
                args["varID"] == null ||
                args["varID"] == ""
            ? Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text("Error: Category ID was not provided!"),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text("Back"))
                  ],
                ),
              )
            : SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 16,
                          vertical: 8),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: TextField(
                          controller: _imageController,
                          decoration: InputDecoration(
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.amber, width: 2),
                            ),
                            labelText: "Image Link: ",
                            floatingLabelBehavior: FloatingLabelBehavior.always,
                            isDense: true,
                            border: OutlineInputBorder(),
                            suffixIcon: IconButton(
                              color: Colors.amber,
                              onPressed: () =>
                                  selectFile(mFileType: FileType.image),
                              icon: Icon(Icons.camera_alt),
                            ),
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.symmetric(
                          horizontal: MediaQuery.of(context).size.width / 16,
                          vertical: 8),
                      child: Container(
                        constraints: BoxConstraints(maxWidth: 500),
                        child: TextField(
                          controller: _audioFileController,
                          decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Colors.amber, width: 2)),
                              labelText: "AudioFile Link: ",
                              floatingLabelBehavior:
                                  FloatingLabelBehavior.always,
                              isDense: true,
                              border: OutlineInputBorder(),
                              suffixIcon: IconButton(
                                  color: Colors.amber,
                                  onPressed: () =>
                                      selectFile(mFileType: FileType.audio),
                                  icon: Icon(Icons.audio_file))),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 16,
                            vertical: 8),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 500),
                          child: TextField(
                            controller: _title,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Title: ",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                        ),
                      ),
                    ),
                    Center(
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                            horizontal: MediaQuery.of(context).size.width / 16,
                            vertical: 8),
                        child: Container(
                          constraints: BoxConstraints(maxWidth: 500),
                          child: TextField(
                            controller: _description,
                            maxLines: 5,
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Description: ",
                                floatingLabelBehavior:
                                    FloatingLabelBehavior.always),
                          ),
                        ),
                      ),
                    ),
                    _error == null
                        ? Container()
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(Icons.error_outline, color: Colors.red[700]),
                              Text(_error ?? "Unknown Error!",
                                  style: TextStyle(color: Colors.red[700]))
                            ],
                          ),
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            _error = null;
                          });
                          editStory();
                        },
                        child: Text("Save")),
                  ],
                ),
              ),
      ),
    );
  }

  editStory() async {
    if (_title.text.isEmpty) {
      setState(() {
        _error = "Title is required!";
      });
      return;
    }

    String? result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: FutureBuilder(
                future: FirebaseAPI.editElement(
                    id: args["id"] ??
                        DateTime.now().millisecondsSinceEpoch.toString(),
                    imageLink: _imageController.text,
                    audioFileLink: _audioFileController.text,
                    title: _title.text,
                    description: _description.text,
                    catID: args["catID"] ?? "",
                    varID: args["varID"] ?? ""),
                builder: (context, snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return Center(child: CircularProgressIndicator());
                  } else {
                    Navigator.of(context).pop(snapshot.data);
                    return Container();
                  }
                },
              ),
            ));
    if (result != null) {
      setState(() {
        _error = "An Error Occurred while connecting to database!";
      });
    } else {
      Navigator.pop(context);
    }
  }

  selectFile({required FileType mFileType}) async {
    FilePickerResult? mFilePickerResult = await FilePickerWeb.platform
        .pickFiles(allowMultiple: false, type: mFileType);
    if (mFilePickerResult == null) {
      debugPrint("Aborted!");
      return;
    }
    debugPrint(mFilePickerResult.files.first.name);
    Uint8List? xBytes = mFilePickerResult.files.first.bytes;
    if (xBytes == null) {
      debugPrint("Error Reading File!");
      return;
    }
    String? xLink = await showDialog(
      barrierDismissible: false,
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.transparent,
        elevation: 0,
        contentPadding: EdgeInsets.zero,
        content: FutureBuilder(
          future: FirebaseAPI.uploadPhoto(
              mFileType: mFileType,
              fileName:
                  "${DateTime.now().millisecondsSinceEpoch}.${mFilePickerResult.files.first.extension}",
              fileData: xBytes),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.data.toString().contains("Error: ") == true) {
              return Center(
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          snapshot.data.toString(),
                          style: TextStyle(color: Colors.red[700]),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextButton(
                            onPressed: () => Navigator.pop(context),
                            child: Text("Back"))
                      ],
                    ),
                  ),
                ),
              );
            } else {
              Navigator.of(context).pop(snapshot.data);
              return Container();
            }
          },
        ),
      ),
    );
    if (xLink != null) {
      debugPrint(xLink);
      setState(() {
        mFileType == FileType.audio
            ? _audioFileLink = xLink
            : _imageLink = xLink;
      });
    }
  }
}
