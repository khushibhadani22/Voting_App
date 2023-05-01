import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import '../../controller/FireBaseAuth.dart';
import '../../controller/FireStoreHelper.dart';

class RegistrationPage extends StatefulWidget {
  const RegistrationPage({Key? key}) : super(key: key);

  @override
  State<RegistrationPage> createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  final GlobalKey<FormState> registerFormKey = GlobalKey<FormState>();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isVisible = false;
  String? email;
  String? password;
  @override
  Widget build(BuildContext context) {
    var height = MediaQuery.of(context).size.height;
    var width = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          // padding: const EdgeInsets.only(right: 10, left: 10),
          alignment: Alignment.center,
          height: height,
          width: width,
          child: Form(
            key: registerFormKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                const Spacer(),
                Image.asset('assets/images/vote1.png'),
                Text(
                  "Registered Your Account",
                  style: TextStyle(
                    color: Colors.cyan.shade900,
                    fontSize: 30,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                TextFormField(
                  style: TextStyle(color: Colors.cyan.shade900),
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: "Enter Voter email",
                    hintStyle: TextStyle(color: Colors.cyan.shade900),
                    focusColor: Colors.grey,
                    focusedBorder: const OutlineInputBorder(
                      borderSide: BorderSide(
                        width: 2,
                        style: BorderStyle.solid,
                        color: Colors.grey,
                      ),
                    ),
                    labelStyle: TextStyle(color: Colors.cyan.shade900),
                    labelText: "Voter email",
                    prefixIcon: Icon(
                      Icons.email_outlined,
                      color: Colors.cyan.shade900,
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey),
                    ),
                    border: const OutlineInputBorder(),
                  ),
                  controller: emailController,
                  onSaved: (val) {
                    setState(() {
                      email = val;
                    });
                  },
                  validator: (val) =>
                      (val!.isEmpty) ? "Enter your email first" : null,
                ),
                const SizedBox(height: 10),
                TextFormField(
                  obscureText: isVisible,
                  style: TextStyle(color: Colors.cyan.shade900),
                  keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                    hintText: "Enter Voter password",
                    hintStyle: TextStyle(color: Colors.cyan.shade900),
                    prefixIcon: Icon(
                      Icons.lock_outlined,
                      color: Colors.cyan.shade900,
                    ),
                    border: const OutlineInputBorder(),
                    suffixIcon: IconButton(
                      onPressed: () {
                        setState(() {
                          isVisible = !isVisible;
                        });
                      },
                      icon: const Icon(
                        Icons.visibility,
                        color: Colors.grey,
                      ),
                    ),
                    enabledBorder: const OutlineInputBorder(
                      borderSide: BorderSide(width: 3, color: Colors.grey),
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
                  controller: passwordController,
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
                      if (registerFormKey.currentState!.validate()) {
                        registerFormKey.currentState!.save();
                        User? user = await FireBaseAuthHelper.fireBaseAuthHelper
                            .registerUser(email: email!, password: password!);
                        if (user != null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: const Text("Register Successful...."),
                              backgroundColor: Colors.cyan.shade900,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                          await CloudFireStoreHelper.cloudFireStoreHelper
                              .insertRecord(email: email!, vote: false);
                          Navigator.of(context)
                              .pushReplacementNamed('login_page');
                        } else {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Register Failed...."),
                              backgroundColor: Colors.cyan,
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                        email = "";
                        password = "";
                        emailController.clear();
                        passwordController.clear();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                        elevation: 5,
                        backgroundColor: Colors.cyan.shade900,
                        padding: const EdgeInsets.symmetric(
                            horizontal: 160, vertical: 15)),
                    child: const Text(
                      "Register",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Already have a Resister?",
                      style: TextStyle(
                        color: Colors.cyan.shade700,
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pushNamed('login_page');
                      },
                      child: Text(
                        "Log In",
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
