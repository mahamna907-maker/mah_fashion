/// Run seedProducts() ONCE after first login to populate Firestore.
/// After seeding, you can remove the call — data stays in Firestore forever.

class SeedData {
  static final List<Map<String, dynamic>> products = [
    // ── DRESSES ──
    {
      'id': '1',
      'name': 'Summer Dress',
      'category': 'Dresses',
      'price': 2499.0,
      'originalPrice': 3200.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1515372039744-b8f02a3ae446?w=400&fit=crop&auto=format',
      'rating': 4.9,
      'reviews': 248,
      'description':
          'A romantic floral midi dress in breathable chiffon. Flattering wrap silhouette with adjustable tie waist and ruffle hem. Perfect for any occasion.',
      'sizes': ['XS', 'S', 'M', 'L', 'XL'],
      'colors': ['Red', 'Purple', 'Black', 'Green'],
      'isNew': true,
      'isSale': false,
    },
    {
      'id': '2',
      'name': 'Floral Maxi Dress',
      'category': 'Dresses',
      'price': 3199.0,
      'originalPrice': 4000.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1496747611176-843222e1e57c?w=400&fit=crop&auto=format',
      'rating': 4.7,
      'reviews': 182,
      'description':
          'Elegant floral maxi dress perfect for summer events. Light and flowy fabric with a flattering silhouette.',
      'sizes': ['XS', 'S', 'M', 'L', 'XL'],
      'colors': ['Pink', 'Blue', 'White'],
      'isNew': false,
      'isSale': true,
    },
    // ── SHOES ──
    {
      'id': '3',
      'name': 'Rose Block Heels',
      'category': 'Shoes',
      'price': 1799.0,
      'originalPrice': 2500.0,
      'imageUrl':
          'https://images.unsplash.com/photo-1543163521-1bf539c55dd2?w=400&fit=crop&auto=format',
      'rating': 4.5,
      'reviews': 89,
      'description':
          'Elegant rose-toned block heels with cushioned insole. 3-inch heel height for comfortable all-day wear.',
      'sizes': ['36', '37', '38', '39', '40'],
      'colors': ['Rose', 'Nude', 'Black'],
      'isNew': false,
      'isSale': true,
    },
    {
      'id': '4',
      'name': 'White Sneakers',
      'category': 'Shoes',
      'price': 2299.0,
      'originalPrice': null,
      'imageUrl':
          'https://images.unsplash.com/photo-1542291026-7eec264c27ff?w=400&fit=crop&auto=format',
      'rating': 4.6,
      'reviews': 310,
      'description':
          'Classic white sneakers with premium leather upper. Comfortable cushioned sole for everyday wear.',
      'sizes': ['36', '37', '38', '39', '40', '41'],
      'colors': ['White', 'Black'],
      'isNew': true,
      'isSale': false,
    },
    // ── BAGS ──
    {
      'id': '5',
      'name': 'Elegant Pink Handbag',
      'category': 'Bags',
      'price': 3299.0,
      'originalPrice': null,
      'imageUrl':
          'https://images.unsplash.com/photo-1548036328-c9fa89d128fa?w=400&fit=crop&auto=format',
      'rating': 4.7,
      'reviews': 134,
      'description':
          'Premium quality leather handbag with gold hardware. Spacious interior with multiple pockets.',
      'sizes': [],
      'colors': ['Pink', 'Brown', 'Black'],
      'isNew': false,
      'isSale': false,
    },
    {
      'id': '6',
      'name': 'Brown Tote Bag',
      'category': 'Bags',
      'price': 2799.0,
      'originalPrice': null,
      'imageUrl':
          'https://images.unsplash.com/photo-1590874103328-eac38a683ce7?w=400&fit=crop&auto=format',
      'rating': 4.4,
      'reviews': 97,
      'description':
          'Spacious brown tote bag in genuine leather. Perfect for work or weekend outings.',
      'sizes': [],
      'colors': ['Brown', 'Black', 'Tan'],
      'isNew': true,
      'isSale': false,
    },
    // ── JEWELS ──
    {
      'id': '7',
      'name': 'Pearl Drop Earrings',
      'category': 'Jewels',
      'price': 649.0,
      'originalPrice': null,
      'imageUrl':
          'https://images.unsplash.com/photo-1535632066927-ab7c9ab60908?w=400&fit=crop&auto=format',
      'rating': 4.8,
      'reviews': 312,
      'description':
          'Delicate freshwater pearl drop earrings set in sterling silver. Perfect for both casual and formal occasions.',
      'sizes': [],
      'colors': ['White', 'Pink'],
      'isNew': false,
      'isSale': false,
    },
    {
      'id': '8',
      'name': 'Diamond Ring',
      'category': 'Jewels',
      'price': 12999.0,
      'originalPrice': null,
      'imageUrl':
          'https://images.unsplash.com/photo-1605100804763-247f67b3557e?w=400&fit=crop&auto=format',
      'rating': 5.0,
      'reviews': 45,
      'description':
          'Stunning solitaire diamond ring in 18K white gold setting. A timeless piece for special occasions.',
      'sizes': ['5', '6', '7', '8'],
      'colors': ['Silver', 'Gold'],
      'isNew': true,
      'isSale': false,
    },
    // ── BEAUTY ──
    {
      'id': '9',
      'name': 'Velvet Lipstick',
      'category': 'Beauty',
      'price': 549.0,
      'originalPrice': null,
      'imageUrl':
          'https://images.unsplash.com/photo-1596462502278-27bfdc403348?w=400&fit=crop&auto=format',
      'rating': 4.4,
      'reviews': 201,
      'description':
          'Long-lasting velvet matte lipstick with moisturizing formula. Available in 12 stunning shades.',
      'sizes': [],
      'colors': ['Red', 'Pink', 'Nude', 'Burgundy'],
      'isNew': false,
      'isSale': true,
    },
    {
      'id': '10',
      'name': 'Glow Face Palette',
      'category': 'Beauty',
      'price': 1299.0,
      'originalPrice': null,
      'imageUrl':
          'https://images.unsplash.com/photo-1512496015851-a90fb38ba796?w=400&fit=crop&auto=format',
      'rating': 4.6,
      'reviews': 178,
      'description':
          'All-in-one glow face palette with highlighter, blush and bronzer. Buildable coverage for a radiant look.',
      'sizes': [],
      'colors': ['Light', 'Medium', 'Deep'],
      'isNew': true,
      'isSale': false,
    },
    // ── ACCESSORIES ──
    {
      'id': '11',
      'name': 'Linen Blazer',
      'category': 'Accessories',
      'price': 3799.0,
      'originalPrice': null,
      'imageUrl':
          'https://images.unsplash.com/photo-1591047139829-d91aecb6caea?w=400&fit=crop&auto=format',
      'rating': 4.6,
      'reviews': 67,
      'description':
          'Lightweight linen blazer, perfect for warm-weather styling. Single-button closure with notched lapels.',
      'sizes': ['XS', 'S', 'M', 'L', 'XL'],
      'colors': ['Khaki', 'White', 'Navy'],
      'isNew': true,
      'isSale': false,
    },
    {
      'id': '12',
      'name': 'Silk Wrap Scarf',
      'category': 'Accessories',
      'price': 899.0,
      'originalPrice': null,
      'imageUrl':
          'https://images.unsplash.com/photo-1601924638867-3a6de6b7a500?w=400&fit=crop&auto=format',
      'rating': 4.3,
      'reviews': 156,
      'description':
          'Luxurious 100% silk wrap scarf with vibrant print. Versatile styling options for every season.',
      'sizes': [],
      'colors': ['Multicolor', 'Blue', 'Red'],
      'isNew': false,
      'isSale': false,
    },
  ];
}