import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:test_01/view/login/login_view_controller.dart';
import 'package:test_01/view/register/register_view.dart';
import 'package:test_01/view/student_dashboard/student_dashboard_view.dart';
import 'package:test_01/view/teacher_dashboard/teacher_dashboard_view.dart';
import 'package:test_01/widgets/dialog/alert_custom_dialog.dart';
import 'package:test_01/widgets/drop_down/my_dropdown_button.dart';

class LoginView extends StatelessWidget {
  final _controller = Get.put(LoginViewController());
  LoginView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              SizedBox(
                  height: 200,
                  width: 200,
                  child: Image.asset('assets/login.jpeg', width: 150)),
              const SizedBox(
                height: 16,
              ),
              MyDropdownButton(
                  value: _controller.selectedType,
                  items: _controller.types,
                  hint: "Select Profession",
                  onChanged: (value) {
                    _controller.selectedType = value;
                  }),
              const SizedBox(height: 16),
              TextField(
                controller: _controller.emailController,
                textInputAction: TextInputAction.next,
                decoration: const InputDecoration(
                    label: Text("Email", style: TextStyle(fontSize: 16)),
                    // hintText: 'Enter Email',
                    prefixIcon: Icon(Icons.email),
                    contentPadding:
                        EdgeInsets.symmetric(vertical: 12.0, horizontal: 24.0),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.all(Radius.circular(8.0)),
                    )),
              ),
              const SizedBox(height: 16),
              Obx(() => TextField(
                    controller: _controller.passwordController,
                    textInputAction: TextInputAction.done,
                    obscureText: _controller.passToggle.value,
                    decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: InkWell(
                          onTap: () {
                            _controller.passToggle.value =
                                !_controller.passToggle.value;
                          },
                          child: Icon(_controller.passToggle.value
                              ? Icons.visibility
                              : Icons.visibility_off),
                        ),
                        label: const Text("Password",
                            style: TextStyle(fontSize: 16)),
                        contentPadding: const EdgeInsets.symmetric(
                            vertical: 12.0, horizontal: 24.0),
                        border: const OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(8.0)),
                        )),
                  )),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Material(
                  elevation: 5.0,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                      onPressed: () async {
                        if (_controller.emailController.text.isNotEmpty &&
                            _controller.passwordController.text.isNotEmpty &&
                            _controller.selectedType != null) {
                          if ((_controller.selectedType == 'Teacher' &&
                                  await _controller
                                      .fireStoreDataValidation('teachers')) ||
                              (_controller.selectedType == 'Student' &&
                                  await _controller
                                      .fireStoreDataValidation('students'))) {
                            if(_controller.selectedType == "Student"){
                              Future.delayed(const Duration(seconds: 1));
                              Get.off(() => HomePage());
                            }
                            else if(_controller.selectedType == "Teacher"){
                              Future.delayed(const Duration(seconds: 1));
                              Get.off(() => Homepage2());
                            }
                            AlertCustomDialogs()
                                .showSuccess(msg: "Successfully Logged in");
                            // flutterToast.toastMessage(
                            //     msg: "Successfully Logged in");
                            // if (!context.mounted) return;
                            // goRoute(context);

                          } else {
                            AlertCustomDialogs()
                                .showAlert(msg: "Wrong email or Password");
                            // flutterToast.toastMessage(
                            //     msg: "Wrong email or Password",
                            //     bgColor: Colors.red);
                          }
                        } else {
                          AlertCustomDialogs()
                              .showAlert(msg: " Please fill all field ");
                          // flutterToast.toastMessage(
                          //     msg: " Please fill all field ",
                          //     bgColor: Colors.white24,
                          //     textColor: Colors.black);
                        }
                      },
                      child: const Text(
                        "Sign In",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      )),
                ),
              ),
              const SizedBox(
                height: 6.0,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Don't have an account?  "),
                  InkWell(
                    child: const Text(
                      "Register now",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                     Get.to(RegisterPage());
                    },
                  )
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  // void goRoute(BuildContext context) {
  //   Navigator.of(context).push(MaterialPageRoute(
  //       builder: (ctx) => SplashScreen2(widget.selectedType!)));
  // }
}
