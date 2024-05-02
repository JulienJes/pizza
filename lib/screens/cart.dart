import 'package:flutter/material.dart';
import 'package:pizza/stores/cart_store.dart';
import 'package:pizza/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class Cart extends StatelessWidget {
  const Cart({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: Consumer<CartStore>(
        builder: (context, cartStore, child) {
          return cartStore.items.isEmpty
              ? const Center(
                  child: Text("Votre panier est vide"),
                )
              : Column(
                  children: [
                    Text(
                      "Panier",
                      style: Theme.of(context).textTheme.headlineMedium,
                    ),
                    Expanded(
                      child: ListView.builder(
                        itemCount: cartStore.items.length,
                        itemBuilder: (context, index) {
                          var item = cartStore.items.values.toList()[index];
                          var productId = cartStore.items.keys.toList()[index];
                          return Card(
                            margin: const EdgeInsets.all(8),
                            child: ListTile(
                              leading: CircleAvatar(
                                backgroundImage: NetworkImage(
                                    'https://pizzas.shrp.dev/assets/${item.pizza.image}'),
                              ),
                              title: Text(item.pizza.name),
                              subtitle: Text(
                                  'Total: ${item.totalPrice.toStringAsFixed(2)}€'),
                              trailing: SizedBox(
                                width: 130,
                                child: Row(
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: () {
                                        cartStore.removeItem(productId);
                                      },
                                    ),
                                    Text('${item.quantity}'),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: () {
                                        cartStore.addItem(item.pizza);
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        'Total: €${cartStore.totalAmount.toStringAsFixed(2)}',
                        style: Theme.of(context).textTheme.headlineMedium,
                      ),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
