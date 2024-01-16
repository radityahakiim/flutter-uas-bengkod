import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_tugasakhir/detail_page.dart';
import 'package:flutter_tugasakhir/update_data.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'transaksi.dart';

class ListData extends StatefulWidget {
  final String transaksiDocId;
  final Transaksi transaksi;

  const ListData(
      {super.key, required this.transaksiDocId, required this.transaksi});

  @override
  State<ListData> createState() => _ListDataState();
}

class _ListDataState extends State<ListData> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore _firestore = FirebaseFirestore.instance;
    CollectionReference transaksiCollection =
        _firestore.collection('transaksi');
    Future<void> deleteData() async {
      await transaksiCollection.doc(widget.transaksiDocId).delete();
    }

    // Context Menu Section
    Offset _tapPosition = Offset.zero;
    void _getTapPosition(TapDownDetails details) {
      final RenderBox referenceBox = context.findRenderObject() as RenderBox;
      setState(() {
        _tapPosition = referenceBox.globalToLocal(details.globalPosition);
      });
    }

    void _showContextMenu(BuildContext context) async {
      final RenderObject? overlay =
          Overlay.of(context).context.findRenderObject();
      final result = await showMenu(
          context: context,
          position: RelativeRect.fromRect(
              Rect.fromLTWH(_tapPosition.dx, _tapPosition.dy, 30, 30),
              Rect.fromLTWH(0, 0, overlay!.paintBounds.size.width,
                  overlay.paintBounds.size.height)),
          items: [
            const PopupMenuItem(
                value: 'delete', child: Text("Delete Transaksi")),
            const PopupMenuItem(
                value: 'update', child: Text("Update Transaksi"))
          ]);

      if (result == 'delete') {
        deleteData();
      } else if (result == 'update') {
        // ignore: use_build_context_synchronously
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => UpdateDataPage(
                    transaksi: widget.transaksi,
                    transaksiDocId: widget.transaksiDocId)));
      }
    }

    return GestureDetector(
        child: Container(
          height: 64,
          decoration: ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(24),
              ),
              shadows: const [
                BoxShadow(
                    color: Color(0x3F000000),
                    blurRadius: 6.70,
                    offset: Offset(0, 4),
                    spreadRadius: 0)
              ]),
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 50,
                      height: 50,
                      decoration: const ShapeDecoration(
                          color: Color(0xFF0077B6), shape: OvalBorder()),
                      child: getIconForCategory(widget.transaksi.kategori),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          widget.transaksi.namatransaksi,
                          style: GoogleFonts.inter(
                              color: Colors.black,
                              fontSize: 14,
                              fontWeight: FontWeight.w700),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          DateFormat.yMMMMd('en_US')
                              .format(widget.transaksi.tanggal.toDate()),
                          style: GoogleFonts.inter(
                              fontSize: 12, fontWeight: FontWeight.w300),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  widget.transaksi.nominal,
                  style: GoogleFonts.inter(
                      color: Colors.black,
                      fontSize: 16,
                      fontWeight: FontWeight.w700),
                )
              ],
            ),
          ),
        ),
        onTapDown: (details) => _getTapPosition(details),
        onLongPress: () => _showContextMenu(context),
        onTap: () =>
            Navigator.push(context, MaterialPageRoute(builder: (context) {
              return DetailPage(
                transaksi: widget.transaksi,
                transaksiDocId: widget.transaksiDocId,
              );
            })));
  }

  Widget getIconForCategory(String category) {
    if (category.isNotEmpty) {
      if (category == "topup") {
        return const Icon(Icons.account_balance_wallet,
            size: 36, color: Color(0xFF48CAE4));
      } else if (category == "transaksikeluar" ||
          category == "transaksimasuk") {
        return const Icon(Icons.credit_card,
            size: 36, color: Color(0xFF48CAE4));
      } else if (category == "tagihan") {
        return const Icon(Icons.receipt_long,
            size: 36, color: Color(0xFF48CAE4));
      } else if (category == "tiket") {
        return const Icon(Icons.receipt, size: 36, color: Color(0xFF48CAE4));
      }
    }
    return const Icon(Icons.question_mark, size: 36, color: Color(0xFF48CAE4));
  }
}
