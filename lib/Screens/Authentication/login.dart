import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:hugeicons/hugeicons.dart';
import 'package:ict_faculties/Controllers/login_controller.dart';
import 'package:ict_faculties/Helper/colors.dart';
import 'package:ict_faculties/Screens/Splash/ict_logo.dart';

import '../../Helper/Components.dart';
import '../../Helper/size.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool isVisible = true;
  bool isLoading = false;

  // FocusNodes for text fields
  final FocusNode _enrollmentNumberFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();

  TextEditingController username = TextEditingController(text: "1327");
  TextEditingController password = TextEditingController(text: "Chandrasinh@1327");

  LoginController loginControl = Get.put(LoginController());
  @override
  void dispose() {
    _enrollmentNumberFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Center(
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  // Image(
                  //   image: AssetImage(MuLogo),
                  //   height: 100,
                  // ),
                  IctLogo(),
                  const SizedBox(height: 50),
                  SizedBox(
                    width: getWidth(context, 0.9),
                    child: Column(
                      children: [
                        TextField(
                          controller: username,
                          cursorColor: muColor,
                          keyboardType: TextInputType.number,
                          inputFormatters: [
                            LengthLimitingTextInputFormatter(6),
                          ],
                          textAlignVertical: TextAlignVertical.center,
                          decoration: InputDecoration(
                            labelText: 'Faculty ID',
                            hintText: 'Enter Faculty ID',
                            hintStyle: TextStyle(
                              fontFamily: "mu_reg",
                              color: muGrey2,
                            ),
                            prefixIcon: HugeIcon(
                                icon: HugeIcons.strokeRoundedUserAccount,
                                color: Colors.grey),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: muGrey2, width: 1.5),
                              borderRadius: BorderRadius.circular(borderRad),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: muGrey2, width: 1.5),
                              borderRadius: BorderRadius.circular(borderRad),
                            ),
                          ),
                          style: TextStyle(
                            fontSize: getSize(context, 2.5),
                            fontFamily: "mu_reg",
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 25),
                        TextField(
                          obscureText: isVisible,
                          controller: password,
                          decoration: InputDecoration(
                            labelText: "Password",
                            prefixIcon: Icon(
                              HugeIcons.strokeRoundedKey01,
                              color: Colors.grey, // Change icon color
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: muGrey2, width: 1.5),
                              borderRadius: BorderRadius.circular(borderRad),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: muGrey2, width: 1.5),
                              borderRadius: BorderRadius.circular(borderRad),
                            ),
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    isVisible = !isVisible;
                                  });
                                },
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 10.0),
                                  child: HugeIcon(
                                      icon: !isVisible
                                          ? HugeIcons.strokeRoundedView
                                          : HugeIcons.strokeRoundedViewOff,
                                      color: Colors.grey),
                                )),
                          ),
                          style: TextStyle(
                            fontSize: getSize(context, 2.5),
                            fontFamily: "mu_reg",
                            fontWeight: FontWeight.w500,
                          ),
                          onTap: () {
                            setState(
                                () {}); // To trigger rebuild and change icon color on tap
                          },
                        ),
                        SizedBox(height: 20),
                        InkWell(
                            onTap: () => Get.toNamed("forgotPass"),
                            child: Text("Forgot password?",
                                style: TextStyle(fontFamily: "mu_bold"))),
                        SizedBox(height: 30),
                        InkWell(
                          onTap: () async {
                            setState(() {
                              isLoading = true;
                            });

                            // DEBUG: print entered credentials
                            print("Login Button Tapped");
                            print("Username: ${username.text}");
                            print("Password: ${password.text}");

                            if (await loginControl.login(
                                username.text, password.text)) {
                                  print("Login Success: navigating to dashboard");
                                  Get.offAllNamed("/dashboard");
                            } else {
                              print("Login Failed: Invalid credentials");
                              Get.snackbar("Login Failed",
                                  "Email or Password is invalid",
                                  backgroundColor: Colors.red,
                                  colorText: Colors.white);
                            }
                            setState(() {
                              isLoading = false;
                            });
                          },
                          child: Container(
                            height: MediaQuery.sizeOf(context).height * 0.06,
                            decoration: BoxDecoration(
                              color: Dark1,
                              borderRadius: BorderRadius.circular(borderRad),
                              boxShadow: [
                                BoxShadow(
                                  color: Dark1.withOpacity(0.3),
                                  spreadRadius: 0,
                                  blurRadius: 5,
                                  offset: Offset(0, 6),
                                ),
                              ],
                            ),
                            child: const Center(
                              child: Text(
                                "LOGIN",
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: "mu_reg",
                                  letterSpacing: 2,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
          if (isLoading)
            Center(
              child: Container(
                height: double.infinity,
                width: double.infinity,
                decoration: const BoxDecoration(color: Colors.black45),
                child: Image.asset(
                  'assets/gifs/loading.gif',
                  scale: 1.25,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
