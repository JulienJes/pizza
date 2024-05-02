import 'package:flutter/material.dart';
import 'package:pizza/models/cart_item_model.dart';
import 'package:pizza/models/pizza_data_model.dart';

class CartStore with ChangeNotifier {
  final Map<String, CartItem> _items = {};

  Map<String, CartItem> get items => _items;

  void addItem(PizzaData pizza) {
    if (_items.containsKey(pizza.id)) {
      _items.update(
          pizza.id,
          (existingCartItem) => CartItem(
              pizza: existingCartItem.pizza,
              quantity: existingCartItem.quantity + 1));
    } else {
      _items.putIfAbsent(pizza.id, () => CartItem(pizza: pizza));
    }
    notifyListeners();
  }

  void removeItem(String pizzaId) {
    if (_items.containsKey(pizzaId) && _items[pizzaId]!.quantity > 1) {
      _items.update(
          pizzaId,
          (existingCartItem) => CartItem(
              pizza: existingCartItem.pizza,
              quantity: existingCartItem.quantity - 1));
    } else {
      _items.remove(pizzaId);
    }
    notifyListeners();
  }

  double get totalAmount {
    return _items.values
        .map((item) => item.totalPrice)
        .fold(0.0, (sum, item) => sum + item);
  }

  int get totalItems {
    int total = 0;
    for (var item in _items.values) {
      total += item.quantity;
    }
    return total;
  }
}
