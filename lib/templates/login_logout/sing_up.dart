import 'package:flutter/material.dart';
import 'package:gestion_projets_app/templates/login_logout/home.dart';
import 'package:gestion_projets_app/templates/login_logout/login.dart';
import 'package:gestion_projets_app/templates/services/authentification.dart';
import 'package:gestion_projets_app/templates/widget/button.dart';
import 'package:gestion_projets_app/templates/widget/snack_bar.dart';
import 'package:gestion_projets_app/templates/widget/text_field.dart';

class SingUp extends StatefulWidget {
  const SingUp({super.key});

  @override
  State<SingUp> createState() => _SingUpState();
}

class _SingUpState extends State<SingUp> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmpasswordController =
      TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmpasswordController.dispose();
  }

  void signUpUser() async {
    String res = await AuthMethod().signUpUser(
      email: emailController.text,
      password: passwordController.text,
      confpassword: confirmpasswordController.text,
    );

    if (res == "success") {
      setState(() {
        isLoading = true;
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
                height: height / 2.8,
                child: Image.asset("images/signup.jpeg"),
              ),
              TextFieldInpute(
                icon: Icons.email,
                textEditingController: emailController,
                hintText: "Entrer votre email",
                textInputType: TextInputType.emailAddress,
              ),
              TextFieldInpute(
                icon: Icons.lock,
                textEditingController: passwordController,
                hintText: "Entrer votre mot de passe",
                textInputType: TextInputType.text,
                isPass: true,
              ),
              TextFieldInpute(
                icon: Icons.verified,
                textEditingController: confirmpasswordController,
                hintText: "Confirmer votre mot de passe",
                textInputType: TextInputType.text,
                isPass: true,
              ),
              MyButton(onTab: signUpUser, text: "Sign Up"),
              SizedBox(height: height / 15),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    "Alredy have an account ? ",
                    style: TextStyle(fontSize: 16),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const login(),
                        ),
                      );
                    },
                    child: const Text(
                      " Login",
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
