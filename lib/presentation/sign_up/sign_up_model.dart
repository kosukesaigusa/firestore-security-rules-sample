import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:security_rules_sample/common/convert_error_message.dart';

class SignUpModel extends ChangeNotifier {
  SignUpModel() {
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

  Future<void> signUp() async {
    UserCredential _userCredential;

    try {
      _userCredential =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: this.email,
        password: this.password,
      );

      if (_userCredential == null) {
        return;
      }

      await FirebaseFirestore.instance
          .collection('users')
          .doc(_userCredential.user.uid)
          .set(
        {
          'userId': _userCredential.user.uid,
          'email': _userCredential.user.email,
          'createdAt': FieldValue.serverTimestamp(),
        },
      );
    } catch (e) {
      print(e);
      throw (convertErrorMessage(e.code));
    }
  }

  void changeEmail(text) {
    this.email = text;
    if (this.email.length == 0) {
      this.showEmailError = true;
      this.isEmailValid = false;
    } else if (this.email.length > 100) {
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
