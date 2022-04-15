import 'package:flutter/material.dart';
import 'package:talking_app/controllers/firebase_api.dart';
import 'package:talking_app/main.dart';

Future<void> selectVariant(BuildContext context) async {
  String? result = await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      content: FutureBuilder(
        future: FirebaseAPI.fetchVars(),
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [CircularProgressIndicator()],
            );
          } else if ((snapshot.data as List<Map<String, String>>).isEmpty) {
            return Row(
              children: [
                Text("An error accured while connecting to database.")
              ],
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: (snapshot.data as List<Map<String, String>>)
                    .map((e) => ListTile(
                          title: Text(e["title"] ?? "Unknown"),
                          subtitle: Text(e["Description"] ?? ""),
                          onTap: () => Navigator.of(context).pop(e["id"]),
                        ))
                    .toList(),
              ),
            );
          }
        },
      ),
    ),
    barrierDismissible: false,
  );
  if (result != null) {
    await sp.setString("variantID", result);
    variantID = result;
  }
}
