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
  void initState() {
    // TODO: implement initState
    super.initState();
    _auth.onAuthStateChanged.listen((user){
      setState(() {
        if(user != null){
          mesaj += "\nListener tetiklendi kullanıcı oturum açtı";
        }else {
          mesaj += "\nListener tetiklendi kullanıcı oturumu kapattı";
        }
      });
    });
  }

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

            RaisedButton(
              child: Text(
                "Şifremi Unuttum",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.purple,
              onPressed: _sifremiUnuttum,
            ),

            RaisedButton(
              child: Text(
                "Şifremi Güncelle",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.pink,
              onPressed: _sifremiGuncelle,
            ),


            RaisedButton(
              child: Text(
                "Email Güncelle",
                style: TextStyle(color: Colors.white),
              ),
              color: Colors.blueGrey,
              onPressed: _emailGuncelle,
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
        mesaj += "\nEmail onaylı kullanıcı yönlendirme yapabilirsin";
      }else{

        mesaj += "\nEmailize mail attık lütfen onaylayın";
        _auth.signOut();
      }
      setState(() {

      });

    }).catchError((hata){
      debugPrint(hata.toString());

      setState(() {
        mesaj += "\nEmail/Sifre hatalı";
      });

    });


  }

  void _cikisyap() async {

    if(await _auth.currentUser() != null){
      _auth.signOut().then((data){

        setState(() {
          mesaj += "\nKullanıcı çıkış yaptı";
        });
      }).catchError((hata){
        setState(() {
          mesaj += "\nÇıkış yaparken hata oluştu $hata";
        });
      });
    }else{
     setState(() {
       mesaj += "\nOturum açmış kullanıcı yok";
     });
    }



  }

  void _sifremiUnuttum() {
    String mail = "emrealtunbilek@gmail.com";
    _auth.sendPasswordResetEmail(email: mail).then((v){
      setState(() {

        mesaj += "\nSıfırlama maili gönderildi";
      });
    }).catchError((hata){

      setState(() {

        mesaj += "\nŞifremi unuttum mailinde hata $hata";
      });
    });

  }

  void _sifremiGuncelle() async {



    _auth.currentUser().then((user){

      if(user != null){

        user.updatePassword("234567").then((a){
          setState(() {

            mesaj += "\nŞifre güncellendi";

          });
        }).catchError((hata){
          setState(() {

            mesaj += "\nŞifre güncellenirken hata olustur $hata";

          });

        });
      }else{

        setState(() {

          mesaj += "\nŞifre güncellemek için önce oturum açın";

        });
      }

    }).catchError((hata){
      setState(() {

        mesaj += "\nKullanıcı getirilirken cıkan hata : $hata";

      });
    });

  }

  void _emailGuncelle() {

    _auth.currentUser().then((user){

      if(user != null){

        user.updateEmail("emre@emre.com").then((a){
          setState(() {

            mesaj += "\Email güncellendi";

          });
        }).catchError((hata){
          setState(() {

            mesaj += "\Email güncellenirken hata olustur $hata";

          });

        });
      }else{

        setState(() {

          mesaj += "\Email güncellemek için önce oturum açın";

        });
      }

    }).catchError((hata){
      setState(() {

        mesaj += "\nKullanıcı getirilirken cıkan hata : $hata";

      });
    });

  }
}
