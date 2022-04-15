import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:talking_app/main.dart';

class FirebaseAPI {
  static Future<List<Map<String, String>>> fetchVars() async {
    try {
      var x = await FirebaseFirestore.instance.collection("variants").get();
      var list = x.docs
          .map((e) => {
                "id": e.id,
                "title": e["title"].toString(),
                "image": e["image"].toString(),
                "description": e["description"].toString()
              })
          .toList();
      // String? sid;
      // try {
      //   sid = list.where((element) => element["title"] == "Shared").first["id"];
      //   sp.setString("sharedID", sid);
      // } catch (e) {}
      list.removeWhere((element) => element["title"] == "Shared");
      return list;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<List<Map<String, String>>> fetchCats() async {
    try {
      var x = await FirebaseFirestore.instance.collection("categories").get();
      var list = x.docs
          .map((e) => {
                "id": e.id,
                "varID": e["varID"].toString(),
                "title": e["title"].toString(),
                "image": e["image"].toString(),
                "description": e["description"].toString()
              })
          .toList();
      String sharedID = await _getSharedID();
      list.removeWhere((element) =>
          !(element["varID"] == variantID || element["varID"] == sharedID));
      return list;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<List<Map<String, String>>> fetchElems() async {
    try {
      var x = await FirebaseFirestore.instance.collection("stories").get();
      var list = x.docs
          .map((e) => {
                "id": e.id,
                "title": e["title"].toString(),
                "varID": e["varID"].toString(),
                "catID": e["catID"].toString(),
                "imageLink": e["imageLink"].toString(),
                "audioFileLink": e["audioFileLink"].toString(),
                "description": e["description"].toString()
              })
          .toList();
      var shared = list;
      String sharedID = await _getSharedID();
      list.removeWhere((element) => element["varID"] != variantID);
      shared.removeWhere((element) => element["varID"] != sharedID);
      return list + shared;
    } catch (e) {
      debugPrint(e.toString());
      return [];
    }
  }

  static Future<String> _getSharedID() async {
    try {
      var x = await FirebaseFirestore.instance
          .collection("variants")
          .where("title", isEqualTo: "Shared")
          .limit(1)
          .get();
      return x.docs.first.id;
    } catch (e) {
      debugPrint(e.toString());
      return "";
    }
  }
}
