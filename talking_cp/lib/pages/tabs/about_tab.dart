import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:talking_cp/controllers/firebase_api.dart';
import 'package:talking_cp/pages/components/appbar.dart';
import 'package:talking_cp/pages/components/func.dart';

class AboutTab extends StatefulWidget {
  static String routeName = "/AboutTab";

  const AboutTab({Key? key}) : super(key: key);

  @override
  State<AboutTab> createState() => _AboutTabState();
}

class _AboutTabState extends State<AboutTab> {
  late quill.QuillController qController;
  late bool isProtrait;
  String? _error;

  String? docText;

  @override
  Widget build(BuildContext context) {
    isProtrait = isPortrait(context: context);
    try {
      qController = quill.QuillController(
          document: quill.Document.fromJson(
              jsonDecode(ModalRoute.of(context)!.settings.arguments as String)),
          selection: TextSelection(baseOffset: 0, extentOffset: 0));
    } catch (e) {
      qController = quill.QuillController(
          document: quill.Document(),
          selection: TextSelection(baseOffset: 0, extentOffset: 0));
    }
    return Scaffold(
      appBar: MyAppBar(
        //appBar: AppBar(),
        title: "About Page",
      ),
      body: SafeArea(
        child: Column(
          children: [
            Directionality(
              textDirection: TextDirection.ltr,
              child: quill.QuillToolbar.basic(
                  showVideoButton: false,
                  showDividers: true,
                  controller: qController,
                  showAlignmentButtons: true),
            ),
            Expanded(
              child: Directionality(
                textDirection: TextDirection.ltr,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(width: 1, color: Colors.grey),
                        borderRadius: BorderRadius.circular(4)),
                    child: quill.QuillEditor(
                      embedBuilder: (context, controller, node, readOnly) {
                        debugPrint(node.value.data.toString());
                        //return ScaleableImage(src: node.value.data);
                        return Image.network(
                          node.value.data,
                        );
                      },
                      controller: qController,
                      focusNode: FocusNode(),
                      scrollController: ScrollController(),
                      scrollable: true,
                      padding: EdgeInsets.zero,
                      autoFocus: true,
                      readOnly: false,
                      expands: true,
                      showCursor: true,
                    ),
                  ),
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.all(16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  SizedBox(height: 8),
                  _error != null
                      ? Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                              Icon(
                                Icons.error_outline,
                                color: Colors.red[700],
                              ),
                              Text(
                                _error!,
                                style: TextStyle(color: Colors.red[700]),
                              )
                            ])
                      : SizedBox(),
                  SizedBox(height: 8),
                  ElevatedButton(
                      onPressed: () {
                        _saveDocument();
                      },
                      child: Text("Publish")),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  _saveDocument() async {
    String? result = await showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              contentPadding: EdgeInsets.zero,
              content: FutureBuilder(
                future: FirebaseAPI.saveAboute(
                  document: jsonEncode(qController.document.toDelta().toJson()),
                ),
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
}
