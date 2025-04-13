import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({Key? key}) : super(key: key);

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _emailController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _auth = FirebaseAuth.instance;
  bool _isLoading = false;
  String? _errorMessage;
  bool _resetEmailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _resetPassword() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      await _auth.sendPasswordResetEmail(email: _emailController.text.trim());
      setState(() {
        _resetEmailSent = true;
        _isLoading = false;
      });
    } on FirebaseAuthException catch (e) {
      setState(() {
        _errorMessage = e.message;
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _errorMessage = 'エラーがあります。もう一度お試しください.';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        title: const Text("パスワードを忘れた"),
      ),
      body: SafeArea(
        child: Center(
          child: SizedBox(
            width:
                MediaQuery.of(context).size.width > 600 ? 400 : double.infinity,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: SingleChildScrollView(
                child:
                    _resetEmailSent
                        ? _buildSuccessContent()
                        : _buildResetForm(),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccessContent() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 32),
        const Icon(Icons.mark_email_read, size: 80, color: Color(0xFFFF7643)),
        const SizedBox(height: 24),
        const Text(
          "メール送信済み!",
          style: TextStyle(
            color: Colors.black,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          "パスワードリセットの手順が ${_emailController.text} メールで送信されました。",
          textAlign: TextAlign.center,
          style: const TextStyle(color: Color(0xFF757575)),
        ),
        const SizedBox(height: 24),
        const Text(
          "メールを確認し、リンクをクリックしてパスワードをリセットしてください.",
          textAlign: TextAlign.center,
          style: TextStyle(color: Color(0xFF757575)),
        ),
        const SizedBox(height: 32),
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 350),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                elevation: 0,
                backgroundColor: const Color(0xFFFF7643),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 48),
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
              ),
              child: const Text("ログインに戻る"),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildResetForm() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const SizedBox(height: 32),
          const Text(
            "パスワードを忘れた",
            style: TextStyle(
              color: Colors.black,
              fontSize: 32,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            "メールアドレスを入力すると、パスワードをリセットするためのリンクが送信されます",
            textAlign: TextAlign.center,
            style: TextStyle(color: Color(0xFF757575)),
          ),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: TextFormField(
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
              decoration: const InputDecoration(
                hintText: "メールアドレスを入力してください",
                labelText: "メール",
                floatingLabelBehavior: FloatingLabelBehavior.always,
                hintStyle: TextStyle(color: Color(0xFF757575)),
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 16,
                ),
                border: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF757575)),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFF757575)),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
                focusedBorder: OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xFFFF7643)),
                  borderRadius: BorderRadius.all(Radius.circular(100)),
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'メールアドレスは空欄にできません';
                }
                if (!RegExp(
                  r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$',
                ).hasMatch(value)) {
                  return '有効なメールアドレスを入力してください！';
                }
                return null;
              },
            ),
          ),
          if (_errorMessage != null)
            Padding(
              padding: const EdgeInsets.only(top: 16),
              child: Text(
                _errorMessage!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          const SizedBox(height: 32),
          ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 350),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: _isLoading ? null : _resetPassword,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFFFF7643),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(16)),
                  ),
                ),
                child:
                    _isLoading
                        ? const SizedBox(
                          height: 20,
                          width: 20,
                          child: CircularProgressIndicator(
                            color: Colors.white,
                            strokeWidth: 2,
                          ),
                        )
                        : const Text("りせっとリンクを送信"),
              ),
            ),
          ),
          const SizedBox(height: 20),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
            },
            child: const Text(
              'ログインに戻る',
              style: TextStyle(color: Color(0xFFFF7643)),
            ),
          ),
        ],
      ),
    );
  }
}
