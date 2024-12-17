import 'package:get/get.dart';

class WelcomeViewController extends GetxController {
  @override
  void onInit() {
    appInit();
    super.onInit();
  }

  void appInit() async {
    await Future.delayed(const Duration(seconds: 2));
    // Get.off(() => AuthView());
  }
}
