import 'package:dio/dio.dart';
import 'package:pizza/models/pizza_data_model.dart';

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
  String url = 'https://pizzas.shrp.dev/assets/$id';

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
