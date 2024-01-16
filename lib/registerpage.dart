import 'package:email_validator/email_validator.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:flutter_tugasakhir/loginpage.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  late bool _passwordVisible;
  late bool _passwordVisibleConfirm;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _confirmpasswordController =
      TextEditingController();

  void toLogin() {
    Navigator.push(context, MaterialPageRoute(builder: (context) {
      return const LoginPage();
    }));
  }

  Future register() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final name = _nameController.text;
      final email = _emailController.text;
      final phone = _phoneController.text;
      final password = _passwordController.text;
      final confirmpassword = _confirmpasswordController.text;

      if (name.isEmpty || email.isEmpty || phone.isEmpty || password.isEmpty) {
        throw ('Mohon isi semua form');
      } else if (password.length < 6) {
        throw ("Password harus diisi setidaknya 6 karakter");
      } else if (!EmailValidator.validate(email)) {
        throw ("Isi email dengan benar");
      } else if (confirmpassword != password) {
        throw ("Password dan konfirmasi harus sama");
      } else {
        final newUser = await _auth.createUserWithEmailAndPassword(
            email: email, password: password);
        await FirebaseFirestore.instance
            .collection('Users2')
            .doc(newUser.user?.uid)
            .set({
          'name': name,
          'email': email,
          'phone': phone,
        });
      }
    } catch (error) {
      final snackBar = SnackBar(content: Text("Error: ${error.toString()})"));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _passwordVisible = false;
    _passwordVisibleConfirm = false;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : Container(
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment(0.00, -1.00),
                  end: Alignment(0, 1),
                  colors: [Color(0xFF0176B6), Color(0xFFA9E5F2)],
                ),
              ),
              child: Stack(
                children: [
                  Positioned(
                    left: 20,
                    top: 250,
                    child: Container(
                      width: 350,
                      height: 460,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 10,
                          ),
                          const Text(
                            'Sign up to create account',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: TextFormField(
                              controller: _nameController,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                labelText: 'Name',
                                prefixIcon: Icon(Icons.person),
                                border: OutlineInputBorder(),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Isi nama anda';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: TextFormField(
                              controller: _emailController,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email_rounded),
                                border: OutlineInputBorder(),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) =>
                                  EmailValidator.validate(value!)
                                      ? null
                                      : "Masukkan email yang benar",
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: TextFormField(
                              keyboardType: TextInputType.phone,
                              inputFormatters: <TextInputFormatter>[
                                FilteringTextInputFormatter.digitsOnly,
                              ],
                              controller: _phoneController,
                              style: const TextStyle(fontSize: 14),
                              decoration: const InputDecoration(
                                labelText: 'Phone Number',
                                prefixIcon: Icon(Icons.phone_callback_rounded),
                                border: OutlineInputBorder(),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Isi nomor telepon anda';
                                } else {
                                  return null;
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: TextFormField(
                              controller: _passwordController,
                              style: const TextStyle(fontSize: 14),
                              obscureText: !_passwordVisible,
                              decoration: InputDecoration(
                                labelText: 'Password',
                                prefixIcon: const Icon(Icons.key),
                                suffixIcon: IconButton(
                                  icon: Icon(_passwordVisible
                                      ? Icons.visibility_off
                                      : Icons.visibility),
                                  onPressed: () {
                                    setState(() {
                                      _passwordVisible = !_passwordVisible;
                                    });
                                  },
                                ),
                                border: const OutlineInputBorder(),
                              ),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              // ignore: body_might_complete_normally_nullable
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Please enter some password';
                                }
                                if (value.length < 6) {
                                  return 'Password minimal 6 huruf';
                                }
                              },
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 2, horizontal: 10),
                            child: TextFormField(
                              controller: _confirmpasswordController,
                              style: const TextStyle(fontSize: 14),
                              obscureText: !_passwordVisibleConfirm,
                              decoration: InputDecoration(
                                  labelText: 'Confirm Password',
                                  prefixIcon: const Icon(Icons.key),
                                  suffixIcon: IconButton(
                                    icon: Icon(_passwordVisibleConfirm
                                        ? Icons.visibility_off
                                        : Icons.visibility),
                                    onPressed: () {
                                      setState(() {
                                        _passwordVisibleConfirm =
                                            !_passwordVisibleConfirm;
                                      });
                                    },
                                  ),
                                  border: const OutlineInputBorder()),
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              validator: (value) {
                                if (value != _passwordController.text) {
                                  return "Password dan konfirmasi harus sama";
                                }
                                return null;
                              },
                            ),
                          ),
                          SizedBox(
                            height: 15,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Sudah mempunyai akun?',
                                    style: GoogleFonts.inter(
                                      textStyle: const TextStyle(
                                        color: Colors.black,
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                        height: 0,
                                      ),
                                    ),
                                  ),
                                  TextSpan(
                                      text: ' Klik untuk login',
                                      style: GoogleFonts.inter(
                                        textStyle: const TextStyle(
                                          color: Color(0xFF278FC3),
                                          fontSize: 12,
                                          fontWeight: FontWeight.w500,
                                          height: 0,
                                        ),
                                      ),
                                      recognizer: TapGestureRecognizer()
                                        ..onTap = () {
                                          toLogin();
                                        }),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 10,
                          ),
                          ElevatedButton(
                            onPressed: register,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff228cc2)),
                            child: Text(
                              'Daftar',
                              style: GoogleFonts.inter(
                                  textStyle: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 12,
                                      fontWeight: FontWeight.w500,
                                      height: 0)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  Positioned(
                    left: 20,
                    top: 187,
                    child: SizedBox(
                      width: 297,
                      height: 38,
                      child: Text(
                        'Welcome Back!',
                        style: GoogleFonts.inter(
                          textStyle: const TextStyle(
                            color: Colors.white,
                            fontSize: 32,
                            fontWeight: FontWeight.w700,
                            height: 0,
                            decoration: TextDecoration.none,
                          ),
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    left: 113,
                    top: 739,
                    child: SizedBox(
                      width: 163,
                      height: 44,
                      child: Text(
                        'Bengkel Koding 2024\nRaditya Hakim Daniswara',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.black.withOpacity(0.5),
                          fontSize: 12,
                          fontFamily: 'Inter',
                          fontWeight: FontWeight.w500,
                          height: 0,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
