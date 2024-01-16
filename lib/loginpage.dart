import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_tugasakhir/registerpage.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:email_validator/email_validator.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_tugasakhir/homepage.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  late bool _passwordVisible;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  bool _isLoading = false;

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  void login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final navigator = Navigator.of(context);
      final email = _emailController.text;
      final password = _passwordController.text;
      if (email.isEmpty || password.isEmpty) {
        throw ("Please fill all the fields");
      } else {
        if (!EmailValidator.validate(_emailController.text)) {
          throw ("Masukkan email yang benar");
        } else {
          await _auth.signInWithEmailAndPassword(
              email: email, password: password);
          navigator.pushReplacement(MaterialPageRoute(builder: (context) {
            return const HomePage();
          }));
        }
      }
    } catch (e) {
      final snackbar = SnackBar(content: Text(e.toString()));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackbar);
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
                    top: 291,
                    child: Container(
                      width: 350,
                      height: 300,
                      decoration: ShapeDecoration(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(30),
                        ),
                      ),
                      child: Column(
                        children: [
                          const SizedBox(
                            height: 15,
                          ),
                          const Text(
                            'Sign in to continue',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.grey,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                vertical: 10, horizontal: 10),
                            child: TextFormField(
                              controller: _emailController,
                              decoration: const InputDecoration(
                                hintText: 'Masukkan Email',
                                labelText: 'Email',
                                prefixIcon: Icon(Icons.email),
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
                                vertical: 5, horizontal: 10),
                            child: TextFormField(
                              controller: _passwordController,
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
                            ),
                          ),
                          SizedBox(
                            height: 15,
                            child: Text.rich(
                              TextSpan(
                                children: [
                                  TextSpan(
                                    text: 'Tidak mempunyai akun?',
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
                                      text: ' Klik untuk daftar',
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
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                  builder: (context) =>
                                                      const RegisterPage()));
                                        }),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(
                            height: 15,
                          ),
                          ElevatedButton(
                            onPressed: login,
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xff228cc2)),
                            child: Text(
                              'Masuk',
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
