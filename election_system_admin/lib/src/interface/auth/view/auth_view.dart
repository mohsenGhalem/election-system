import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../common/widgets/input_field.dart';
import '../../../common/widgets/snack_bar.dart';
import '../controller/auth_controller.dart';

class AuthView extends StatelessWidget {
  final GlobalKey<FormState> formKey = GlobalKey();

  AuthView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final AuthController controller = Get.put(AuthController());

    return Scaffold(
      body: Container(
        height: size.height,
        width: size.width,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/background.jpg"),
            fit: BoxFit.cover,
            colorFilter: ColorFilter.mode(
              Colors.black54,
              BlendMode.darken,
            ),
          ),
        ),
        child: Form(
          key: formKey,
          child: SizedBox(
            width: size.width * 0.5,
            child: Obx(
              () {
                return ListView(
                  children: [
                    CircleAvatar(
                      radius: 60,
                      child: Image.asset('assets/images/logo.png'),
                    ),
                    const Text(
                      "Election System Adminstration",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 40,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 30),
                    if (controller.authState.value == AuthState.signup)
                      InputField(
                        controller: controller.nameController,
                        key: const ValueKey('name'),
                        hint: "enter your full name here",
                        onchange: controller.setName,
                        icon: const Icon(Icons.person),
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "you forgot to enter your full name ";
                          }
                          return null;
                        },
                      ),
                    InputField(
                      controller: controller.emailController,
                      key: const ValueKey('email'),
                      hint: "enter your email here",
                      onchange: controller.setEmail,
                      icon: const Icon(Icons.email),
                      validator: (p0) {
                        if (p0 == null || p0.isEmpty) {
                          return "you forgot to enter your email";
                        }
                        return null;
                      },
                    ),
                    InputField(
                        controller: controller.passwordController,
                        key: const ValueKey('pass'),
                        title: "Password",
                        hint: "enter your password here",
                        obscureText: true,
                        icon: const Icon(Icons.lock),
                        validator: (p0) {
                          if (p0 == null || p0.isEmpty) {
                            return "you forgot to enter the password";
                          }
                          return null;
                        },
                        onchange: controller.setPassword),
                    if (controller.authState.value == AuthState.signup)
                      InputField(
                        key: const ValueKey('cpass'),
                        title: "Confirm Password",
                        obscureText: true,
                        icon: const Icon(Icons.lock),
                        hint: "confirm your password here",
                        validator: (value) {
                          if (controller.authData['password'] != value) {
                            return "Passwords should be the same";
                          }
                          return null;
                        },
                      ),
                    const SizedBox(height: 30),
                    SizedBox(
                      height: 35,
                      width: 400,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25.0),
                          ),
                        ),
                        onPressed: () => validate(controller),
                        child: Text(
                          controller.authState.value == AuthState.signup
                              ? "Sign up"
                              : "Login",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    TextButton(
                      onPressed: () {
                        if (controller.authState.value == AuthState.signup) {
                          controller.setAuthState(AuthState.login);
                        } else {
                          controller.setAuthState(AuthState.signup);
                        }
                      },
                      child: Text(
                        controller.authState.value == AuthState.signup
                            ? "I have an account"
                            : "Create account",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  validate(AuthController controller) async {
    if (formKey.currentState!.validate()) {
      Get.dialog<bool>(
              AlertDialog(
                backgroundColor: Colors.white,
                title: Center(
                  child: FutureBuilder(
                    future: controller.authState.value == AuthState.signup
                        ? controller.signUp()
                        : controller.signIn(),
                    builder: (BuildContext context, AsyncSnapshot snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        Get.back(result: snapshot.data);
                      }
                      return const Column(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          CircularProgressIndicator(),
                          Text('Loading...')
                        ],
                      );
                    },
                  ),
                ),
              ),
              barrierDismissible: false)
          .then(
        (value) {
          if (value == true) {
            Get.offAllNamed('/home');
          }
          if (controller.errorMsg.isNotEmpty && value != true) {
            Get.showSnackbar(buildSnackBar(
                title: 'Error',
                message: controller.errorMsg,
                color: Colors.red));
          }
        },
      );
    }
  }
}
