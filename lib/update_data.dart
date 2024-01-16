import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'transaksi.dart';

class UpdateDataPage extends StatefulWidget {
  final Transaksi transaksi;
  final String transaksiDocId;
  const UpdateDataPage(
      {super.key, required this.transaksi, required this.transaksiDocId});

  @override
  State<UpdateDataPage> createState() => _UpdateDataPageState();
}

class _UpdateDataPageState extends State<UpdateDataPage> {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  FirebaseStorage _storage = FirebaseStorage.instance;
  List<String> inputKategori = [
    "Top Up",
    "Transaksi Keluar",
    "Transaksi Masuk",
    "Tagihan",
    "Tiket"
  ];

  TextEditingController _namecontroller = TextEditingController();
  TextEditingController _dateinputController = TextEditingController();
  TextEditingController _nominalController = TextEditingController();
  TextEditingController _kategoriController = TextEditingController();
  TextEditingController _descController = TextEditingController();
  TextEditingController _filename = TextEditingController();
  late Timestamp _DateTimeStamp;

  final ImagePicker _imagePicker = ImagePicker();
  XFile? _imagefile;

  Future<void> _pickImage() async {
    final XFile? pickedImage =
        await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedImage != null) {
      _filename.text = basename(pickedImage.path);
    }
    setState(() {
      _imagefile = pickedImage;
    });
  }

  Future<String> updateImageToFirebaseStorage(XFile? imageFile) async {
    String fileName = basename(imageFile!.path);
    String _oldFileName = widget.transaksi.filename;
    final oldRef = _storage.ref().child(_oldFileName);
    await oldRef.delete();
    Reference storageReference = _storage.ref().child(fileName);
    await storageReference.putFile(File(imageFile.path));
    return await storageReference.getDownloadURL();
  }

  void _clearData() {
    _namecontroller.clear();
    _dateinputController.clear();
    _nominalController.clear();
    _kategoriController.clear();
    _descController.clear();
    _imagefile = null;
  }

  @override
  void initState() {
    super.initState();
    _DateTimeStamp = widget.transaksi.tanggal;
    _namecontroller =
        TextEditingController(text: widget.transaksi.namatransaksi);
    _dateinputController = TextEditingController(
        text: DateFormat('dd/MM/yy').format(_DateTimeStamp.toDate()));
    _nominalController = TextEditingController(text: widget.transaksi.nominal);
    _descController = TextEditingController(text: widget.transaksi.keterangan);
    _filename = TextEditingController(text: widget.transaksi.filename);
  }

  _selectDate(BuildContext context) async {
    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2077),
    );
    if (picked != null && picked != DateTime.now()) {
      String formattedDate = DateFormat('dd/MM/yy').format(picked);
      setState(() {
        _DateTimeStamp = Timestamp.fromDate(picked);
        _dateinputController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference transaksiCollection =
        _firestore.collection('transaksi');
    Future<void> updateData() async {
      await transaksiCollection.doc(widget.transaksiDocId).update({
        'namatransaksi': _namecontroller.text,
        'kategori': _kategoriController.text.toLowerCase().replaceAll(' ', ''),
        'keterangan': _descController.text,
        'tanggal': _DateTimeStamp,
        'fileurl': widget.transaksi.filename != _filename.text
            ? updateImageToFirebaseStorage(_imagefile).toString()
            : widget.transaksi.fileurl,
        'filename': _filename.text,
        'nominal': int.parse(_nominalController.text)
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0176B6),
        leading: IconButton(
          icon: const Icon(Icons.exit_to_app),
          onPressed: () {
            _clearData();
            Navigator.pop(context);
          },
        ),
        centerTitle: true,
        title: Text(
          'Ubah Transaksi',
          style: GoogleFonts.inter(
              fontSize: 24,
              fontWeight: FontWeight.w700,
              height: 0,
              color: Colors.white),
        ),
      ),
      body: Center(
        child: Column(children: [
          const SizedBox(
            height: 45,
          ),
          Text(
            "Transaksi Baru",
            style: GoogleFonts.inter(
                color: Colors.black,
                fontSize: 24,
                fontWeight: FontWeight.w700,
                height: 0),
          ),
          const SizedBox(height: 10),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: TextFormField(
              controller: _namecontroller,
              style: const TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                  hintText: 'Nama Transaksi',
                  border: OutlineInputBorder(),
                  isDense: true),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: TextFormField(
              controller: _dateinputController,
              readOnly: true,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                  hintText: 'Tanggal',
                  border: OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: IconButton(
                    icon: const Icon(Icons.edit_calendar),
                    onPressed: () => _selectDate(context),
                  )),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: TextFormField(
              controller: _nominalController,
              keyboardType: TextInputType.number,
              style: const TextStyle(fontSize: 15),
              decoration: const InputDecoration(
                  hintText: 'Nominal',
                  suffixIcon: Icon(Icons.money),
                  border: OutlineInputBorder(),
                  isDense: true),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: DropdownButtonFormField(
              decoration: const InputDecoration(
                  hintText: "Kategori",
                  border: OutlineInputBorder(),
                  isDense: true),
              value: _kategoriController.text.isNotEmpty
                  ? _kategoriController.text
                  : null,
              onChanged: (newValue) {
                setState(() {
                  _kategoriController.text = newValue!;
                });
              },
              items:
                  inputKategori.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                    value: value, child: Text(value));
              }).toList(),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: TextFormField(
              controller: _filename,
              readOnly: true,
              style: const TextStyle(fontSize: 15),
              decoration: InputDecoration(
                  hintText: 'Tambah Gambar',
                  border: const OutlineInputBorder(),
                  isDense: true,
                  suffixIcon: IconButton(
                      onPressed: _pickImage, icon: const Icon(Icons.image))),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 15),
            child: SizedBox(
              height: 120,
              child: TextFormField(
                controller: _descController,
                maxLines: null,
                expands: true,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                    hintText: "Keterangan", border: OutlineInputBorder()),
              ),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          ElevatedButton(
            onPressed: () {
              updateData();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff228cc2)),
            child: Text(
              'Update',
              style: GoogleFonts.inter(
                  textStyle: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                      height: 0)),
            ),
          )
        ]),
      ),
    );
  }
}
