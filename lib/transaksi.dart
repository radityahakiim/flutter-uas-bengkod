import 'package:cloud_firestore/cloud_firestore.dart';

class Transaksi {
  final String uid;
  final String namatransaksi;
  final String kategori;
  final int nominal;
  final Timestamp tanggal;
  final String keterangan;
  final String filename;

  Transaksi({
    required this.filename,
    required this.uid,
    required this.namatransaksi,
    required this.kategori,
    required this.nominal,
    required this.tanggal,
    required this.keterangan,
  });
}
