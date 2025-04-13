import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/elder.dart';
import '../services/elder_service.dart';

final elderNotifierProvider =
    StateNotifierProvider<ElderNotifier, AsyncValue<List<Elder>>>((ref) {
      return ElderNotifier(ref);
    });

class ElderNotifier extends StateNotifier<AsyncValue<List<Elder>>> {
  final Ref ref;

  ElderNotifier(this.ref) : super(const AsyncLoading()) {
    _fetchElders();
  }

  Future<void> _fetchElders() async {
    try {
      final elders = await ref.read(elderServiceProvider).getElders();
      state = AsyncData(elders);
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> addElder(Elder elder) async {
    try {
      await ref.read(elderServiceProvider).addElder(elder);
      _fetchElders();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> deleteElder(String id) async {
    try {
      await ref.read(elderServiceProvider).deleteElder(id);
      _fetchElders();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> updateElder(Elder elder) async {
    try {
      await ref.read(elderServiceProvider).updateElder(elder);
      _fetchElders();
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }
}
