import 'package:get/get.dart';
import 'package:test_01/view/auth/auth_view.dart';
import 'package:test_01/view/login/login_view.dart';

class WelcomeViewController extends GetxController {
  @override
  void onInit() {
    appInit();
    super.onInit();
  }

  void appInit() async {
    await Future.delayed(const Duration(seconds: 2));
    // Get.off(() => LoginView());
    Get.off(() => AuthView());
  }
}
