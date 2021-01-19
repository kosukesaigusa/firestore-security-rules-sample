import 'package:cloud_firestore/cloud_firestore.dart';

class Expense {
  Expense() {
    this.documentId = '';
    this.createdAt = null;
    this.content = '';
    this.price = 0;
  }

  String documentId;
  Timestamp createdAt;
  String content;
  int price;

  void getFieldValuesFromDB(DocumentSnapshot doc) {
    this.documentId = doc.id;
    this.createdAt = doc.data()['createdAt'];
    this.content = doc.data()['content'];
    this.price = doc.data()['price'];
  }
}
