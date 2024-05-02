import 'package:pizza/models/pizza_data_model.dart';

class CartItem {
  final PizzaData pizza;
  int quantity;

  CartItem({required this.pizza, this.quantity = 1});

  void incrementQuantity() {
    quantity++;
  }

  void decrementQuantity() {
    if (quantity > 0) {
      quantity--;
    }
  }

  double get totalPrice => pizza.price * quantity;
}
