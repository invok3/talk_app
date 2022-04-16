import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:just_audio/just_audio.dart';
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

  String _filter = "";

  List<Map<String, String>> phrase = [];

  AudioPlayer player = AudioPlayer();

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
                        color: Theme.of(context)
                            .colorScheme
                            .primary
                            .withOpacity(.8),
                        child: Row(
                          children: [
                            Material(
                              clipBehavior: Clip.hardEdge,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: InkWell(
                                onTap: () => _playPhrase(phrase),
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.mic,
                                    size:
                                        AppBar().preferredSize.height * 2 - 24,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                child: Container(
                              height: AppBar().preferredSize.height * 2 - 24,
                              decoration: BoxDecoration(
                                  color: Colors.white.withOpacity(.8),
                                  shape: BoxShape.rectangle,
                                  border: Border.all(
                                    color:
                                        Theme.of(context).colorScheme.primary,
                                  ),
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12))),
                              child: SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Row(
                                    children: phrase
                                        .map((e) => Container(
                                              padding: EdgeInsets.all(8),
                                              height: AppBar()
                                                      .preferredSize
                                                      .height *
                                                  1.5,
                                              width: AppBar()
                                                      .preferredSize
                                                      .height *
                                                  1.5,
                                              child: Image.network(
                                                e["imageLink"] ?? "",
                                                fit: BoxFit.cover,
                                                errorBuilder: (c, o, st) {
                                                  return Image.asset(
                                                    "assets/images/500x300.png",
                                                    fit: BoxFit.cover,
                                                  );
                                                },
                                              ),
                                            ))
                                        .toList(),
                                  )),
                            )),
                            Material(
                              clipBehavior: Clip.hardEdge,
                              color: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(100)),
                              child: InkWell(
                                onTap: _backSpace,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Icon(
                                    Icons.backspace,
                                    size:
                                        AppBar().preferredSize.height * 2 - 24,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surfaceVariant,
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
                              height: double.infinity,
                              //sidebar
                              width: AppBar().preferredSize.height * 2,
                              color: Theme.of(context)
                                  .colorScheme
                                  .primaryContainer,
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
                                            color: Theme.of(context)
                                                .colorScheme
                                                .onPrimary,
                                            clipBehavior: Clip.hardEdge,
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
                                                onTap: () => _filterCats(e),
                                                child: Column(
                                                  children: [
                                                    Flexible(
                                                      fit: FlexFit.tight,
                                                      child: Image.network(
                                                        e["image"] ?? "",
                                                        fit: BoxFit.cover,
                                                        errorBuilder:
                                                            (c, o, st) {
                                                          return Image.asset(
                                                            "assets/images/500x300.png",
                                                            fit: BoxFit.cover,
                                                          );
                                                        },
                                                      ),
                                                    ),
                                                    Text(e["title"] ?? ""),
                                                  ],
                                                ),
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
                              child: Container(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondaryContainer,
                                child: GridView.count(
                                  crossAxisCount: MediaQuery.of(context)
                                              .size
                                              .width ~/
                                          (AppBar().preferredSize.height * 2 -
                                              16) -
                                      1,
                                  children: elems
                                      .where((element) =>
                                          element["catID"] == _filter)
                                      .map((e) => Card(
                                            color: Colors.lime.shade100,
                                            clipBehavior: Clip.hardEdge,
                                            child: InkWell(
                                              onTap: () => _add(e),
                                              child: Column(
                                                children: [
                                                  Flexible(
                                                    fit: FlexFit.tight,
                                                    child: Image.network(
                                                      e["imageLink"] ?? "",
                                                      fit: BoxFit.cover,
                                                      errorBuilder: (c, o, st) {
                                                        return Image.asset(
                                                          "assets/images/500x300.png",
                                                          fit: BoxFit.cover,
                                                        );
                                                      },
                                                    ),
                                                  ),
                                                  Text(e["title"] ?? "")
                                                ],
                                              ),
                                            ),
                                          ))
                                      .toList(),
                                ),
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

  _filterCats(Map<String, String> category) {
    setState(() {
      _filter = category["id"] ?? "";
    });
  }

  _add(Map<String, String> element) {
    phrase.add(element);
    setState(() {});
    _playPhrase([element]);
  }

  void _backSpace() {
    if (phrase.isNotEmpty) {
      phrase.removeLast();
      setState(() {});
    }
  }

  void _playPhrase(List<Map<String, String>> mPhrase) async {
    // for (var word in phrase.toSet().toList()) {
    //   await player.setAudioSource(
    //       ProgressiveAudioSource(Uri.parse(word["audioFileLink"] ?? "")));
    //   await player.load();
    // }
    await player.setAudioSource(ConcatenatingAudioSource(
        children: mPhrase
            .map((e) =>
                ProgressiveAudioSource(Uri.parse(e["audioFileLink"] ?? "")))
            .toList()));
    await player.play();
  }
}
