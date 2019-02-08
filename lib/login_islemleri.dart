import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginIslemleri extends StatefulWidget {
  @override
  _LoginIslemleriState createState() => _LoginIslemleriState();
}

class _LoginIslemleriState extends State<LoginIslemleri> {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String mesaj = "";

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
              onPressed: _emailveSifreileUserOlustur,
            ),

            RaisedButton(
              child: Text(
                "Email/Sifre Giriş Yap",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.greenAccent,
              onPressed: _emailveSifreileGirisYap,
            ),

            RaisedButton(
              child: Text(
                "Çıkış Yap",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.red,
              onPressed: _cikisyap,
            ),


            Text(mesaj),
          ],
        ),
      ),
    );
  }

  void _emailveSifreileUserOlustur() async {
    String mail = "emrealtunbilek@gmail.com";
    String sifre = "123456";
    var firebaseUser = await _auth
        .createUserWithEmailAndPassword(
          email: mail,
          password: sifre,
        )
        .catchError((e) => debugPrint("Hata :" + e.toString()));

    if (firebaseUser != null) {
      firebaseUser
          .sendEmailVerification()
          .then((data) {
            _auth.signOut();
      })
          .catchError((e) => debugPrint("Mail gönderirken hata $e"));

      setState(() {
        mesaj =
            "Uid ${firebaseUser.uid} \nmail : ${firebaseUser.email} \nmailOnayı : ${firebaseUser.isEmailVerified}\n Email gönderildi lütfen onaylayın";
      });
      debugPrint(
          "Uid ${firebaseUser.uid} mail : ${firebaseUser.email} mailOnayı : ${firebaseUser.isEmailVerified} ");
    }else{

     setState(() {
       mesaj = "bu mail zaten kullanımda";
     });
    }
  }

  void _emailveSifreileGirisYap() {
    String mail = "emrealtunbilek@gmail.com";
    String sifre = "123456";

    _auth.signInWithEmailAndPassword(email: mail, password: sifre).then((oturumAcmisKullanici){

      if(oturumAcmisKullanici.isEmailVerified){
        mesaj = "Email onaylı kullanıcı yönlendirme yapabilirsin";
      }else{

        mesaj = "Emailize mail attık lütfen onaylayın";
        _auth.signOut();
      }
      setState(() {

      });

    }).catchError((hata){
      debugPrint(hata.toString());

      setState(() {
        mesaj = "Email/Sifre hatalı";
      });

    });


  }

  void _cikisyap() async {

    if(await _auth.currentUser() != null){
      _auth.signOut().then((data){

        setState(() {
          mesaj = "Kullanıcı çıkış yaptı";
        });
      }).catchError((hata){
        setState(() {
          mesaj = "Çıkış yaparken hata oluştu $hata";
        });
      });
    }else{
     setState(() {
       mesaj = "Oturum açmış kullanıcı yok";
     });
    }



  }
}
