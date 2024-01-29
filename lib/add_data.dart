import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import "package:path/path.dart";

class AddDataPage extends StatefulWidget {
  final String userUid;
  const AddDataPage({super.key, required this.userUid});

  @override
  State<AddDataPage> createState() => _AddDataPageState();
}

class _AddDataPageState extends State<AddDataPage> {
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
  late Timestamp _pickedDateTimestamp;

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

  Future<void> uploadImageToFirebaseStorage(XFile? imageFile) async {
    String fileName = basename(imageFile!.path);
    String formattedDate = DateFormat('ddMMyy_HHmmss').format(DateTime.now());
    fileName = '${fileName}_$formattedDate';
    Reference storageReference = _storage.ref().child(fileName);
    await storageReference.putFile(File(imageFile.path));
    // var _url = await storageReference.getDownloadURL();
    // return _url;
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
    _dateinputController.text = "";
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
        _pickedDateTimestamp = Timestamp.fromDate(picked);
        _dateinputController.text = formattedDate;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    CollectionReference dataCollection = _firestore.collection('transaksi');
    Future<void> addData() {
      String datenow = DateFormat('ddMMyy_HHmmss').format(DateTime.now());
      return dataCollection.add({
        'namatransaksi': _namecontroller.text,
        'kategori': _kategoriController.text,
        'keterangan': _descController.text,
        'tanggal': _pickedDateTimestamp,
        'filename': "${_filename.text}_$datenow",
        'nominal': int.parse(_nominalController.text),
        'uid': widget.userUid
        // ignore: invalid_return_type_for_catch_error
      }).catchError((error) => print('Failed to add data: $error'));
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
          'Tambah Transaksi',
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
              style: const TextStyle(fontSize: 15),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
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
                String formattedValue = value.toLowerCase().replaceAll(' ', '');
                return DropdownMenuItem<String>(
                    value: formattedValue, child: Text(value));
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
              uploadImageToFirebaseStorage(_imagefile);
              addData();
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xff228cc2)),
            child: Text(
              'Tambah',
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
