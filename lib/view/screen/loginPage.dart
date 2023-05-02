import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controller/FireBaseAuth.dart';
import '../../controller/FireStoreHelper.dart';
import '../../modal/global.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({Key? key}) : super(key: key);

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();

  final TextEditingController emailLoginController = TextEditingController();
  final TextEditingController passwordLoginController = TextEditingController();

  String? email;
  String? password;
  bool isVisible = false;

  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(2),
        child: Container(
          padding: const EdgeInsets.only(right: 10, left: 10),
          alignment: Alignment.center,
          height: height,
          width: width,
          child: Form(
            key: loginFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(
                  height: 20,
                ),
                Image.asset('assets/images/vote1.png'),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Sign In,start",
                      style: TextStyle(
                        color: Colors.cyan.shade900,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      "Voting!",
                      style: TextStyle(
                        color: Colors.cyan.shade900,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                TextFormField(
                  keyboardType: TextInputType.emailAddress,
                  style: TextStyle(color: Colors.cyan.shade900),
                  decoration: InputDecoration(
                    hintText: "Enter Voter email",
                    hintStyle: TextStyle(color: Colors.cyan.shade900),
                    focusColor: Colors.grey,
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.cyan.shade900,
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        style: BorderStyle.solid,
                        color: Colors.grey,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.cyan.shade900),
                    labelText: "Voter email",
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  controller: emailLoginController,
                  onSaved: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter your email first" : null,
                ),
                const SizedBox(
                  height: 10,
                ),
                TextFormField(
                  style: TextStyle(color: Colors.cyan.shade900),
                  keyboardType: TextInputType.visiblePassword,
                  obscureText: isVisible,
                  decoration: InputDecoration(
                    hintText: "Enter Voter password",
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: Colors.cyan.shade900,
                    ),
                    hintStyle: TextStyle(color: Colors.cyan.shade900),
                    border: const OutlineInputBorder(),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey),
                    ),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: Icon(
                        Icons.visibility,
                        color: Colors.cyan.shade900,
                      ),
                    ),
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        color: Colors.grey,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.cyan.shade900),
                    labelText: "Voter password",
                  ),
                  controller: passwordLoginController,
                  onSaved: (val) {
                    setState(() {
                      password = val;
                    });
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter your password first" : null,
                ),
                const Spacer(),
                Center(
                  child: ElevatedButton(
                    onPressed: () async {
                      if (loginFormKey.currentState!.validate()) {
                        loginFormKey.currentState!.save();
                        await CloudFireStoreHelper.firebaseFireStore
                            .collection('user')
                            .doc(email!)
                            .snapshots()
                            .forEach((element) async {
                          Global.user = {
                            'email': element.data()?['email'],
                            'vote': element.data()?['vote'],
                          };

                          User? user = await FireBaseAuthHelper
                              .fireBaseAuthHelper
                              .loginUser(email: email!, password: password!);

                          if (user != null) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text("Login Successful..."),
                                backgroundColor: Colors.cyan.shade900,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );

                            Navigator.of(context).pushReplacementNamed('/');
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("Login Failed....."),
                                backgroundColor: Colors.cyan,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                          email = "";
                          password = "";
                          emailLoginController.clear();
                          passwordLoginController.clear();
                        });
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.cyan.shade900,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 170, vertical: 15)),
                    child: const Text(
                      "Login",
                      style: TextStyle(
                          color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 5,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Not Yet Resister?",
                      style: TextStyle(
                        color: Colors.cyan.shade700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('r_page');
                      },
                      child: Text(
                        "New",
                        style: TextStyle(
                          color: Colors.cyan.shade900,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
