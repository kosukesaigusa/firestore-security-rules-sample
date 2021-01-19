import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:security_rules_sample/common/convert_error_message.dart';

class ExpenseAddModel extends ChangeNotifier {
  ExpenseAddModel() {
    this.isLoading = false;
    this.auth = FirebaseAuth.instance.currentUser;
    this.content = '';
    this.price = null;
    this.showContentError = false;
    this.showPriceError = false;
    this.isContentValid = false;
    this.isPriceValid = false;
    this.isFormValid = false;
  }

  bool isLoading;
  User auth;
  String content;
  int price;
  bool showContentError;
  bool showPriceError;
  bool isContentValid;
  bool isPriceValid;
  bool isFormValid;

  void changeContent(text) {
    this.content = text;
    if (this.content.length == 0) {
      this.showContentError = true;
      this.isContentValid = false;
    } else if (this.content.length > 100) {
      this.showContentError = true;
      this.isContentValid = false;
    } else {
      this.showContentError = false;
      this.isContentValid = true;
    }
    checkSubmitButtonState();
    notifyListeners();
  }

  void changePrice(text) {
    try {
      this.price = int.parse(text);
    } catch (e) {
      this.price = null;
      this.showPriceError = true;
      this.isPriceValid = false;
      checkSubmitButtonState();
      notifyListeners();
    }
    if (text.length == 0) {
      this.showPriceError = true;
      this.isPriceValid = false;
    } else if (this.price < 0) {
      this.showPriceError = true;
      this.isPriceValid = false;
    } else if (this.price > 1000000) {
      this.showPriceError = true;
      this.isPriceValid = false;
    } else {
      this.showPriceError = false;
      this.isPriceValid = true;
    }
    checkSubmitButtonState();
    notifyListeners();
  }

  void checkSubmitButtonState() {
    this.isFormValid = this.isContentValid && this.isPriceValid;
    notifyListeners();
  }

  Future<void> submit() async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(this.auth.uid)
          .collection('expenses')
          .add({
        'userId': this.auth.uid,
        'content': this.content,
        'price': this.price,
        'createdAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print(e);
      throw (convertErrorMessage(e.toString()));
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
