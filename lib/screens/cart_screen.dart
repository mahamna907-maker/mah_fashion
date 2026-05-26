import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../providers/app_provider.dart';
import 'checkout_screen.dart';

class CartScreen extends StatelessWidget {
  final Function(int) onTabChange;
  const CartScreen({super.key, required this.onTabChange});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<AppProvider>();
    final cart = provider.cart;
    final subtotal = provider.cartTotal;
    const discount = 300.0;
    final total = subtotal > 0 ? subtotal - discount : 0.0;

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        title: Column(
          children: [
            const Text(
              'My Cart',
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark),
            ),
            Text(
              '${cart.length} item${cart.length == 1 ? '' : 's'}',
              style:
                  const TextStyle(fontSize: 12, color: AppColors.textGrey),
            ),
          ],
        ),
      ),
      body: cart.isEmpty
          ? Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.shopping_bag_outlined,
                      size: 80, color: AppColors.textLight),
                  const SizedBox(height: 16),
                  const Text('Your cart is empty',
                      style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textGrey)),
                  const SizedBox(height: 8),
                  const Text('Add items to get started',
                      style: TextStyle(color: AppColors.textLight)),
                  const SizedBox(height: 24),
                  ElevatedButton(
                    onPressed: () => onTabChange(1),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text('Shop Now'),
                  ),
                ],
              ),
            )
          : Column(
              children: [
                Expanded(
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: cart.length,
                    separatorBuilder: (_, __) =>
                        const SizedBox(height: 12),
                    itemBuilder: (_, i) {
                      final item = cart[i];
                      return Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            BoxShadow(
                                color: AppColors.cardShadow, blurRadius: 6)
                          ],
                        ),
                        child: Row(
                          children: [
                            // Product image
                            ClipRRect(
                              borderRadius: BorderRadius.circular(10),
                              child: CachedNetworkImage(
                                imageUrl: item.product.imageUrl,
                                width: 80,
                                height: 80,
                                fit: BoxFit.cover,
                                placeholder: (_, __) => Container(
                                    width: 80,
                                    height: 80,
                                    color: AppColors.primaryLight),
                                errorWidget: (_, __, ___) => Container(
                                  width: 80,
                                  height: 80,
                                  color: AppColors.primaryLight,
                                  child: const Icon(Icons.image_outlined,
                                      color: AppColors.primary),
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            // Details
                            Expanded(
                              child: Column(
                                crossAxisAlignment:
                                    CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    item.product.name,
                                    style: const TextStyle(
                                        fontSize: 14,
                                        fontWeight: FontWeight.w600,
                                        color: AppColors.textDark),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    [
                                      if (item.selectedSize.isNotEmpty)
                                        'Size: ${item.selectedSize}',
                                      if (item.selectedColor.isNotEmpty)
                                        'Color: ${item.selectedColor}',
                                    ].join('   '),
                                    style: const TextStyle(
                                        fontSize: 12,
                                        color: AppColors.textGrey),
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        'Rs ${item.total.toStringAsFixed(0)}',
                                        style: const TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                            color: AppColors.primary),
                                      ),
                                      // Quantity controls
                                      Row(
                                        children: [
                                          _qtyBtn(
                                            Icons.remove,
                                            () => context
                                                .read<AppProvider>()
                                                .updateQuantity(
                                                  item.product.id,
                                                  item.quantity - 1,
                                                ),
                                          ),
                                          Padding(
                                            padding:
                                                const EdgeInsets.symmetric(
                                                    horizontal: 10),
                                            child: Text('${item.quantity}',
                                                style: const TextStyle(
                                                    fontWeight:
                                                        FontWeight.w600)),
                                          ),
                                          _qtyBtn(
                                            Icons.add,
                                            () => context
                                                .read<AppProvider>()
                                                .updateQuantity(
                                                  item.product.id,
                                                  item.quantity + 1,
                                                ),
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Remove button
                            IconButton(
                              icon: const Icon(Icons.close,
                                  size: 18, color: AppColors.textLight),
                              onPressed: () => context
                                  .read<AppProvider>()
                                  .removeFromCart(item.product.id),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ),

                // Order summary
                Container(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 30),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [
                      BoxShadow(
                          color: Colors.black.withOpacity(0.06),
                          blurRadius: 10,
                          offset: const Offset(0, -2))
                    ],
                  ),
                  child: Column(
                    children: [
                      const Text('Order Summary',
                          style: TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textDark)),
                      const SizedBox(height: 12),
                      _summaryRow(
                          'Subtotal', 'Rs ${subtotal.toStringAsFixed(0)}'),
                      _summaryRow('Delivery', 'Free',
                          valueColor: AppColors.green),
                      _summaryRow('Discount', '- Rs 300',
                          valueColor: AppColors.sale),
                      Divider(height: 24, color: Colors.grey.shade200),
                      _summaryRow(
                          'Total', 'Rs ${total.toStringAsFixed(0)}',
                          isBold: true),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () => Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (_) => const CheckoutScreen()),
                          ),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primary,
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Text('Proceed to Checkout →',
                              style:
                                  TextStyle(fontWeight: FontWeight.w600)),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }

  Widget _qtyBtn(IconData icon, VoidCallback onTap) => GestureDetector(
        onTap: onTap,
        child: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: AppColors.primaryLight,
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 16, color: AppColors.primary),
        ),
      );

  Widget _summaryRow(String label, String value,
          {Color? valueColor, bool isBold = false}) =>
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: TextStyle(
                    color:
                        isBold ? AppColors.textDark : AppColors.textGrey,
                    fontWeight:
                        isBold ? FontWeight.bold : FontWeight.normal,
                    fontSize: isBold ? 15 : 13)),
            Text(value,
                style: TextStyle(
                    color: valueColor ??
                        (isBold ? AppColors.textDark : AppColors.textGrey),
                    fontWeight:
                        isBold ? FontWeight.bold : FontWeight.normal,
                    fontSize: isBold ? 15 : 13)),
          ],
        ),
      );
}