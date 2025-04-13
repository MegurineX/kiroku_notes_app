import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/elder.dart';

final elderServiceProvider = Provider((ref) => ElderService());

class ElderService {
  final CollectionReference eldersCollection = FirebaseFirestore.instance
      .collection('elders');

  Future<List<Elder>> getElders() async {
    final snapshot = await eldersCollection.get();
    return snapshot.docs
        .map((doc) => Elder.fromMap(doc.data() as Map<String, dynamic>, doc.id))
        .toList();
  }

  Future<void> addElder(Elder elder) async {
    await eldersCollection.add(elder.toMap());
  }

  Future<void> deleteElder(String id) async {
    await eldersCollection.doc(id).delete();
  }

  Future<void> updateElder(Elder elder) async {
    await eldersCollection.doc(elder.id).update(elder.toMap());
  }
}
