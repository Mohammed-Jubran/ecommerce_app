class CartItem {
  final String id;
  final String itemId;
  final String imageUrl;
  final String name;
  final int price;
  final int count;

  CartItem(
      {required this.id,
      required this.itemId,
      required this.name,
      required this.count,
      required this.price,
      required this.imageUrl});
}
