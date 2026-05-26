import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/product.dart';

class FirestoreService {
  static final _db = FirebaseFirestore.instance;

  // ── Products ──────────────────────────────────────────

  /// Fetch all products once
  static Future<List<Product>> fetchProducts() async {
    final snap = await _db.collection('products').get();
    return snap.docs
        .map((doc) => Product.fromMap(doc.data(), doc.id))
        .toList();
  }

  /// Live stream of all products
  static Stream<List<Product>> productsStream() {
    return _db.collection('products').snapshots().map(
          (snap) => snap.docs
              .map((doc) => Product.fromMap(doc.data(), doc.id))
              .toList(),
        );
  }

  /// Seed products into Firestore (run once)
  static Future<void> seedProducts(List<Map<String, dynamic>> products) async {
    final batch = _db.batch();
    for (final p in products) {
      final ref = _db.collection('products').doc(p['id'] as String);
      batch.set(ref, p);
    }
    await batch.commit();
  }
}