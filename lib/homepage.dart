import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tugasakhir/add_data.dart';
import 'package:flutter_tugasakhir/konversiuang.dart';
import 'package:flutter_tugasakhir/list_data.dart';
import 'package:flutter_tugasakhir/loginpage.dart';
import 'package:flutter_tugasakhir/transaksi.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  StreamController<int> _totalSumController = StreamController<int>();
  FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> fetchData() async {
    QuerySnapshot<Map<String, dynamic>> querySnapshot =
        await FirebaseFirestore.instance.collection('transaksi').get();
    int sum = 0;
    for (var document in querySnapshot.docs) {
      Transaksi transaction = Transaksi(
          filename: document['filename'],
          uid: document['uid'],
          namatransaksi: document['namatransaksi'],
          kategori: document['kategori'],
          nominal: document['nominal'],
          tanggal: document['tanggal'],
          keterangan: document['keterangan']);

      int nominalValue = transaction.nominal;
      if (transaction.kategori.contains('transaksimasuk')) {
        sum += nominalValue;
      } else {
        sum -= nominalValue;
      }
    }
    _totalSumController.add(sum);
  }

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  @override
  void dispose() {
    _totalSumController.close();
    super.dispose();
  }

  Future<void> _signOut() async {
    await _auth.signOut();
    runApp(const MaterialApp(
      home: LoginPage(),
    ));
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;
    String uid = user!.uid;
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: StreamBuilder<DocumentSnapshot>(
          stream: _firestore.collection('Users2').doc(uid).snapshots(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return CircularProgressIndicator();
            }
            if (snapshot.hasError) {
              return Text('Error: ${snapshot.error}');
            }
            if (!snapshot.hasData || !snapshot.data!.exists) {
              return Text('User data not found');
            }

            var userData = snapshot.data!.data() as Map<String, dynamic>;
            String userName = userData['name'];
            return Text(
              "Hello, $userName",
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              )),
            );
          },
        ),
        leading: const Icon(
          Icons.person,
          size: 50,
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.exit_to_app),
            onPressed: () {
              _signOut();
              Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const LoginPage(),
                  ),
                  (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: Container(
          margin: EdgeInsets.symmetric(horizontal: 16),
          child: Center(
            child: Column(
              children: [
                SizedBox(
                  height: 32,
                ),
                Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "Catatan Keuangan",
                      textAlign: TextAlign.left,
                      style: GoogleFonts.inter(
                          fontSize: 24,
                          fontWeight: FontWeight.w700,
                          height: 2,
                          color: const Color(0xFF48CAE4)),
                    )),
                Container(
                  height: 168,
                  decoration: ShapeDecoration(
                      color: Color(0xFF48CAE4),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14))),
                  child: Container(
                    margin: EdgeInsets.symmetric(horizontal: 20),
                    child: Column(children: [
                      SizedBox(
                        height: 20,
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Saldo Anda saat ini",
                          style: GoogleFonts.inter(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              height: 1),
                        ),
                      ),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: StreamBuilder<int>(
                              stream: _totalSumController.stream,
                              builder: (context, snapshot) {
                                if (snapshot.connectionState ==
                                    ConnectionState.waiting) {
                                  return CircularProgressIndicator();
                                } else if (snapshot.hasError) {
                                  return Text('Error: ${snapshot.error}');
                                } else {
                                  int? totalSum = snapshot.data;
                                  return Text(
                                    CurrencyFormat.convertToIdr(totalSum),
                                    style: GoogleFonts.inter(
                                        color: Colors.white,
                                        fontSize: 32,
                                        fontWeight: FontWeight.w700),
                                  );
                                }
                              })),
                    ]),
                  ),
                ),
                SizedBox(
                  height: 16,
                ),
                Expanded(
                    child: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
                  stream: _firestore
                      .collection('transaksi')
                      .where('uid', isEqualTo: user.uid)
                      .snapshots(),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Center(child: CircularProgressIndicator());
                    }
                    List<Transaksi> listTransaksi =
                        snapshot.data!.docs.map((document) {
                      final data = document.data();
                      final String uid = user.uid;
                      final String namatransaksi = data['namatransaksi'];
                      final String kategori = data['kategori'];
                      final int nominal = data['nominal'];
                      final Timestamp tanggal = data['tanggal'];
                      final String keterangan = data['keterangan'];
                      final String filename = data['filename'];
                      return Transaksi(
                          filename: filename,
                          uid: uid,
                          namatransaksi: namatransaksi,
                          kategori: kategori,
                          nominal: nominal,
                          tanggal: tanggal,
                          keterangan: keterangan);
                    }).toList();
                    return ListView.separated(
                        separatorBuilder: (context, index) =>
                            const SizedBox(height: 10),
                        shrinkWrap: true,
                        itemCount: listTransaksi.length,
                        itemBuilder: (context, index) {
                          return ListData(
                            transaksiDocId: snapshot.data!.docs[index].id,
                            transaksi: listTransaksi[index],
                            refreshCallback: () {
                              return fetchData();
                            },
                          );
                        });
                  },
                ))
              ],
            ),
          )),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return AddDataPage(
                userUid: _auth.currentUser!.uid,
              );
            }));
          },
          child: const Icon(Icons.add)),
    );
  }
}
