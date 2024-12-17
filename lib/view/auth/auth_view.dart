import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_01/view/login/login_view.dart';
import 'package:test_01/view/student_dashboard/student_dashboard_view.dart';

class AuthView extends StatelessWidget {
  // final _controller = Get.put(AuthController());
  AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if(snapshot.hasData){
            return HomePage();
            }else{
              return LoginView();
            }
          }),
    );
  }
}
