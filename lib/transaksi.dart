import 'package:cloud_firestore/cloud_firestore.dart';

class Transaksi {
  final String uid;
  final String namatransaksi;
  final String kategori;
  final String nominal;
  final Timestamp tanggal;
  final String keterangan;
  final String filename;
  final String fileurl;

  Transaksi({
    required this.filename,
    required this.fileurl,
    required this.uid,
    required this.namatransaksi,
    required this.kategori,
    required this.nominal,
    required this.tanggal,
    required this.keterangan,
  });
}
