import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kiroku_notes_app/controllers/auth_controller.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, AsyncValue<User?>>(
      (ref) => AuthController(ref.read(firebaseAuthProvider)),
    );
