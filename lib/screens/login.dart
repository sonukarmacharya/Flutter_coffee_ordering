import 'package:coffee_ordering_app/screens/coffee_list.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';

import '../provider/login_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool rememberMe = false;
  final _email = TextEditingController();
  final _password = TextEditingController();
  String emailError = "";
  String pasError = "";
  bool passwordVisible = true;

  submit() {
    if (_email.text.isEmpty) {
      setState(() {
        emailError = "Email is required";
      });
    } else {
      if (_password.text.isEmpty) {
        setState(() {
          pasError = "Password is required";
        });
      } else {
        FirebaseFirestore.instance
            .collection('login')
            .get()
            .then((QuerySnapshot querySnapshot) {
          querySnapshot.docs.forEach((doc) {
            if (doc["email"] == _email.text &&
                doc["password"] == _password.text) {
              Get.to(() => ListScreen());
            } else {
              Get.snackbar("Error", "Email or password incorrect",
                  backgroundColor: Colors.red, colorText: Colors.white);
            }
          });
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 25),
              child: Container(
                margin: EdgeInsets.only(top: 160),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.white,
                  border: Border.all(
                    color: Colors.grey.withOpacity(0.5),
                    width: 1.0,
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Align(
                      alignment: Alignment.center,
                      child: Text(
                        "Coffee Ordering App",
                      ),
                    ),
                    const Divider(),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      controller: _email,
                      decoration: const InputDecoration(
                          labelText: 'Email',
                          prefixIcon: Icon(Icons.account_box)),
                      onChanged: (value) {
                        setState(() {
                          emailError = "";
                        });
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "$emailError",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    TextFormField(
                      obscureText: passwordVisible,
                      controller: _password,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: Icon(Icons.vpn_key_sharp),
                        suffixIcon: GestureDetector(
                            onTap: () {
                              setState(() {
                                passwordVisible = !passwordVisible;
                              });
                            },
                            child: passwordVisible
                                ? Icon(Icons.remove_red_eye)
                                : Icon(Icons.remove_red_eye_outlined)),
                      ),
                      onChanged: (value) {
                        setState(() {
                          pasError = "";
                        });
                      },
                    ),
                    const SizedBox(
                      height: 5,
                    ),
                    Text(
                      "$pasError",
                      style: TextStyle(color: Colors.red, fontSize: 12),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    SizedBox(
                      width: MediaQuery.of(context).size.width,
                      child: ElevatedButton(
                        child: Text(
                          "Login",
                        ),
                        onPressed: submit,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
