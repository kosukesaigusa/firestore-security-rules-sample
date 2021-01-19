import 'package:cloud_firestore/cloud_firestore.dart';

/// FirebaseAuth の User とクラス名が被るので AppUser と命名
class AppUser {
  AppUser() {
    this.documentId = '';
    this.userId = '';
    this.email = '';
  }

  String documentId;
  String userId;
  String email;

  void getFieldValuesFromDB(DocumentSnapshot doc) {
    this.documentId = doc.id;
    this.userId = doc.data()['userId'];
    this.email = doc.data()['email'];
  }
}
