import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class UserProvider extends ChangeNotifier {
  bool loadingUser = true;
  User? currentUser;
  UserProvider() {
    FirebaseAuth.instance.userChanges().listen((event) {
      currentUser = event;
      loadingUser = false;
      notifyListeners();
    });
  }
}
