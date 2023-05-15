class Salad {
  final String name;
  final double price;
  final String image;
  int quantity;
  bool isCustom;
  List<String> ingredients;

  Salad({
    required this.name,
    required this.price,
    required this.image,
    this.quantity = 0,
    this.isCustom = false,
    this.ingredients = const [],
  });
}