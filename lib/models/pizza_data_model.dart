class PizzaData {
  final String id;
  final String name;
  final double price;
  final String base;
  final Object ingredients;
  final String image;
  final String category;

  PizzaData(
      {required this.id,
      required this.name,
      required this.price,
      required this.base,
      required this.ingredients,
      required this.image,
      required this.category});

  factory PizzaData.fromJson(Map<String, dynamic> json) {
    return PizzaData(
        id: json['id'],
        name: json['name'],
        price: json['price'],
        base: json['base'],
        ingredients: json['ingredients'],
        image: json['image'],
        category: json['category']);
  }
}
