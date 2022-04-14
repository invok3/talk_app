import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talking_cp/controllers/firebase_api.dart';
import 'package:talking_cp/pages/components/appbar.dart';
import 'package:talking_cp/pages/components/drawer_listview.dart';
import 'package:talking_cp/pages/components/flex_sidebar.dart';
import 'package:talking_cp/pages/components/func.dart';
import 'package:talking_cp/pages/tabs/categories_tab.dart';
import 'package:talking_cp/pages/tabs/stories_tab.dart';
import 'package:talking_cp/pages/tabs/variants_tab.dart';
import 'package:talking_cp/providers/reading_provider.dart';

class ControlPanelPage extends StatefulWidget {
  const ControlPanelPage({Key? key}) : super(key: key);

  @override
  State<ControlPanelPage> createState() => ControlPanelPageState();
}

class ControlPanelPageState extends State<ControlPanelPage> {
  late bool isProtrait;

  int catsLengths = 0;
  int varsLength = 0;
  int storiesLength = 0;

  bool loaded = false;
  @override
  Widget build(BuildContext context) {
    isProtrait = isPortrait(context: context);

    return Scaffold(
      drawer: isProtrait
          ? Drawer(
              child: MyDrawerListView(drawer: true),
              //backgroundColor: Colors.grey[800],
            )
          : null,
      appBar: MyAppBar(
        //appBar: AppBar(),
        title: "Admin Panel",
      ),
      body: SafeArea(
        child: FlexSideBar(
          isProtrait: isProtrait,
          child: SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: FutureBuilder(
              future: fetchData(),
              builder: (context, snapshot) {
                if (snapshot.connectionState != ConnectionState.done) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SizedBox(
                            height: (MediaQuery.of(context).size.height -
                                (AppBar().preferredSize.height + 32)),
                          ),
                          CircularProgressIndicator()
                        ],
                      ),
                    ],
                  );
                } else {
                  return Column(
                    //crossAxisAlignment: CrossAxisAlignment.start,
                    children: isProtrait
                        ? _children(
                            varsLength: varsLength,
                            catsLength: catsLengths,
                            storiesLength: storiesLength)
                        : [
                            Row(
                              children: _children(
                                  varsLength: varsLength,
                                  catsLength: catsLengths),
                            ),
                            Row(
                              children: _children(storiesLength: storiesLength),
                            )
                          ],
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _children(
      {int? varsLength, int? catsLength, int? storiesLength}) {
    return [
      varsLength == null
          ? Container()
          : Card(
              clipBehavior: Clip.hardEdge,
              elevation: 10,
              shadowColor: Colors.deepOrange,
              color: Colors.deepOrange,
              child: InkWell(
                onTap: () => {
                  Provider.of<Reading>(context, listen: false)
                      .setVariantID(null),
                  Navigator.pushReplacementNamed(context, VariantsTab.routeName)
                },
                child: SizedBox(
                  width: 250,
                  height: 120,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Variant Count",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  varsLength.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                )
                              ],
                            ),
                            Icon(
                              Icons.install_desktop,
                              color: Colors.white.withOpacity(.3),
                              size: 56,
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey.withOpacity(.4),
                        child: Row(
                          children: [
                            Spacer(flex: 1),
                            Text(
                              "Categories",
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(flex: 8),
                            Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            ),
                            Spacer(flex: 1)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
      catsLength == null
          ? Container()
          : Card(
              clipBehavior: Clip.hardEdge,
              elevation: 10,
              shadowColor: Colors.amber,
              color: Colors.amber,
              child: InkWell(
                onTap: () => {
                  Provider.of<Reading>(context, listen: false).setCatID(null),
                  Navigator.pushReplacementNamed(
                      context, CategoriesTab.routeName)
                },
                child: SizedBox(
                  width: 250,
                  height: 120,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Category Count",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  catsLength.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                )
                              ],
                            ),
                            Icon(
                              Icons.list_alt,
                              color: Colors.white.withOpacity(.3),
                              size: 56,
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey.withOpacity(.4),
                        child: Row(
                          children: [
                            Spacer(flex: 1),
                            Text(
                              "Categories",
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(flex: 8),
                            Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            ),
                            Spacer(flex: 1)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
      storiesLength == null
          ? Container()
          : Card(
              clipBehavior: Clip.hardEdge,
              elevation: 10,
              shadowColor: Colors.orange,
              color: Colors.orange,
              child: InkWell(
                onTap: () => {
                  Provider.of<Reading>(context, listen: false).setCatID(null),
                  Navigator.pushReplacementNamed(context, StoriesTab.routeName)
                },
                child: SizedBox(
                  width: 250,
                  height: 120,
                  child: Column(
                    children: [
                      Expanded(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                Text(
                                  "Element Count",
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 20),
                                ),
                                Text(
                                  storiesLength.toString(),
                                  style: TextStyle(
                                      color: Colors.white, fontSize: 24),
                                )
                              ],
                            ),
                            Icon(
                              Icons.list,
                              color: Colors.white.withOpacity(.3),
                              size: 56,
                            )
                          ],
                        ),
                      ),
                      Container(
                        color: Colors.grey.withOpacity(.4),
                        child: Row(
                          children: [
                            Spacer(flex: 1),
                            Text(
                              "Elements",
                              style: TextStyle(color: Colors.white),
                            ),
                            Spacer(flex: 8),
                            Icon(
                              Icons.navigate_next,
                              color: Colors.white,
                            ),
                            Spacer(flex: 1)
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
    ];
  }

  Future<void> fetchData() async {
    if (loaded) {
      return;
    }
    var vars = await FirebaseAPI.fetchVars();
    var cats = await FirebaseAPI.fetchCats();
    var stories = await FirebaseAPI.fetchStories();
    setState(() {
      loaded = true;
      varsLength = vars.length;
      catsLengths = cats.length;
      storiesLength = stories.length;
    });
    return;
  }
}
