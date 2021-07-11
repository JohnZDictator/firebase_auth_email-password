import 'package:firebase_auth_email_password/screens/authentication/widgets/register.dart';
import 'package:firebase_auth_email_password/screens/home/home.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';

class SigninPage extends StatefulWidget {
  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  late String _email, _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Firebase.initializeApp();
    return Scaffold(
      appBar: AppBar(
        title: const Text('Log in page'),
      ),
      body: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
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
              onPressed: signin,
              child: const Text('sign in'),
            ),
            const SizedBox(
              height: 5,
            ),
            ElevatedButton(
              onPressed: siginWithGoogle,
              child: const Text('Sign in With GOOGLE'),
            ),
            const SizedBox(
              height: 5,
            ),
            const Text("Don't have an account? "),
            GestureDetector(
              child: const Text(
                "Create an Account",
                style: TextStyle(
                  color: Colors.blue,
                ),
              ),
              onTap: () => Get.to(() => Register()),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> signin() async {
    final formState = _formKey.currentState;
    if (formState!.validate()) {
      formState.save();
      try {
        Firebase.initializeApp();
        UserCredential userCredential = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        // Navigator.push(
        //     context, MaterialPageRoute(builder: (context) => Home()));

        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Processing Data')));
        Get.to(() => Home(userCredential: userCredential));
      } catch (err) {
        print("<----------------- Failed to Authenticate ------------> ");
        print(err.toString());
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text('Error Data')));
      }
    }
  }

  Future<UserCredential> siginWithGoogle() async {
    // Firebase.initializeApp();
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    final GoogleSignInAuthentication googleAuth =
        await googleUser!.authentication;
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth.accessToken,
      idToken: googleAuth.idToken,
    );

    UserCredential userCredential =
        await FirebaseAuth.instance.signInWithCredential(credential);
    Get.to(() => Home(
          userCredential: userCredential,
        ));
    return userCredential;
  }
}



// Failed Auhtentication Ui because of null safety issues
// class _SigninPageState extends State<SigninPage> {
//   // FirebaseUser? _user;
//   // String? _error;

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       mainAxisAlignment: MainAxisAlignment.center,
//       crossAxisAlignment: CrossAxisAlignment.center,
//       children: [
//         ElevatedButton(
//           child: const Text('Sign in with email'),
//           onPressed: signInWithSocial,
//         ),
//       ],
//     );
//   }

//   void signInWithSocial() async {
//     if (_user == null) {
//       FirebaseAuthUi.instance().launchAuth([
//         AuthProvider.email(),
//         AuthProvider.phone(),
//         AuthProvider.google(),
//         AuthProvider.facebook(),
//         AuthProvider.twitter()
//       ]).then((firebaseUser) {
//         setState(() {
//           _error = '';
//           _user = firebaseUser;
//         });
//       }).catchError((error) {
//         if (error is PlatformException) {
//           setState(() {
//             if (error.code == FirebaseAuthUi.kUserCancelledError) {
//               _error = "User cancelled login";
//             } else {
//               _error = error.message ?? 'Unknown Error';
//             }
//           });
//         }
//       });
//     } else {
//       _logout();
//     }
//   }

//   void _logout() async {
//     await FirebaseAuthUi.instance().logout();
//     setState(() {
//       _user = null;
//     });
//   }
// }

