import "package:flutter/material.dart";
import "package:flutter_tugasakhir/transaksi.dart";
import "package:google_fonts/google_fonts.dart";
import "package:intl/intl.dart";

class DetailPage extends StatefulWidget {
  final Transaksi transaksi;
  final String transaksiDocId;
  const DetailPage(
      {super.key, required this.transaksi, required this.transaksiDocId});

  @override
  State<DetailPage> createState() => _DetailPageState();
}

class _DetailPageState extends State<DetailPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Detail Transaksi",
            style: GoogleFonts.inter(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w700,
            ),
          ),
          centerTitle: true,
          backgroundColor: const Color(0xFF0176B6),
          leading: IconButton(
              icon: const Icon(Icons.arrow_circle_left),
              onPressed: () {
                Navigator.pop(context);
              }),
        ),
        body: Container(
          margin: const EdgeInsets.symmetric(horizontal: 15),
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 30,
                ),
                getTitilefromCategory(widget.transaksi.kategori),
                Container(
                  height: 160,
                  decoration: ShapeDecoration(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16))),
                ),
                const SizedBox(
                  height: 40,
                ),
                Container(
                  height: 60,
                  decoration: const BoxDecoration(
                      border: Border(
                          top: BorderSide(width: 1),
                          bottom: BorderSide(width: 1))),
                  child: Center(
                    child: Text(
                      widget.transaksi.nominal,
                      style: GoogleFonts.inter(
                          color: Colors.black,
                          fontSize: 24,
                          fontWeight: FontWeight.w700),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 16,
                ),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 12),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(widget.transaksi.namatransaksi,
                                    style: GoogleFonts.inter(
                                        fontSize: 16,
                                        color: Colors.black,
                                        fontWeight: FontWeight.w700)),
                                Row(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: [
                                      Container(
                                        width: 110,
                                        decoration: ShapeDecoration(
                                            color: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  width: 1,
                                                  color: Color(0xFF48CAE4)),
                                              borderRadius:
                                                  BorderRadius.circular(12),
                                            )),
                                        child: Center(
                                          child: Text(widget.transaksi.kategori,
                                              style: GoogleFonts.inter(
                                                  color:
                                                      const Color(0xFF48CAE4),
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w300)),
                                        ),
                                      ),
                                      const SizedBox(
                                        width: 20,
                                      ),
                                      Container(
                                        width: 110,
                                        decoration: ShapeDecoration(
                                          color: Colors.white,
                                          shape: RoundedRectangleBorder(
                                              side: const BorderSide(
                                                  width: 1,
                                                  color: Colors.black),
                                              borderRadius:
                                                  BorderRadius.circular(12)),
                                        ),
                                        child: Center(
                                            child: Text(
                                          DateFormat.yMMMMd('en_US').format(
                                              widget.transaksi.tanggal
                                                  .toDate()),
                                          style: GoogleFonts.inter(
                                              fontSize: 12,
                                              fontWeight: FontWeight.w300),
                                        )),
                                      )
                                    ]),
                              ]),
                          getIconForCategory(widget.transaksi.kategori)
                        ],
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          "Keterangan Transaksi",
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            height: 2,
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          widget.transaksi.keterangan,
                          style: GoogleFonts.inter(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            ),
          ),
        ));
  }

  Widget getIconForCategory(String category) {
    if (category.isNotEmpty) {
      if (category == "topup") {
        return const Icon(Icons.account_balance_wallet,
            size: 36, color: Colors.black);
      } else if (category == "transaksikeluar" ||
          category == "transaksimasuk") {
        return const Icon(Icons.credit_card, size: 36, color: Colors.black);
      } else if (category == "tagihan") {
        return const Icon(Icons.receipt_long, size: 36, color: Colors.black);
      } else if (category == "tiket") {
        return const Icon(Icons.receipt, size: 36, color: Colors.black);
      }
    }
    return const Icon(Icons.question_mark, size: 36, color: Colors.black);
  }

  Widget getTitilefromCategory(String category) {
    if (category.isNotEmpty) {
      if (category == "topup" ||
          category == "transaksikeluar" ||
          category == "tagihan" ||
          category == "tiket") {
        return Text(
          "Transaksi Keluar",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 2,
          ),
        );
      } else if (category == "transaksimasuk") {
        return Text(
          "Transaksi Masuk",
          style: GoogleFonts.inter(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.w700,
            height: 2,
          ),
        );
      }
    }
    return const Text("?");
  }
}
