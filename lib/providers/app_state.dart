import '../models/cart_item.dart';
import '../models/product.dart';

class AppState {
  static List<CartItem> cart = [];
  static List<Product> wishlist = [];

  static void addToCart(
    Product product, {
    String size = '',
    String color = '',
  }) {
    final index = cart.indexWhere(
      (i) => i.product.id == product.id && i.selectedSize == size,
    );
    if (index >= 0) {
      cart[index].quantity++;
    } else {
      cart.add(
        CartItem(product: product, selectedSize: size, selectedColor: color),
      );
    }
  }

  static void removeFromCart(String productId) {
    cart.removeWhere((i) => i.product.id == productId);
  }

  static void toggleWishlist(Product product) {
    final exists = wishlist.any((p) => p.id == product.id);
    if (exists) {
      wishlist.removeWhere((p) => p.id == product.id);
    } else {
      wishlist.add(product);
    }
  }

  static bool isWishlisted(String id) => wishlist.any((p) => p.id == id);

  static double get cartTotal => cart.fold(0, (sum, i) => sum + i.total);
  static int get cartCount => cart.fold(0, (sum, i) => sum + i.quantity);
}
