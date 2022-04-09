import 'package:flutter/material.dart';

class Reading extends ChangeNotifier {
  String? catID;
  String? storyID;
  Reading() {
    catID = null;
    storyID = null;
  }

  void setCatID(String? id) {
    catID = id;
    notifyListeners();
  }

  void setStoryID(String? id) {
    storyID = id;
    notifyListeners();
  }
}
