import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class UserProvider with ChangeNotifier {
  Map<String, dynamic>? userData;

  Future<void> fetchUserData(String userId) async {
    try {
      var doc = await FirebaseFirestore.instance.collection('dummy users').doc(userId).get();
      userData = doc.data();
      notifyListeners();
    } catch (error) {
      print(error);
    }
  }
}