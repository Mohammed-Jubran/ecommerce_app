class Item {
  final String id;
  final String name;
  final String imageUrl;
  final int price;
  final String description;

  Item(
      {required this.name,
      required this.imageUrl,
      required this.id,
      required this.price,
      required this.description});
}
