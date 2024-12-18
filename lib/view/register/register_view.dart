import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String selectedItem = 'Student';
  List options = ['Teacher', 'Student'];

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final idController = TextEditingController();
  final sessionController = TextEditingController();
  bool passToggle = true;
  bool visible = true;

  FirebaseFirestore firestore = FirebaseFirestore.instance;
  FirebaseAuth auth = FirebaseAuth.instance;
  User? user;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Register'),
        centerTitle: true,
      ),
      body: Center(
        child: SingleChildScrollView(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Image(
                  image: AssetImage(
                    'assets/register.jpeg',
                  ),
                  width: 150),
              const SizedBox(height: 35),
              DropdownButton(
                value: selectedItem,
                items: options
                    .map(
                      (day) => DropdownMenuItem(
                        child: Text(day),
                        value: day,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedItem = value.toString();
                    if (value == "Teacher") {
                      visible = false;
                    } else {
                      visible = true;
                    }
                  });
                },
              ),
              Container(
                padding: const EdgeInsets.all(6),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      controller: nameController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          label: Text("Name"),
                          hintText: 'Enter Name',
                          prefixIcon: Icon(Icons.perm_identity_sharp),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(25.0)),
                          )),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    Visibility(
                      visible: visible,
                      child: TextFormField(
                        controller: idController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            label: Text("Student ID"),
                            hintText: 'Enter ID',
                            prefixIcon: Icon(Icons.manage_accounts),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            )),
                      ),
                    ),
                    Visibility(
                        visible: visible,
                        child: const SizedBox(
                          height: 8,
                        )),
                    Visibility(
                      visible: visible,
                      child: TextFormField(
                        controller: sessionController,
                        textAlign: TextAlign.center,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                            label: Text("Session"),
                            hintText: 'Enter Session',
                            prefixIcon: Icon(Icons.cached_rounded),
                            contentPadding: EdgeInsets.symmetric(
                                vertical: 10.0, horizontal: 20.0),
                            border: OutlineInputBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(25.0)),
                            )),
                      ),
                    ),
                    Visibility(
                        visible: visible,
                        child: const SizedBox(
                          height: 8,
                        )),
                    TextFormField(
                      controller: emailController,
                      textAlign: TextAlign.center,
                      keyboardType: TextInputType.emailAddress,
                      decoration: const InputDecoration(
                          label: Text("Email"),
                          hintText: 'Enter Email',
                          prefixIcon: Icon(Icons.email),
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          )),
                    ),
                    const SizedBox(
                      height: 8.0,
                    ),
                    TextField(
                      controller: passwordController,
                      textAlign: TextAlign.center,
                      obscureText: passToggle,
                      decoration: InputDecoration(
                          label: const Text("Password"),
                          hintText: "Enter Password",
                          prefixIcon: const Icon(Icons.lock),
                          suffixIcon: InkWell(
                            onTap: () {
                              setState(() {
                                passToggle = !passToggle;
                              });
                            },
                            child: Icon(passToggle
                                ? Icons.visibility
                                : Icons.visibility_off),
                          ),
                          contentPadding: const EdgeInsets.symmetric(
                              vertical: 10.0, horizontal: 20.0),
                          border: const OutlineInputBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(32.0)),
                          )),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 15.0),
                child: Material(
                  elevation: 5.0,
                  color: Colors.blueAccent,
                  borderRadius: BorderRadius.circular(30.0),
                  child: MaterialButton(
                    onPressed: () async {
                      try {
                        UserCredential userCredential =
                            await auth.createUserWithEmailAndPassword(
                                email: emailController.text,
                                password: passwordController.text);
                        user = userCredential.user;
                        await user!.updateDisplayName(nameController.text);
                        await user!.reload();
                        user = auth.currentUser;

                        if (selectedItem == 'Teacher') {
                          firestore
                              .collection('teachers')
                              .doc(userCredential.user!.uid)
                              .set({
                            'email': emailController.text,
                            'name': nameController.text,
                            'pass': passwordController.text,
                            'uid': userCredential.user!.uid,
                            'type': selectedItem.toString(),
                          });
                        }
                        if (selectedItem == 'Student') {
                          firestore
                              .collection('students')
                              .doc(userCredential.user!.uid)
                              .set({
                            'uid': userCredential.user!.uid,
                            'email': emailController.text,
                            'name': nameController.text,
                            'pass': passwordController.text,
                            'type': selectedItem.toString(),
                            'id': idController.text,
                            'session': sessionController.text,
                          });
                        }

                        if (user != null) {
                          //Navigator.pushNamed(context,"splash2");
                          // Navigator.of(context).push(MaterialPageRoute(
                          //     builder: (ctx) => SplashScreen2(selectedItem)));
                          Fluttertoast.showToast(
                              msg: "Succesfull Registered",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                              backgroundColor: Colors.blue,
                              textColor: Colors.white,
                              fontSize: 18.0);
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'week-password') {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                              'Week password, try to strong',
                              style: TextStyle(fontSize: 16),
                            ),
                            backgroundColor: Colors.orange,
                          ));
                        }
                        if (e.code == 'email-already in use') {
                          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                            content: Text(
                              'Email already exist! Please try new.',
                              style: TextStyle(fontSize: 16),
                            ),
                            backgroundColor: Colors.orange,
                          ));
                        }
                      } catch (e) {
                        print(e);
                      }
                    },
                    minWidth: 200.0,
                    height: 42.0,
                    child: const Text(
                      "Register",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("Already have an account?  "),
                  InkWell(
                    child: const Text(
                      "Login now",
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () {
                      Navigator.pushNamed(context, "login");
                    },
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
