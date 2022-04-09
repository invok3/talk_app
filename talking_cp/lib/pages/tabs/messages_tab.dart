import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talking_cp/controllers/firebase_api.dart';
import 'package:talking_cp/pages/components/appbar.dart';
import 'package:talking_cp/pages/components/drawer_listview.dart';
import 'package:talking_cp/pages/components/flex_sidebar.dart';
import 'package:talking_cp/pages/components/func.dart';

class MessagesTab extends StatefulWidget {
  static String routeName = "/MessagesTab";
  const MessagesTab({Key? key}) : super(key: key);

  @override
  State<MessagesTab> createState() => _MessagesTabState();
}

class _MessagesTabState extends State<MessagesTab> {
  late bool isProtrait;

  bool _selectAll = false;
  List<Map<String, dynamic>>? mList;

  @override
  Widget build(BuildContext context) {
    isProtrait = isPortrait(context: context);
    double x = (MediaQuery.of(context).size.width - 250) / 5;
    double y = MediaQuery.of(context).size.height / 7;
    x = x < y ? y : x;
    return Scaffold(
      drawer: isProtrait
          ? Drawer(
              child: MyDrawerListView(drawer: true),
              //backgroundColor: Colors.grey[800],
            )
          : null,
      appBar: MyAppBar(
        //appBar: AppBar(),
        title: "Suggestions",
      ),
      body: SafeArea(
        child: FlexSideBar(
          isProtrait: isProtrait,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: FutureBuilder(
                  future: _getMessages(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState != ConnectionState.done) {
                      return Center(
                        child: CircularProgressIndicator(),
                      );
                    } else if (snapshot.data == null) {
                      return Center(
                          child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.error_outline,
                            color: Colors.red[700],
                          ),
                          Text(
                            "An Error Occurred while connecting to database",
                            style: TextStyle(color: Colors.red[700]),
                          )
                        ],
                      ));
                    } else {
                      return SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Table(
                            border: TableBorder(
                              verticalInside: BorderSide(color: Colors.amber),
                              horizontalInside: BorderSide(color: Colors.amber),
                            ),
                            defaultVerticalAlignment:
                                TableCellVerticalAlignment.middle,
                            columnWidths: {
                              0: FixedColumnWidth(32),
                              1: FixedColumnWidth(150),
                              2: FixedColumnWidth(150),
                              3: FixedColumnWidth(150),
                              4: FlexColumnWidth(),
                            },
                            children: [
                                  TableRow(
                                    decoration: BoxDecoration(
                                      color: Colors.amber,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(8),
                                          topRight: Radius.circular(8)),
                                    ),
                                    children: [
                                      Center(
                                        child: Checkbox(
                                            value: _selectAll,
                                            onChanged: (value) {
                                              for (var item in mList!) {
                                                item["selected"] =
                                                    value ?? false;
                                              }
                                              _selectAll = value ?? false;
                                              setState(() {});
                                            }),
                                      ),
                                      Center(child: Text("Name")),
                                      Center(child: Text("Email")),
                                      Center(child: Text("Subject")),
                                      Center(child: Text("Text")),
                                    ],
                                  )
                                ] +
                                mList!
                                    .map((e) => TableRow(
                                            decoration: BoxDecoration(
                                                border: Border(
                                              left: BorderSide(
                                                  color: Colors.amber),
                                              right: BorderSide(
                                                  color: Colors.amber),
                                              bottom: BorderSide(
                                                  color: Colors.amber),
                                            )),
                                            children: [
                                              Center(
                                                child: Checkbox(
                                                    value: e["selected"],
                                                    onChanged: (value) {
                                                      setState(() {
                                                        e["selected"] =
                                                            value ?? false;
                                                      });
                                                    }),
                                              ),
                                              Center(child: Text(e["name"])),
                                              Center(child: Text(e["email"])),
                                              Center(child: Text(e["subject"])),
                                              Center(child: Text(e["content"])),
                                            ]))
                                    .toList(),
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () => _deleteSelected(),
                        child: Text("Delete"))
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String?> _getMessages() async {
    if (mList != null) {
      return "exist";
    }
    var tList = await FirebaseAPI.getMessages();
    if (tList != null) {
      setState(() {
        mList = tList
            .map((e) => {
                  "id": e.id,
                  "name": e["name"],
                  "email": e["email"],
                  "subject": e["subject"],
                  "content": e["content"],
                  "selected": false
                })
            .toList();
      });
      return "done";
    } else {
      //error!
      return null;
    }
  }

  _deleteSelected() async {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) => AlertDialog(
              backgroundColor: Colors.transparent,
              elevation: 0,
              content: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [CircularProgressIndicator()],
              ),
            ));
    for (var item in mList!) {
      if (item["selected"] == true) {
        await FirebaseFirestore.instance
            .collection("suggestions")
            .doc(item["id"])
            .delete();
        mList!.remove(item);
      }
    }
    Navigator.of(context).pop();
    setState(() {});
  }
}
