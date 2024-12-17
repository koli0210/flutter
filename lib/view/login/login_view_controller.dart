import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:get/get.dart';
import 'package:test_01/widgets/dialog/alert_custom_dialog.dart';

class LoginViewController extends GetxController{
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  RxBool passToggle = RxBool(true);
  RxBool isLoading = RxBool(false);
  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;

  String? selectedType;
  List types = ['Teacher', 'Student'];

  Future<bool> fireStoreDataValidation(String collectionName) async {
   EasyLoading.show(status: "Loading...");
    QuerySnapshot querySnapshot =
    await FirebaseFirestore.instance.collection(collectionName).get();
    for (var doc in querySnapshot.docs) {
      if (doc.get('email') == emailController.text &&
          doc.get('pass') == passwordController.text && await signIn()) {
        EasyLoading.dismiss();
        return true;
      }
    }
   EasyLoading.dismiss();
    return false;
  }
  Future<bool> signIn() async {
    // EasyLoading.show(status: "Loading...");
    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );
      return true;
    } on FirebaseAuthException catch (e) {
      log(e.code);
      if(e.code == "invalid-credential"){
        return false;
        // AlertCustomDialogs()
        //     .showAlert(msg: "Incorrect Email or Password");
      }
    }
    return false;
    // EasyLoading.dismiss();
  }
}