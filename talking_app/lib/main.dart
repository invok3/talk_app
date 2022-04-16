import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:talking_app/pages/main_page.dart';

String? variantID;
late SharedPreferences sp;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: FirebaseOptions(
        apiKey: "AIzaSyBtkZ-XuYLaslhtOm_RoqHZup6oIn5Wmq4",
        authDomain: "talking-app-58e1d.firebaseapp.com",
        projectId: "talking-app-58e1d",
        storageBucket: "talking-app-58e1d.appspot.com",
        messagingSenderId: "999825892199",
        appId: "1:999825892199:web:a2e2d8f7b43b2376b605c2",
        measurementId: "G-QT73HSD8ZY"),
  );
  sp = await SharedPreferences.getInstance();
  variantID = _loadVariantID();
  runApp(const StteManager());
}

String? _loadVariantID() {
  return sp.getString("variantID");
}

class StteManager extends StatelessWidget {
  const StteManager({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TalkingApp',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        colorSchemeSeed: Color(0x005a22),
        // primaryColor: Color(0x005a22),
        // primarySwatch: MaterialColor(0x005a22, {
        //   50: Color(0x005a22).withOpacity(.05),
        //   100: Color(0x005a22).withOpacity(.1),
        //   200: Color(0x005a22).withOpacity(.2),
        //   300: Color(0x005a22).withOpacity(.3),
        //   400: Color(0x005a22).withOpacity(.4),
        //   500: Color(0x005a22).withOpacity(.5),
        //   600: Color(0x005a22).withOpacity(.6),
        //   700: Color(0x005a22).withOpacity(.7),
        //   800: Color(0x005a22).withOpacity(.8),
        //   900: Color(0x005a22).withOpacity(.9),
        // }),
      ),
      routes: {
        "/": (context) => MainPage(),
      },
      initialRoute: "/",
    );
  }
}
