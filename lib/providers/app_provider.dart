import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '../models/cart_item.dart';
import '../models/product.dart';

class AppProvider extends ChangeNotifier {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  // ─── Auth ───────────────────────────────────────────────
  User? get currentUser => _auth.currentUser;
  bool get isLoggedIn => _auth.currentUser != null;

  Stream<User?> get authStateChanges => _auth.authStateChanges();

  // ─── User profile data ──────────────────────────────────
  String _displayName = '';
  String _userEmail = '';
  String _phone = '';

  String get displayName => _displayName;
  String get userEmail => _userEmail;
  String get phone => _phone;

  // ─── Cart (in-memory, synced to Firestore) ──────────────
  List<CartItem> _cart = [];
  List<CartItem> get cart => _cart;

  double get cartTotal => _cart.fold(0, (sum, i) => sum + i.total);
  int get cartCount => _cart.fold(0, (sum, i) => sum + i.quantity);

  // ─── Wishlist (in-memory) ───────────────────────────────
  List<Product> _wishlist = [];
  List<Product> get wishlist => _wishlist;
  bool isWishlisted(String id) => _wishlist.any((p) => p.id == id);

  // ═══════════════════════════════════════════════════════
  //  AUTH METHODS
  // ═══════════════════════════════════════════════════════

  Future<String?> login(String email, String password) async {
    try {
      final result = await _auth.signInWithEmailAndPassword(
          email: email.trim(), password: password.trim());
      if (result.user == null) return 'Login failed. Please try again.';
      await loadUserProfile();
      await loadCartFromFirestore();
      return null; // success
    } on FirebaseAuthException catch (e) {
      return _authError(e.code);
    } catch (e) {
      return 'Login failed: ${e.toString()}';
    }
  }

  Future<String?> register(
      String name, String email, String password, String phone) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
          email: email.trim(), password: password.trim());

      if (cred.user == null) return 'Registration failed. Please try again.';

      // Save user profile to Firestore
      await _db.collection('users').doc(cred.user!.uid).set({
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
        'createdAt': FieldValue.serverTimestamp(),
      });

      await cred.user!.updateDisplayName(name.trim());
      await loadUserProfile();
      return null; // success
    } on FirebaseAuthException catch (e) {
      return _authError(e.code);
    } catch (e) {
      return 'Registration failed: ${e.toString()}';
    }
  }

  Future<void> logout() async {
    _cart.clear();
    _wishlist.clear();
    _displayName = '';
    _userEmail = '';
    _phone = '';
    await _auth.signOut();
    notifyListeners();
  }

  String _authError(String code) {
    switch (code) {
      case 'user-not-found':
        return 'No account found with this email.';
      case 'wrong-password':
        return 'Incorrect password.';
      case 'invalid-credential':
        return 'Invalid email or password.';
      case 'email-already-in-use':
        return 'An account already exists with this email.';
      case 'weak-password':
        return 'Password must be at least 6 characters.';
      case 'invalid-email':
        return 'Please enter a valid email address.';
      case 'network-request-failed':
        return 'Network error. Check your connection.';
      case 'too-many-requests':
        return 'Too many attempts. Please try again later.';
      case 'operation-not-allowed':
        return 'Email/Password sign-in is not enabled in Firebase Console.';
      case 'user-disabled':
        return 'This account has been disabled.';
      default:
        return 'Error ($code). Please try again.';
    }
  }

  // ═══════════════════════════════════════════════════════
  //  USER PROFILE
  // ═══════════════════════════════════════════════════════

  Future<void> loadUserProfile() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final doc = await _db.collection('users').doc(uid).get();
    if (doc.exists) {
      final data = doc.data()!;
      _displayName = data['name'] ?? '';
      _userEmail = data['email'] ?? _auth.currentUser?.email ?? '';
      _phone = data['phone'] ?? '';
      notifyListeners();
    }
  }

  Future<String?> updateProfile(
      String name, String email, String phone) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 'Not logged in.';
    try {
      await _db.collection('users').doc(uid).update({
        'name': name.trim(),
        'email': email.trim(),
        'phone': phone.trim(),
      });
      _displayName = name.trim();
      _userEmail = email.trim();
      _phone = phone.trim();
      notifyListeners();
      return null;
    } catch (e) {
      return 'Failed to update profile.';
    }
  }

  // ═══════════════════════════════════════════════════════
  //  CART
  // ═══════════════════════════════════════════════════════

  Future<void> loadCartFromFirestore() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final snap =
        await _db.collection('users').doc(uid).collection('cart').get();

    _cart = snap.docs.map((doc) {
      final data = doc.data();
      return CartItem(
        product: Product.fromMap(data['product'] as Map<String, dynamic>),
        quantity: data['quantity'] as int,
        selectedSize: data['selectedSize'] as String,
        selectedColor: data['selectedColor'] as String,
      );
    }).toList();

    notifyListeners();
  }

  Future<void> addToCart(Product product,
      {String size = '', String color = ''}) async {
    final index = _cart.indexWhere(
        (i) => i.product.id == product.id && i.selectedSize == size);
    if (index >= 0) {
      _cart[index].quantity++;
    } else {
      _cart.add(CartItem(
          product: product, selectedSize: size, selectedColor: color));
    }
    notifyListeners();
    await _saveCartToFirestore();
  }

  Future<void> removeFromCart(String productId) async {
    _cart.removeWhere((i) => i.product.id == productId);
    notifyListeners();
    await _saveCartToFirestore();
  }

  Future<void> updateQuantity(String productId, int quantity) async {
    final index = _cart.indexWhere((i) => i.product.id == productId);
    if (index >= 0) {
      if (quantity <= 0) {
        _cart.removeAt(index);
      } else {
        _cart[index].quantity = quantity;
      }
      notifyListeners();
      await _saveCartToFirestore();
    }
  }

  Future<void> clearCart() async {
    _cart.clear();
    notifyListeners();
    await _saveCartToFirestore();
  }

  Future<void> _saveCartToFirestore() async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return;

    final cartRef = _db.collection('users').doc(uid).collection('cart');

    // Delete existing cart docs
    final existing = await cartRef.get();
    for (final doc in existing.docs) {
      await doc.reference.delete();
    }

    // Write current cart
    for (final item in _cart) {
      await cartRef.add({
        'product': item.product.toMap(),
        'quantity': item.quantity,
        'selectedSize': item.selectedSize,
        'selectedColor': item.selectedColor,
      });
    }
  }

  // ═══════════════════════════════════════════════════════
  //  WISHLIST
  // ═══════════════════════════════════════════════════════

  void toggleWishlist(Product product) {
    final exists = _wishlist.any((p) => p.id == product.id);
    if (exists) {
      _wishlist.removeWhere((p) => p.id == product.id);
    } else {
      _wishlist.add(product);
    }
    notifyListeners();
  }

  // ═══════════════════════════════════════════════════════
  //  ORDERS
  // ═══════════════════════════════════════════════════════

  Future<String?> placeOrder({
    required String name,
    required String phone,
    required String address,
    required String city,
    required String postalCode,
    required String paymentMethod,
  }) async {
    final uid = _auth.currentUser?.uid;
    if (uid == null) return 'Not logged in.';
    if (_cart.isEmpty) return 'Cart is empty.';

    try {
      final items = _cart
          .map((item) => {
                'productId': item.product.id,
                'productName': item.product.name,
                'imageUrl': item.product.imageUrl,
                'price': item.product.price,
                'quantity': item.quantity,
                'selectedSize': item.selectedSize,
                'selectedColor': item.selectedColor,
                'subtotal': item.total,
              })
          .toList();

      await _db.collection('orders').add({
        'userId': uid,
        'items': items,
        'total': cartTotal,
        'status': 'Processing',
        'paymentMethod': paymentMethod,
        'deliveryDetails': {
          'name': name,
          'phone': phone,
          'address': address,
          'city': city,
          'postalCode': postalCode,
        },
        'createdAt': FieldValue.serverTimestamp(),
      });

      await clearCart();
      return null; // success
    } catch (e) {
      return 'Failed to place order. Please try again.';
    }
  }

  Stream<QuerySnapshot> getOrdersStream() {
    final uid = _auth.currentUser?.uid;
    if (uid == null) {
      return const Stream.empty();
    }
    return _db
        .collection('orders')
        .where('userId', isEqualTo: uid)
        .orderBy('createdAt', descending: true)
        .snapshots();
  }
}
