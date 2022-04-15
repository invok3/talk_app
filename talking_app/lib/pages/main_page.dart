import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:talking_app/controllers/firebase_api.dart';
import 'package:talking_app/controllers/select_variant_dialog.dart';
import 'package:talking_app/main.dart';

class MainPage extends StatefulWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  bool loaded = false;

  List<Map<String, String>> cats = [];

  List<Map<String, String>> elems = [];

  @override
  void initState() {
    // TODO: implement initState
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight]);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // if (variantID == null) {
    //   _selectVariant();
    // }

    return Scaffold(
      body: SafeArea(
        child: variantID == null
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("No Variant Selected!"),
                    TextButton(
                      onPressed: () async {
                        await selectVariant(context);
                        setState(() {});
                      },
                      child: Text("Tap to select."),
                    )
                  ],
                ),
              )
            : FutureBuilder(
                future: _getData(),
                builder: (context, snapshot) {
                  return Column(
                    children: [
                      Container(
                        padding: EdgeInsets.all(4),
                        //app bar
                        height: AppBar().preferredSize.height * 2,
                        color: Colors.red,
                        child: Row(
                          children: [
                            Material(
                              clipBehavior: Clip.hardEdge,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: InkWell(
                                onTap: () {
                                  debugPrint("");
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.mic,
                                    size:
                                        AppBar().preferredSize.height * 2 - 24,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              height: AppBar().preferredSize.height * 2 - 24,
                              decoration: BoxDecoration(
                                  color: Colors.white,
                                  shape: BoxShape.rectangle,
                                  border: Border.all(color: Colors.white),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: Row(),
                            )),
                            Material(
                              clipBehavior: Clip.hardEdge,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: InkWell(
                                onTap: () {
                                  debugPrint("");
                                },
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.backspace,
                                    size:
                                        AppBar().preferredSize.height * 2 - 24,
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        //body after appbar
                        child: Row(
                          children: [
                            Container(
                              //sidebar
                              width: AppBar().preferredSize.height * 2,
                              color: Colors.yellow,
                              child: SingleChildScrollView(
                                child: Column(
                                  //categories.map()
                                  children: cats
                                      .map(
                                        (e) => Material(
                                          clipBehavior: Clip.hardEdge,
                                          color: Colors.transparent,
                                          // shape: RoundedRectangleBorder(
                                          //     borderRadius:
                                          //         BorderRadius.circular(100)),
                                          child: Card(
                                            child: Container(
                                              width: AppBar()
                                                          .preferredSize
                                                          .height *
                                                      2 -
                                                  16,
                                              height: AppBar()
                                                          .preferredSize
                                                          .height *
                                                      2 -
                                                  16,
                                              child: InkWell(
                                                onTap: () {
                                                  debugPrint("");
                                                },
                                                child: Image.network(
                                                    e["image"] ?? ""),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                      .toList(),
                                ),
                              ),
                            ),
                            Flexible(
                              //body
                              child: GridView.count(
                                crossAxisCount:
                                    MediaQuery.of(context).size.width ~/
                                            (AppBar().preferredSize.height * 2 -
                                                16) -
                                        1,
                                children: [
                                  Icon(Icons.abc),
                                  Icon(Icons.abc),
                                  Icon(Icons.abc),
                                  Icon(Icons.abc),
                                  Icon(Icons.abc),
                                  Icon(Icons.abc),
                                  Icon(Icons.abc),
                                  Icon(Icons.abc),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ],
                  );
                }),
      ),
    );
  }

  Future<void> _getData() async {
    if (loaded) {
      return;
    }
    var catList = await FirebaseAPI.fetchCats();
    var elemList = await FirebaseAPI.fetchElems();
    debugPrint(catList.length.toString());
    setState(() {
      loaded = true;
      cats = catList;
      elems = elemList;
    });
  }
}
