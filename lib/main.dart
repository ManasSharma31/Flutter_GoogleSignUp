import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  final GoogleSignIn googlesignin = GoogleSignIn();
  bool isspinning = false;

  Future<FirebaseUser> signIn() async {
    final GoogleSignInAccount ga = await googlesignin
        .signIn(); //Displays the no of accounts you have in your mobile.
    final GoogleSignInAuthentication googleSignInAuthentication =
        await ga.authentication; //Sends an authentication respect to Google

    final AuthCredential credential = GoogleAuthProvider.getCredential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final AuthResult authResult = await _auth.signInWithCredential(credential);
    final FirebaseUser user = authResult.user;

    print("User Name is : ${user.displayName}");
    return user;
  }

  void signOut() {
    googlesignin.signOut();
    print("User Logged Out Successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ModalProgressHUD(
        inAsyncCall: isspinning,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Center(
              child: RaisedButton(
                  child: Text("Sign In"),
                  onPressed: () async {
                    setState(() {
                      isspinning = true;
                    });
                    try {
                      FirebaseUser user = await signIn();
                      if (user != null)
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) {
                          return Second(user);
                        }));
                      setState(() {
                        isspinning = false;
                      });
                    } catch (e) {
                      setState(() {
                        isspinning = false;
                      });
                      print(e.toString());
                    }
                  }),
            ),
            Center(
              child: RaisedButton(
                  child: Text("Sign Out"), onPressed: () => signOut()),
            )
          ],
        ),
      ),
    );
  }
}

class Second extends StatelessWidget {
  Second(this.user);
  final FirebaseUser user;
  final GoogleSignIn googleSignIn = GoogleSignIn();

  void signOut() {
    googleSignIn.signOut();
    print("User Logged Out Successfully");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.keyboard_backspace),
          onPressed: () {
            signOut();
            Navigator.pop(context);
          },
        ),
      ),
      backgroundColor: Colors.white,
      body: Center(
          child: Container(
        child: Text(
          "Successfully logged in as ${user.displayName}",
          style: TextStyle(fontSize: 20, color: Colors.black),
        ),
      )),
    );
  }
}
