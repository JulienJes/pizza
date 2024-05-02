import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pizza/screens/details.dart';
import 'package:pizza/models/pizza_data_model.dart';
import 'package:pizza/services/pizza_service.dart';
import 'package:pizza/stores/cart_store.dart';
import 'package:pizza/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class Master extends StatefulWidget {
  const Master({super.key});

  @override
  State<Master> createState() => _Master();
}

class _Master extends State<Master> {
  late Future<List<PizzaData>> _pizzas;

  @override
  void initState() {
    super.initState();
    _pizzas = fetchAllPizzas();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: const CustomAppBar(),
        body: FutureBuilder<List<PizzaData>>(
          future: _pizzas,
          builder:
              (BuildContext context, AsyncSnapshot<List<PizzaData>> snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError) {
              return Center(child: Text('Error: ${snapshot.error}'));
            } else {
              return ListView.builder(
                itemCount: snapshot.data?.length,
                itemBuilder: (context, index) {
                  var pizza = snapshot.data![index];
                  return InkWell(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => Details(id: pizza.id),
                        ),
                      );
                    },
                    child: ListTile(
                      leading: FutureBuilder<List<int>>(
                        future: fetchPicture(pizza.image),
                        builder:
                            (context, AsyncSnapshot<List<int>> imageSnapshot) {
                          if (imageSnapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const SizedBox(
                              width: 50,
                              height: 50,
                              child: CircularProgressIndicator(),
                            );
                          } else if (imageSnapshot.hasError) {
                            return const Icon(Icons.error);
                          } else {
                            return CircleAvatar(
                              backgroundImage: MemoryImage(
                                  Uint8List.fromList(imageSnapshot.data!)),
                              radius: 25,
                            );
                          }
                        },
                      ),
                      title: Row(
                        children: [
                          Text(pizza.name,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(width: 10),
                          Text('${pizza.price.toString()} €',
                              style: Theme.of(context).textTheme.titleSmall)
                        ],
                      ),
                      subtitle: Text(
                        '${pizza.base}, ${(pizza.ingredients as List).join(', ')}',
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: IconButton(
                        icon: const Icon(Icons.add_shopping_cart),
                        onPressed: () {
                          Provider.of<CartStore>(context, listen: false)
                              .addItem(pizza);
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text("${pizza.name} ajoutée au panier."),
                              duration: const Duration(seconds: 2),
                            ),
                          );
                        },
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
