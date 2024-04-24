import 'package:dio/dio.dart';

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

Future<List<PizzaData>> fetchAllPizzas() async {
  String url = 'https://pizzas.shrp.dev/items/pizzas';

  try {
    final response = await Dio().get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    var dataList = response.data['data'] as List;
    return dataList.map((i) => PizzaData.fromJson(i)).toList();
  } catch (error) {
    // ignore: avoid_print
    print(error);
    throw Exception('Failed to load pizzas');
  }
}

Future<PizzaData> fetchOnePizzaById(id) async {
  String url = 'https://pizzas.shrp.dev/items/pizzas/$id';

  try {
    final response = await Dio().get(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
      ),
    );

    return PizzaData.fromJson(response.data['data']);
  } catch (error) {
    // ignore: avoid_print
    print(error);
    throw Exception('Failed to load pizzas');
  }
}

Future<List<int>> fetchPicture(id) async {
  print(id);
  String url = 'https://pizzas.shrp.dev/assets/$id';
  print(url);
  try {
    final response = await Dio().get<List<int>>(
      url,
      options: Options(
        headers: {
          'Content-Type': 'application/json',
        },
        responseType: ResponseType.bytes,
      ),
    );

    return response.data as List<int>;
  } catch (error) {
    // ignore: avoid_print
    print(error);
    throw Exception('Failed to load picture');
  }
}
