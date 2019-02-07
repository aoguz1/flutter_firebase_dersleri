import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginIslemleri extends StatefulWidget {
  @override
  _LoginIslemleriState createState() => _LoginIslemleriState();
}

class _LoginIslemleriState extends State<LoginIslemleri> {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firebase Authentication"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text(
                "Email/Sifre Yeni Kullanıcı Oluştur",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.lightBlue,
              onPressed: _emailveSifreLogin,
            ),
          ],
        ),
      ),
    );
  }

  void _emailveSifreLogin() async {
    String mail = "emrealtunbilek@gmail.com";
    String sifre = "123456";
    var firebaseUser = await _auth
        .createUserWithEmailAndPassword(email: mail, password: sifre,)
        .catchError((e) => debugPrint("Hata :" + e.toString()));

    if(firebaseUser != null){
      
      debugPrint("Uid ${firebaseUser.uid} mail : ${firebaseUser.email} mailOnayı : ${firebaseUser.isEmailVerified} ");
    }

  }
}
