import 'package:flutter/material.dart';
import 'package:gestion_projets_app/templates/login_logout/home.dart';
import 'package:gestion_projets_app/templates/login_logout/sing_up.dart';
import 'package:gestion_projets_app/templates/password%20forget/forgot_password.dart';
import 'package:gestion_projets_app/templates/services/authentification.dart';
import 'package:gestion_projets_app/templates/widget/button.dart';
import 'package:gestion_projets_app/templates/widget/snack_bar.dart';
import 'package:gestion_projets_app/templates/widget/text_field.dart';

// ignore: camel_case_types
class login extends StatefulWidget {
  const login({super.key});

  @override
  State<login> createState() => _loginState();
}

// ignore: camel_case_types
class _loginState extends State<login> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
  }

  // email and passowrd auth part
  void loginUser() async {
    setState(() {
      isLoading = true;
    });
    // signup user using our authmethod
    String res = await AuthMethod().loginUser(
        email: emailController.text, password: passwordController.text);

    if (res == "success") {
      setState(() {
        isLoading = false;
      });
      //navigate to the home screen
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => const Home(),
        ),
      );
    } else {
      setState(() {
        isLoading = false;
      });
      // show error
      showSnackBar(context, res);
    }
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: SingleChildScrollView(
            child: SizedBox(
          child: Column(
            children: [
              SizedBox(
                width: double.infinity,
                height: height / 2.7,
                child: Image.asset("images/login.avif"),
              ),
              TextFieldInpute(
                  icon: Icons.email,
                  textEditingController: emailController,
                  hintText: "Entrer votre email",
                  textInputType: TextInputType.emailAddress),
              TextFieldInpute(
                icon: Icons.lock,
                textEditingController: passwordController,
                hintText: "Entrer votre mot de passe",
                textInputType: TextInputType.text,
                isPass: true,
              ),
              const ForgotPassword(),
              MyButton(onTab: loginUser, text: " Log In"),
              Row(
                children: [
                  Expanded(
                    child: Container(height: 1, color: Colors.black26),
                  ),
                  const Text("  or  "),
                  Expanded(
                    child: Container(height: 1, color: Colors.black26),
                  )
                ],
              ),
              SizedBox(height: height / 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Don't have an accunt ? ",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const SingUp(),
                        ),
                      );
                    },
                    child: const Text(
                      " SignUp",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                    ),
                  )
                ],
              )
            ],
          ),
        )),
      ),
    );
  }
}
