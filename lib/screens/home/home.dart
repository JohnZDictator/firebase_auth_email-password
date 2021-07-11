import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class Home extends StatefulWidget {
  final UserCredential userCredential;

  const Home({Key? key, required this.userCredential}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Home'),
      ),
      body: Container(
        child: Column(
          children: [
            Text('${widget.userCredential.user}'),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: signOut,
              child: const Text("Sign Out"),
            ),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            // Image(
            //   image: AssetImage(
            //     'assets/images/download.jpeg',
            //   ),
            // ),
          ],
        ),
      ),
    );
  }

  Future<void> signOut() async {
    await FirebaseAuth.instance.signOut();
    Get.back();
  }
}
