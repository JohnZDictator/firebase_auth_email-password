import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:get/get.dart';

class Register extends StatefulWidget {
  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {
  late String _name, _email, _password;
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Registeration page'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
                border: OutlineInputBorder(),
              ),
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Please Enter Name';
                }
                return null;
              },
              onSaved: (input) => _name = input!,
            ),
            const SizedBox(
              height: 5.0,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Email',
                border: OutlineInputBorder(),
              ),
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Please Enter Email';
                }
                return null;
              },
              onSaved: (input) => _email = input!,
            ),
            const SizedBox(
              height: 5.0,
            ),
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Password',
                border: OutlineInputBorder(),
              ),
              obscureText: true,
              validator: (input) {
                if (input == null || input.isEmpty) {
                  return 'Please Enter Password';
                }
                return null;
              },
              onSaved: (input) => _password = input!,
            ),
            const SizedBox(
              height: 5.0,
            ),
            ElevatedButton(
              onPressed: signup,
              child: const Text('sign up'),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signup() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      Firebase.initializeApp();
      try {
        UserCredential userCredential = await FirebaseAuth.instance
            .createUserWithEmailAndPassword(email: _email, password: _password);
        Get.back();
      } on FirebaseAuthException catch (e) {
        if (e.code == 'weak-password') {
          print('The password provided is too weak');
        } else if (e.code == 'email-already-in-use') {
          print('The account already exists for that email');
        }
      } catch (e) {
        print(e);
      }
    }
  }
}
