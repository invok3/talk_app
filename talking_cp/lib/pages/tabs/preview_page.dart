import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_quill/flutter_quill.dart' as quill;
import 'package:talking_cp/pages/components/func.dart';

class PreviewPage extends StatefulWidget {
  static String routeName = "/PreviewPage";

  const PreviewPage({Key? key}) : super(key: key);

  @override
  State<PreviewPage> createState() => _PreviewPageState();
}

class _PreviewPageState extends State<PreviewPage> {
  late String? doc;
  @override
  Widget build(BuildContext context) {
    var maxHeight =
        MediaQuery.of(context).size.height - AppBar().preferredSize.height - 10;
    return Scaffold(
      backgroundColor: Colors.grey.shade200,
      appBar: AppBar(title: Text("معاينة")),
      body: SafeArea(
        child: Center(
          child: Container(
            color: Colors.white,
            constraints: isPortrait(context: context)
                ? null
                : BoxConstraints(maxHeight: maxHeight, maxWidth: maxHeight / 2),
            child: quill.QuillEditor(
              expands: true,
              controller: quill.QuillController(
                  document: quill.Document.fromJson(jsonDecode(
                      ModalRoute.of(context)?.settings.arguments.toString() ??
                          "")),
                  selection: TextSelection(baseOffset: 0, extentOffset: 0)),
              padding: EdgeInsets.zero,
              readOnly: true,
              focusNode: FocusNode(),
              scrollable: true,
              scrollController: ScrollController(),
              autoFocus: true,
              showCursor: false,
            ),
          ),
        ),
      ),
    );
  }
}
