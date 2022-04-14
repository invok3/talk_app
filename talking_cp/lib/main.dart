import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:talking_cp/consts.dart';
import 'package:talking_cp/pages/tabs/about_tab.dart';
import 'package:talking_cp/pages/tabs/categories_tab.dart';
import 'package:talking_cp/pages/tabs/edit_category_tab.dart';
import 'package:talking_cp/pages/tabs/edit_story_tab.dart';
import 'package:talking_cp/pages/tabs/edit_variant_tab.dart';
import 'package:talking_cp/pages/tabs/messages_tab.dart';
import 'package:talking_cp/pages/tabs/notification_tab.dart';
import 'package:talking_cp/pages/tabs/preview_page.dart';
import 'package:talking_cp/pages/tabs/profile_tab.dart';
import 'package:talking_cp/pages/tabs/stories_tab.dart';
import 'package:talking_cp/pages/tabs/variants_tab.dart';
import 'package:talking_cp/providers/reading_provider.dart';
import 'package:talking_cp/providers/user_provider.dart';
import 'package:talking_cp/state_manager.dart';

void main() async {
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
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<UserProvider>(create: (_) => UserProvider()),
      ChangeNotifierProvider<Reading>(create: (_) => Reading())
    ],
    child: MyApp(),
  ));
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      locale: Locale('en', 'UK'),
      supportedLocales: [
        Locale('en', 'UK'),
      ],
      color: kPrimary,
      theme: ThemeData(primaryColor: kPrimary, primarySwatch: kPrimary),
      darkTheme: ThemeData(primaryColor: kPrimary, primarySwatch: kPrimary),
      debugShowCheckedModeBanner: false,
      //showPerformanceOverlay: true,
      routes: {
        "/": (context) => StateManager(),
        VariantsTab.routeName: (context) => VariantsTab(),
        CategoriesTab.routeName: (context) => CategoriesTab(),
        StoriesTab.routeName: (context) => StoriesTab(),
        EditVariantTab.routeName: (context) => EditVariantTab(),
        EditCategoryTab.routeName: (context) => EditCategoryTab(),
        EditStoryTab.routeName: (context) => EditStoryTab(),
        ProfileTab.routeName: (context) => ProfileTab(),
        PreviewPage.routeName: (context) => PreviewPage(),
        AboutTab.routeName: (context) => AboutTab(),
        MessagesTab.routeName: (context) => MessagesTab(),
        NotificationTab.routeName: (context) => NotificationTab()
      },
      initialRoute: "/",
    );
  }
}
