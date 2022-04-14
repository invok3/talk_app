import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talking_cp/controllers/firebase_api.dart';
import 'package:talking_cp/pages/components/appbar.dart';
import 'package:talking_cp/pages/components/drawer_listview.dart';
import 'package:talking_cp/pages/components/flex_sidebar.dart';
import 'package:talking_cp/pages/components/func.dart';
import 'package:talking_cp/pages/components/play_stop.dart';
import 'package:talking_cp/pages/tabs/edit_story_tab.dart';
import 'package:talking_cp/providers/reading_provider.dart';

class StoriesTab extends StatefulWidget {
  static String routeName = "/StoriesTab";

  const StoriesTab({Key? key}) : super(key: key);

  @override
  State<StoriesTab> createState() => _StoriesTabState();
}

class _StoriesTabState extends State<StoriesTab> {
  late bool isProtrait;

  String _searchValue = "";

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
        title: "Elements",
      ),
      body: SafeArea(
        child: FlexSideBar(
          isProtrait: isProtrait,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    ElevatedButton.icon(
                        style: ButtonStyle(
                            padding: MaterialStateProperty.all(
                                EdgeInsets.symmetric(
                                    horizontal: 12, vertical: 8))),
                        icon: Icon(
                          Icons.add,
                          color: Colors.white,
                        ),
                        onPressed: () async {
                          String? varID = await selectVarID();
                          if (varID == null) {
                            return;
                          }
                          String? catID = await selectCatID(varID: varID);
                          if (catID == null) {
                            return;
                          }
                          Navigator.pushNamed(context, EditStoryTab.routeName,
                                  arguments: {"varID": varID, "catID": catID})
                              .then((value) {
                            Provider.of<Reading>(context, listen: false)
                                .setVariantID(null);
                            Provider.of<Reading>(context, listen: false)
                                .setCatID(null);
                            Provider.of<Reading>(context, listen: false)
                                .setStoryID(null);
                            setState(() {});
                          });
                        },
                        label: Text(
                          "Add",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )),
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 3,
                      child: TextField(
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(18)),
                          hintText: "Search",
                          isDense: true,
                          prefixIcon: Icon(Icons.search),
                        ),
                        onChanged: (value) {
                          setState(() {
                            _searchValue = value;
                          });
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: FutureBuilder(
                  future: FirebaseAPI.fetchStories(),
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
                            "An Error Occurred while connecting to database!",
                            style: TextStyle(color: Colors.red[700]),
                          )
                        ],
                      ));
                    } else {
                      var mList = snapshot.data as List<Map<String, String>>;
                      if (Provider.of<Reading>(context).catID != null) {
                        mList.removeWhere((element) =>
                            element["catID"] !=
                            Provider.of<Reading>(context).catID);
                      }
                      return mList.isEmpty
                          ? Center(
                              child: Text("No Elementes!"),
                            )
                          : SingleChildScrollView(
                              controller: ScrollController(),
                              padding: EdgeInsets.all(8),
                              child: Column(
                                  children: mList
                                      .where((element) => element["title"]
                                          .toString()
                                          .contains(_searchValue))
                                      .map((e) => mCard(
                                            varID: e["varID"] ?? "",
                                            catID: e["catID"] ?? "",
                                            id: e["id"] ?? "",
                                            title: e["title"] ?? "",
                                            subtitle: e["description"],
                                            imageLink: e["imageLink"],
                                            audioFileLink: e["audioFileLink"],
                                            width: x,
                                            height: y,
                                          ))
                                      .toList()),
                            );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget mCard(
      {required String id,
      required String varID,
      required String catID,
      required String title,
      String? subtitle,
      String? imageLink,
      String? audioFileLink,
      required double width,
      required double height}) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 10,
      margin: EdgeInsets.all(8),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceBetween, children: [
        Image.network(
          imageLink ?? "",
          height: height,
          width: width,
          errorBuilder: (context, error, stackTrace) {
            return Image.asset(
              "assets/images/350.png",
              height: height,
              width: width,
              fit: BoxFit.cover,
            );
          },
          fit: BoxFit.cover,
        ),
        Expanded(
          flex: 10,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: Colors.amber,
                      ),
                ),
                Text(
                  subtitle ?? "",
                  //softWrap: true,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.caption,
                ),
              ],
              crossAxisAlignment: CrossAxisAlignment.start,
            ),
          ),
        ),
        Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            PlayStopButton(
              link: audioFileLink ?? "",
              isProtrait: isProtrait,
            ),
            InkWell(
                borderRadius: BorderRadius.circular(100),
                onTap: () {
                  Navigator.of(context)
                      .pushNamed(EditStoryTab.routeName, arguments: {
                    "id": id,
                    "varID": varID,
                    "catID": catID,
                    "title": title,
                    "subtitle": subtitle,
                    "audioFileLink": audioFileLink,
                    "imageLink": imageLink
                  }).then((value) {
                    setState(() {});
                  });
                },
                child: Padding(
                  padding:
                      isProtrait ? EdgeInsets.all(4.0) : EdgeInsets.all(8.0),
                  child: Icon(Icons.edit, color: Colors.amber),
                )),
            InkWell(
              borderRadius: BorderRadius.circular(100),
              onTap: () async {
                bool? confirmation = await showDialog(
                  context: context,
                  builder: (context) => AlertDialog(
                    content:
                        Text("Permanently Delete Element, Can't be undone!"),
                    actions: [
                      TextButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: Text("Ok"),
                      ),
                      TextButton(
                        onPressed: () => Navigator.pop(context),
                        child: Text("Back"),
                      ),
                    ],
                  ),
                );
                if (confirmation != true) {
                  return;
                }
                await FirebaseFirestore.instance
                    .collection("stories")
                    .doc(id)
                    .delete();
                setState(() {});
              },
              child: Padding(
                padding: isProtrait ? EdgeInsets.all(4.0) : EdgeInsets.all(8.0),
                child: Icon(Icons.delete, color: Colors.amber),
              ),
            ),
          ],
        ),
      ]),
    );
  }

  Future<String?> selectCatID({required String varID}) async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: FutureBuilder(
          future: FirebaseAPI.fetchCats(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.data == null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text("No Categories Found!"),
                  ),
                ],
              );
            } else {
              List<Map<String, String>> mList =
                  snapshot.data as List<Map<String, String>>;
              mList.removeWhere((element) => element["varID"] != varID);
              return mList.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text("No Categories Added"),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: mList
                            .map((e) => ListTile(
                                  title: Text(e["title"].toString()),
                                  onTap: () {
                                    Navigator.pop(context, e["id"]);
                                  },
                                ))
                            .toList(),
                      ),
                    );
            }
          },
        ),
      ),
    );
  }

  Future<String?> selectVarID() async {
    return await showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: FutureBuilder(
          future: FirebaseAPI.fetchVars(),
          builder: (context, snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(child: CircularProgressIndicator()),
                ],
              );
            } else if (snapshot.data == null) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Center(
                    child: Text("No Variants Found!"),
                  ),
                ],
              );
            } else {
              List<Map<String, String>> mList =
                  snapshot.data as List<Map<String, String>>;
              return mList.isEmpty
                  ? Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Center(
                          child: Text("No Variants Added"),
                        ),
                      ],
                    )
                  : SingleChildScrollView(
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: mList
                            .map((e) => ListTile(
                                  title: Text(e["title"].toString()),
                                  onTap: () {
                                    Navigator.pop(context, e["id"]);
                                  },
                                ))
                            .toList(),
                      ),
                    );
            }
          },
        ),
      ),
    );
  }
}
