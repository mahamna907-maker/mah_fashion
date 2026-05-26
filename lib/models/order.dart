class Order {
  final String id;
  final String productName;
  final String imageUrl;
  final double amount;
  final String date;
  final String status;

  Order({
    required this.id,
    required this.productName,
    required this.imageUrl,
    required this.amount,
    required this.date,
    required this.status,
  });
}
