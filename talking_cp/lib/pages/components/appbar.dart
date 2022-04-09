import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:talking_cp/pages/components/func.dart';
import 'package:talking_cp/pages/tabs/profile_tab.dart';

class MyAppBar extends StatefulWidget implements PreferredSizeWidget {
  //final AppBar appBar;
  final String title;
  const MyAppBar(
      {Key? key,
      //required this.appBar,
      required this.title})
      : super(key: key);

  @override
  State<MyAppBar> createState() => _MyAppBarState();

  @override
  Size get preferredSize => Size.fromHeight(AppBar().preferredSize.height);
}

class _MyAppBarState extends State<MyAppBar> {
  late bool isProtrait;

  @override
  Widget build(BuildContext context) {
    isProtrait = isPortrait(context: context);
    return AppBar(
      automaticallyImplyLeading: true,
      foregroundColor: Colors.white,
      title: Text(widget.title),
      actions: [
        PopupMenuButton<int>(
          tooltip: "Options",
          child: isProtrait
              ? null
              : Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(width: 8),
                    CircleAvatar(
                      foregroundImage:
                          FirebaseAuth.instance.currentUser?.photoURL == null
                              ? null
                              : NetworkImage(
                                  FirebaseAuth.instance.currentUser!.photoURL!),
                    ),
                    SizedBox(width: 8),
                    Text(FirebaseAuth.instance.currentUser?.displayName ??
                        FirebaseAuth.instance.currentUser?.email
                            ?.split("@")
                            .first ??
                        "Unknown"),
                    Icon(Icons.arrow_drop_down),
                    SizedBox(width: 8),
                  ],
                ),
          itemBuilder: (context) => [
            PopupMenuItem(
                child: Row(
                  children: [
                    Text("Admin Profile"),
                    Spacer(),
                    Icon(
                      Icons.person,
                      color: Colors.grey,
                    )
                  ],
                ),
                value: 0),
            PopupMenuItem(
                child: Row(
                  children: [
                    Text("Logout"),
                    Spacer(),
                    Icon(
                      Icons.logout,
                      color: Colors.grey,
                    )
                  ],
                ),
                value: 1),
          ],
          onSelected: (x) async {
            if (x == 1) {
              await FirebaseAuth.instance.signOut();
              Navigator.of(context).pushReplacementNamed("/");
            }
            if (x == 0) {
              Navigator.pushReplacementNamed(context, ProfileTab.routeName);
            }
          },
          elevation: 0,
        ),
      ],
    );
  }
}
