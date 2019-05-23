import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreIslemleri extends StatefulWidget {
  @override
  _FirestoreIslemleriState createState() => _FirestoreIslemleriState();
}

class _FirestoreIslemleriState extends State<FirestoreIslemleri> {
  final Firestore _firestore = Firestore.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Firestore Islemleri"),
      ),
      body: Center(
        child: Column(
          children: <Widget>[
            RaisedButton(
              child: Text("Veri Ekle"),
              color: Colors.green,
              onPressed: _veriEkle,
            )
          ],
        ),
      ),
    );
  }

  void _veriEkle() {
    Map<String, dynamic> emreEkle = Map();
    emreEkle['ad'] = "emre updated";
    emreEkle['lisanMezunu'] = true;
    emreEkle['lisanMezunu2'] = true;
    emreEkle['lisanMezunu23'] = true;
    emreEkle['okul'] = "ege";

    _firestore
        .collection("users")
        .document("emre_altunbilek")
        .setData(emreEkle, merge: true)
        .then((v) => debugPrint("emre eklendi"));

    _firestore
        .collection("users")
        .document("hasan_yilmaz")
        .setData({'ad': 'Hasan', 'cinsiyet': 'erkek'}).whenComplete(
            () => debugPrint("hasan eklendi"));

    _firestore.document("/users/ayse").setData({'ad': 'ayse'});

    _firestore.collection("users").add({'ad': 'can', 'yas': 35});

    String yeniKullaniciID =
        _firestore.collection("users").document().documentID;
    debugPrint("yeni doc id: $yeniKullaniciID");
    _firestore
        .document("users/$yeniKullaniciID")
        .setData({'yas': 30, 'userID': '$yeniKullaniciID'});
  }
}
