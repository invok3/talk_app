import 'package:flutter/material.dart';
import 'package:talking_cp/pages/components/drawer_listview.dart';

class FlexSideBar extends StatelessWidget {
  final Widget child;

  const FlexSideBar({Key? key, required this.isProtrait, required this.child})
      : super(key: key);

  final bool isProtrait;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        isProtrait
            ? Container()
            : Material(
                elevation: 20,
                child: Container(
                  color: Colors.black54,
                  width: 250,
                  height: double.infinity,
                  child: MyDrawerListView(drawer: false),
                ),
              ),
        Expanded(child: child),
      ],
    );
  }
}
