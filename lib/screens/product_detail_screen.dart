import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../constants/app_colors.dart';
import '../models/product.dart';
import '../providers/app_provider.dart';
import 'main_screen.dart';

class ProductDetailScreen extends StatefulWidget {
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  String? _selectedSize;
  String? _selectedColor;

  final Map<String, Color> _colorMap = {
    'Red': Colors.red,
    'Purple': Colors.purple,
    'Black': Colors.black,
    'Green': Colors.green,
    'Pink': Colors.pink,
    'Brown': Colors.brown,
    'Rose': const Color(0xFFFF6B9D),
    'Nude': const Color(0xFFE8B9A0),
    'Khaki': const Color(0xFFBDB76B),
    'White': Colors.white,
    'Navy': const Color(0xFF001F5B),
    'Multicolor': const Color(0xFF9C27B0),
    'Blue': Colors.blue,
    'Burgundy': Colors.deepPurple,
    'Silver': Colors.blueGrey,
    'Gold': const Color(0xFFFFD700),
    'Light': const Color(0xFFFFF9C4),
    'Medium': const Color(0xFFFFCC80),
    'Deep': const Color(0xFF8D6E63),
    'Tan': const Color(0xFFD2B48C),
  };

  @override
  void initState() {
    super.initState();
    if (widget.product.sizes.isNotEmpty) {
      _selectedSize = widget.product.sizes.length > 1
          ? widget.product.sizes[1]
          : widget.product.sizes[0];
    }
    if (widget.product.colors.isNotEmpty) {
      _selectedColor = widget.product.colors[0];
    }
  }

  void _addToCart(BuildContext context) {
    context.read<AppProvider>().addToCart(
          widget.product,
          size: _selectedSize ?? '',
          color: _selectedColor ?? '',
        );
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Added to cart'),
        backgroundColor: AppColors.primary,
        duration: Duration(seconds: 1),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final p = widget.product;
    final wishlisted = context.watch<AppProvider>().isWishlisted(p.id);

    return Scaffold(
      backgroundColor: Colors.white,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 320,
            pinned: true,
            backgroundColor: AppColors.primaryLight,
            leading: IconButton(
              icon: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
                    color: Colors.white, shape: BoxShape.circle),
                child: const Icon(Icons.arrow_back_ios_new_rounded,
                    size: 16, color: AppColors.textDark),
              ),
              onPressed: () => Navigator.pop(context),
            ),
            actions: [
              IconButton(
                icon: Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      color: Colors.white, shape: BoxShape.circle),
                  child: Icon(
                    wishlisted
                        ? Icons.favorite_rounded
                        : Icons.favorite_border_rounded,
                    size: 18,
                    color: wishlisted ? AppColors.primary : AppColors.textGrey,
                  ),
                ),
                onPressed: () {
                  context.read<AppProvider>().toggleWishlist(p);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(wishlisted
                          ? 'Removed from wishlist'
                          : 'Added to wishlist'),
                      backgroundColor: AppColors.primary,
                      duration: const Duration(seconds: 1),
                    ),
                  );
                },
              ),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: CachedNetworkImage(
                imageUrl: p.imageUrl,
                fit: BoxFit.contain,
                placeholder: (_, __) =>
                    Container(color: AppColors.primaryLight),
                errorWidget: (_, __, ___) => Container(
                  color: AppColors.primaryLight,
                  child: const Icon(Icons.image_outlined,
                      color: AppColors.primary, size: 60),
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    p.category,
                    style: const TextStyle(
                        color: AppColors.primary,
                        fontSize: 12,
                        fontWeight: FontWeight.w600),
                  ),
                  const SizedBox(height: 6),
                  Text(p.name,
                      style: const TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      ...List.generate(
                        5,
                        (i) => Icon(
                          i < p.rating.floor()
                              ? Icons.star_rounded
                              : Icons.star_border_rounded,
                          color: AppColors.star,
                          size: 16,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Text('${p.rating} (${p.reviews} reviews)',
                          style: const TextStyle(
                              color: AppColors.textGrey, fontSize: 12)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Text('Rs ${p.price.toStringAsFixed(0)}',
                          style: const TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: AppColors.primary)),
                      if (p.originalPrice != null) ...[
                        const SizedBox(width: 10),
                        Text('Rs ${p.originalPrice!.toStringAsFixed(0)}',
                            style: const TextStyle(
                                fontSize: 15,
                                color: AppColors.textLight,
                                decoration: TextDecoration.lineThrough)),
                      ],
                    ],
                  ),

                  // Sizes
                  if (p.sizes.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('Select Size',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: p.sizes.map((s) {
                        final sel = s == _selectedSize;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedSize = s),
                          child: Container(
                            width: 44,
                            height: 40,
                            decoration: BoxDecoration(
                              color: sel ? AppColors.primary : Colors.white,
                              border: Border.all(
                                  color: sel
                                      ? AppColors.primary
                                      : Colors.grey.shade200),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Center(
                              child: Text(s,
                                  style: TextStyle(
                                      color: sel
                                          ? Colors.white
                                          : AppColors.textGrey,
                                      fontSize: 13,
                                      fontWeight: sel
                                          ? FontWeight.w600
                                          : FontWeight.normal)),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  // Colors
                  if (p.colors.isNotEmpty) ...[
                    const SizedBox(height: 20),
                    const Text('Select Color',
                        style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark)),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 10,
                      children: p.colors.map((c) {
                        final sel = c == _selectedColor;
                        final col = _colorMap[c] ?? Colors.grey;
                        return GestureDetector(
                          onTap: () => setState(() => _selectedColor = c),
                          child: Container(
                            width: 32,
                            height: 32,
                            decoration: BoxDecoration(
                              color: col,
                              shape: BoxShape.circle,
                              border: Border.all(
                                  color: sel
                                      ? AppColors.primary
                                      : Colors.grey.shade300,
                                  width: sel ? 2.5 : 1),
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ],

                  const SizedBox(height: 20),
                  const Text('Description',
                      style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.textDark)),
                  const SizedBox(height: 8),
                  Text(p.description,
                      style: const TextStyle(
                          color: AppColors.textGrey,
                          fontSize: 13,
                          height: 1.6)),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
                color: Colors.black.withOpacity(0.06),
                blurRadius: 10,
                offset: const Offset(0, -2))
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton(
                onPressed: () => _addToCart(context),
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(0, 50),
                  side: const BorderSide(color: AppColors.primary),
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  foregroundColor: AppColors.primary,
                ),
                child: const Text('Add to Cart',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: ElevatedButton(
                onPressed: () {
                  _addToCart(context);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const MainScreen(initialIndex: 2)),
                  );
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(0, 50),
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                ),
                child: const Text('Buy Now',
                    style: TextStyle(fontWeight: FontWeight.w600)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}