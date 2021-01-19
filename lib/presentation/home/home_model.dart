import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:security_rules_sample/domain/expense.dart';

class HomeModel extends ChangeNotifier {
  HomeModel() {
    this.isLoading = false;
    this.auth = FirebaseAuth.instance.currentUser;
    this.expenseList = [];
  }

  bool isLoading;
  User auth;
  List<Expense> expenseList;

  Future<void> fetchExpenses() async {
    startLoading();
    try {
      QuerySnapshot _expensesQuerySnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(this.auth.uid)
          .collection('expenses')
          .orderBy('createdAt', descending: true)
          .get();
      this.expenseList = _expensesQuerySnapshot.docs
          .map((doc) => Expense()..getFieldValuesFromDB(doc))
          .toList();
    } catch (e) {
      print(e);
    }
    endLoading();
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
