import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talking_cp/controllers/firebase_api.dart';
import 'package:talking_cp/pages/components/appbar.dart';
import 'package:talking_cp/pages/components/drawer_listview.dart';
import 'package:talking_cp/pages/components/flex_sidebar.dart';
import 'package:talking_cp/pages/components/func.dart';
import 'package:talking_cp/pages/tabs/edit_category_tab.dart';
import 'package:talking_cp/pages/tabs/stories_tab.dart';
import 'package:talking_cp/providers/reading_provider.dart';

class CategoriesTab extends StatefulWidget {
  static String routeName = "/CategoriesTab";

  const CategoriesTab({Key? key}) : super(key: key);

  @override
  State<CategoriesTab> createState() => _CategoriesTabState();
}

class _CategoriesTabState extends State<CategoriesTab> {
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
        title: "Categories",
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
                          Navigator.pushNamed(
                              context, EditCategoryTab.routeName,
                              arguments: {"varID": varID}).then((value) {
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
                  future: FirebaseAPI.fetchCats(),
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
                            "An Error Occurred while connecting to database! ",
                            style: TextStyle(color: Colors.red[700]),
                          )
                        ],
                      ));
                    } else {
                      var mList = snapshot.data as List<Map<String, String>>;
                      if (Provider.of<Reading>(context).variantID != null) {
                        mList.removeWhere((element) =>
                            element["varID"] !=
                            Provider.of<Reading>(context).variantID);
                      }
                      return mList.isEmpty
                          ? Center(
                              child: Text("No Categories Added"),
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
                                            id: e["id"] ?? "",
                                            title: e["title"] ?? "Unknown",
                                            subtitle: e["description"],
                                            image: e["image"],
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
      {required String title,
      required String id,
      String? subtitle,
      String? image,
      required double width,
      required double height}) {
    return Card(
      clipBehavior: Clip.hardEdge,
      elevation: 10,
      margin: EdgeInsets.all(8),
      child: InkWell(
        onTap: () => {
          Provider.of<Reading>(context, listen: false).setCatID(id),
          Navigator.of(context).pushReplacementNamed(StoriesTab.routeName)
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Image.network(
              image ?? "",
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
                InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () {
                      Navigator.of(context).pushNamed(EditCategoryTab.routeName,
                          arguments: {"catID": id}).then((value) {
                        setState(() {});
                      });
                    },
                    child: Padding(
                      padding: isProtrait
                          ? EdgeInsets.all(4.0)
                          : EdgeInsets.all(8.0),
                      child: Icon(Icons.edit, color: Colors.amber),
                    )),
                InkWell(
                    borderRadius: BorderRadius.circular(100),
                    onTap: () async {
                      bool? confirmation = await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                                content: Text(
                                    "Permanently Delete Category, This can't be Undone!"),
                                actions: [
                                  TextButton(
                                      onPressed: () =>
                                          Navigator.pop(context, true),
                                      child: Text("Ok")),
                                  TextButton(
                                      onPressed: () => Navigator.pop(context),
                                      child: Text("Back")),
                                ],
                              ));
                      if (confirmation != true) {
                        return;
                      }
                      await FirebaseFirestore.instance
                          .collection("categories")
                          .doc(id)
                          .delete();
                      setState(() {});
                    },
                    child: Padding(
                      padding: isProtrait
                          ? EdgeInsets.all(4.0)
                          : EdgeInsets.all(8.0),
                      child: Icon(Icons.delete, color: Colors.amber),
                    )),
              ],
            ),
          ],
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
