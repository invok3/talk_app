import 'package:flutter/material.dart';

class Reading extends ChangeNotifier {
  String? catID;
  String? storyID;
  String? variantID;
  Reading() {
    catID = null;
    storyID = null;
    variantID = null;
  }

  void setCatID(String? id) {
    catID = id;
    notifyListeners();
  }

  void setStoryID(String? id) {
    storyID = id;
    notifyListeners();
  }

  void setVariantID(String? id) {
    variantID = id;
    notifyListeners();
  }
}
