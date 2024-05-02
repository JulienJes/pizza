import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pizza/models/pizza_data_model.dart';
import 'package:pizza/services/pizza_service.dart';
import 'package:pizza/stores/cart_store.dart';
import 'package:pizza/widgets/app_bar.dart';
import 'package:provider/provider.dart';

class Details extends StatefulWidget {
  final String id;
  const Details({super.key, required this.id});

  @override
  State<Details> createState() => _Details();
}

class _Details extends State<Details> {
  late Future<PizzaData> _pizzaDetails;
  PizzaData? _loadedPizza;

  @override
  void initState() {
    super.initState();
    _pizzaDetails = fetchOnePizzaById(widget.id).then((pizza) {
      setState(() {
        _loadedPizza = pizza;
      });
      return pizza;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(),
      body: FutureBuilder<PizzaData>(
        future: _pizzaDetails,
        builder: (BuildContext context, AsyncSnapshot<PizzaData> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            var pizza = snapshot.data!;
            return Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    FutureBuilder<List<int>>(
                      future: fetchPicture(pizza.image),
                      builder: (BuildContext context,
                          AsyncSnapshot<List<int>> pictureSnapshot) {
                        if (pictureSnapshot.connectionState ==
                            ConnectionState.waiting) {
                          return const CircularProgressIndicator();
                        } else if (pictureSnapshot.hasError) {
                          return Text('Error: ${pictureSnapshot.error}');
                        } else {
                          return SizedBox(
                            width: 150,
                            height: 150,
                            child: Image.memory(
                                Uint8List.fromList(pictureSnapshot.data!)),
                          );
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(pizza.name,
                          style: Theme.of(context).textTheme.headlineSmall),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('${pizza.price.toString()} €',
                          style: Theme.of(context).textTheme.titleLarge),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Catégorie : ${pizza.category}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Base : ${pizza.base}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                          'Ingrédients : ${(pizza.ingredients as List).join(', ')}',
                          style: Theme.of(context).textTheme.bodyMedium),
                    ),
                  ],
                ),
              ),
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
      floatingActionButton: _loadedPizza != null
          ? FloatingActionButton(
              onPressed: () {
                Provider.of<CartStore>(context, listen: false)
                    .addItem(_loadedPizza!);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text("${_loadedPizza!.name} ajoutée au panier."),
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
              backgroundColor: const Color.fromARGB(255, 116, 48, 59),
              child: const Icon(Icons.add_shopping_cart, color: Colors.white),
            )
          : null,
    );
  }
}
