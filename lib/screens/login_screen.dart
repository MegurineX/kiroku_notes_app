import 'package:flutter/material.dart';
import 'package:animated_login/animated_login.dart';
import '/src/models/language_option.dart';
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

              // Check if the email is verified
              if (userCredential.user != null &&
                  !userCredential.user!.emailVerified) {
                // If not verified, navigate to the email verification page
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

              // Navigate to the home page after successful login
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
              // create new account
              final userCredential = await _auth.createUserWithEmailAndPassword(
                email: data.email,
                password: data.password,
              );

              // send email verification
              await userCredential.user!.sendEmailVerification();

              // Navigate the user to the email verification page
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
                  // Google login implementation will be added here
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
                  // Facebook login implementation will be added here
                  return null;
                } catch (e) {
                  return e.toString();
                }
              },
            ),
          ],
          onForgotPassword: (String email) async {
            try {
              // Navigate to the forgot password page
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
