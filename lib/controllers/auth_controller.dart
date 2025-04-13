import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_auth/firebase_auth.dart';

final firebaseAuthProvider = Provider((ref) => FirebaseAuth.instance);

class AuthController extends StateNotifier<AsyncValue<User?>> {
  AuthController(this._auth) : super(const AsyncValue.data(null));

  final FirebaseAuth _auth;

  Future<void> signIn(String email, String password) async {
    state = const AsyncValue.loading();
    try {
      final result = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      state = AsyncValue.data(result.user);
    } on FirebaseAuthException catch (e) {
      state = AsyncValue.error(e.message ?? "Login failed", StackTrace.current);
    }
  }
}
