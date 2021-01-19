import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:security_rules_sample/common/convert_error_message.dart';

class EmailEditModel extends ChangeNotifier {
  EmailEditModel() {
    this.isLoading = false;
    this.auth = FirebaseAuth.instance.currentUser;
    this.email = '';
    this.password = '';
    this.showEmailError = false;
    this.showPasswordError = false;
    this.isEmailValid = false;
    this.isPasswordValid = false;
    this.isFormValid = false;
  }

  bool isLoading;
  User auth;
  String email;
  String password;
  bool showEmailError;
  bool showPasswordError;
  bool isEmailValid;
  bool isPasswordValid;
  bool isFormValid;

  Future<void> updateEmail() async {
    try {
      EmailAuthCredential emailAuthCredential = EmailAuthProvider.credential(
        email: auth.email,
        password: this.password,
      );
      await auth.reauthenticateWithCredential(emailAuthCredential);
    } catch (e) {
      print('エラーコード：${e.code}\nエラー：$e');
      throw (convertErrorMessage(e.code));
    }

    try {
      await auth.updateEmail(this.email);
      DocumentReference _userDocument =
          FirebaseFirestore.instance.collection('users').doc(auth.uid);
      await _userDocument.update({'email': this.email});
    } catch (e) {
      print('エラーコード：${e.code}\nエラー：$e');
      throw (convertErrorMessage(e.code));
    }
  }

  void changeEmail(text) {
    this.email = text;
    if (text.length == 0) {
      this.showEmailError = true;
      this.isEmailValid = false;
    } else {
      this.showEmailError = false;
      this.isEmailValid = true;
    }
    checkSubmitButtonState();
    notifyListeners();
  }

  void changePassword(text) {
    this.password = text;
    if (this.password.length == 0) {
      this.showPasswordError = true;
      this.isPasswordValid = false;
    } else if (this.password.length < 8) {
      this.showPasswordError = true;
      this.isPasswordValid = false;
    } else if (this.password.length > 20) {
      this.showPasswordError = true;
      this.isPasswordValid = false;
    } else {
      this.showPasswordError = false;
      this.isPasswordValid = true;
    }
    checkSubmitButtonState();
    notifyListeners();
  }

  void checkSubmitButtonState() {
    this.isFormValid = this.isEmailValid && this.isPasswordValid;
    notifyListeners();
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
