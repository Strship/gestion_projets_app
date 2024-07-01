import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class AuthMethod {
  //for storing data in cloud firestore
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  //for authentification
  final FirebaseAuth _auth = FirebaseAuth.instance;

//for signup
  Future<String> signUpUser({
    required String email,
    required String password,
    required String confpassword,
  }) async {
    String res = " Some error Occured";
    if (email.isEmpty || password.isEmpty || confpassword.isEmpty) {
      // Affiche un message d'erreur si un des champs est vide
      res = "Please fill all the fields.";
    } else if (password != confpassword) {
      // Affiche un message d'erreur si les mots de passe ne correspondent pas
      res = "Passwords do not match.";
    } else {
      // Si tous les champs sont remplis et les mots de passe correspondent
      try {
        UserCredential credential = await _auth.createUserWithEmailAndPassword(
          email: email,
          password: password,
        );

        // Ajout de l'utilisateur dans notre cloud firestore
        await _firestore.collection("users").doc(credential.user!.uid).set({
          "email": email,
          'uid': credential.user!.uid,
        });
        res = "Successfully";
      } catch (e) {
        // Gestion des erreurs (par exemple, email déjà utilisé)
        res = e.toString();
      }
    }

    return res;
  }

  // logIn user
  Future<String> loginUser({
    required String email,
    required String password,
  }) async {
    String res = "Some error Occurred";
    try {
      if (email.isNotEmpty || password.isNotEmpty) {
        // logging in user with email and password
        await _auth.signInWithEmailAndPassword(
          email: email,
          password: password,
        );
        res = "success";
      } else {
        res = "Please enter all the fields";
      }
    } catch (err) {
      return err.toString();
    }
    return res;
  }

  // for sighout
  signOut() async {
    // await _auth.signOut();
  }
}
