import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:security_rules_sample/common/convert_error_message.dart';

class MyAccountModel extends ChangeNotifier {
  MyAccountModel() {
    this.isLoading = false;
    this.auth = FirebaseAuth.instance.currentUser;
  }

  bool isLoading;
  User auth;

  Future<void> signOut() async {
    try {
      await FirebaseAuth.instance.signOut();
    } catch (e) {
      print('${e.code}: $e');
      throw (convertErrorMessage(e.code));
    }
  }

  void startLoading() {
    this.isLoading = true;
    notifyListeners();
  }

  void endLoading() {
    this.isLoading = false;
    notifyListeners();
  }
}
