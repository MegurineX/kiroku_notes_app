import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'login_screen.dart';

class EmailVerificationScreen extends StatefulWidget {
  const EmailVerificationScreen({Key? key}) : super(key: key);

  @override
  State<EmailVerificationScreen> createState() =>
      _EmailVerificationScreenState();
}

class _EmailVerificationScreenState extends State<EmailVerificationScreen> {
  bool _isEmailVerified = false;
  bool _canResendEmail = false;
  final _auth = FirebaseAuth.instance;

  @override
  void initState() {
    super.initState();

    // Check if user is already verified
    _isEmailVerified = _auth.currentUser?.emailVerified ?? false;

    if (!_isEmailVerified) {
      _sendVerificationEmail();

      // Poll for email verification status
      Future.delayed(const Duration(seconds: 5), () => _checkEmailVerified());
    }
  }

  Future _sendVerificationEmail() async {
    try {
      final user = _auth.currentUser!;
      await user.sendEmailVerification();

      setState(() => _canResendEmail = false);
      await Future.delayed(const Duration(seconds: 5));
      setState(() => _canResendEmail = true);
    } catch (e) {
      // TODO: Show error message
      print(e);
    }
  }

  Future _checkEmailVerified() async {
    await _auth.currentUser?.reload();

    setState(() {
      _isEmailVerified = _auth.currentUser?.emailVerified ?? false;
    });

    if (_isEmailVerified) {
      // Navigasi ke halaman login
      WidgetsBinding.instance.addPostFrameCallback((_) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => const LoginScreen()),
        );
      });
    } else {
      // Poll again after a delay
      Future.delayed(const Duration(seconds: 5), () => _checkEmailVerified());
    }
  }

  @override
  Widget build(BuildContext context) {
    return _isEmailVerified
        ? const Scaffold(body: Center(child: Text('メールが確認されました!')))
        : Scaffold(
          backgroundColor: Colors.white, // 1. Warna latar belakang putih
          appBar: AppBar(
            backgroundColor: Colors.white, // 2. Warna AppBar putih
            title: const Text('メール認証'),
          ),
          body: SafeArea(
            child: Center(
              // 3. Bungkus dengan Center
              child: SizedBox(
                width:
                    MediaQuery.of(context).size.width > 600
                        ? 400
                        : double.infinity, // 4. Batasi lebar maksimum
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const SizedBox(height: 32),
                        const Text(
                          '確認メールがあなたのメールアドレスに送信されました. \nメールを確認し、確認リンクをクリックしてください.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Color(0xFF757575)),
                        ),
                        const SizedBox(height: 32),
                        // 5. Bungkus dengan ConstrainedBox
                        ConstrainedBox(
                          constraints: const BoxConstraints(maxWidth: 350),
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed:
                                  _canResendEmail
                                      ? _sendVerificationEmail
                                      : null,
                              style: ElevatedButton.styleFrom(
                                elevation: 0,
                                backgroundColor: const Color(
                                  0xFFFF7643,
                                ), // 6. Warna tombol oranye
                                foregroundColor: Colors.white,
                                minimumSize: const Size(double.infinity, 48),
                                shape: const RoundedRectangleBorder(
                                  borderRadius: BorderRadius.all(
                                    Radius.circular(16),
                                  ),
                                ),
                              ),
                              child: const Text('確認メールを再送信'),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextButton(
                          onPressed: () {
                            // Kembali ke halaman login
                            Navigator.of(context).pop();
                            // Logout jika user sudah login
                            if (_auth.currentUser != null) {
                              _auth.signOut();
                            }
                          },
                          child: const Text(
                            'キャンセル',
                            style: TextStyle(color: Color(0xFFFF7643)),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
  }
}
