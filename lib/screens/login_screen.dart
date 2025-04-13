import 'package:flutter/material.dart';
import 'package:animated_login/animated_login.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'email_verification_screen.dart';
import 'forgot_password_screen.dart';
import 'home_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _auth = FirebaseAuth.instance;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: AnimatedLogin(
          loginDesktopTheme: LoginViewTheme(),
          loginMobileTheme: LoginViewTheme(),
          logo: Image.asset('assets/images/logo.gif', width: 100, height: 100),
          onLogin: (LoginData data) async {
            try {
              final userCredential = await _auth.signInWithEmailAndPassword(
                email: data.email,
                password: data.password,
              );

              // Periksa apakah email sudah diverifikasi
              if (userCredential.user != null &&
                  !userCredential.user!.emailVerified) {
                // Jika belum diverifikasi, arahkan ke halaman verifikasi email
                Future.delayed(Duration.zero, () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const EmailVerificationScreen(),
                    ),
                  );
                });
                return 'メールアドレスを確認してください';
              }

              // Navigasi ke halaman home setelah login berhasil
              WidgetsBinding.instance.addPostFrameCallback((_) {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const HomeScreen()),
                );
              });

              return null;
            } on FirebaseAuthException catch (e) {
              print("ログイン中にエラーが発生しました: ${e.message}");
              return e.message;
            }
          },
          onSignup: (SignUpData data) async {
            try {
              // Buat akun baru
              final userCredential = await _auth.createUserWithEmailAndPassword(
                email: data.email,
                password: data.password,
              );

              // Kirim email verifikasi
              await userCredential.user!.sendEmailVerification();

              // Arahkan pengguna ke halaman verifikasi email
              Future.delayed(Duration.zero, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const EmailVerificationScreen(),
                  ),
                );
              });

              return 'アカウントが正常に作成されました。メールアドレスを確認してください。';
            } on FirebaseAuthException catch (e) {
              return e.message;
            }
          },
          socialLogins: [
            SocialLogin(
              iconPath: 'assets/images/google.png',
              callback: () async {
                try {
                  // Implementasi login Google akan ditambahkan disini
                  return null;
                } catch (e) {
                  return e.toString();
                }
              },
            ),
            SocialLogin(
              iconPath: 'assets/images/facebook.png',
              callback: () async {
                try {
                  // Implementasi login Facebook akan ditambahkan disini
                  return null;
                } catch (e) {
                  return e.toString();
                }
              },
            ),
          ],
          onForgotPassword: (String email) async {
            try {
              // Navigasi ke halaman lupa password
              Future.delayed(Duration.zero, () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => const ForgotPasswordScreen(),
                  ),
                );
              });
              return null;
            } catch (e) {
              return e.toString();
            }
          },
        ),
      ),
    );
  }
}
