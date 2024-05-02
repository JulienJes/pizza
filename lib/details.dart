import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pizza/services/pizza_service.dart';

class Details extends StatefulWidget {
  final String id;
  const Details({super.key, required this.id});

  @override
  State<Details> createState() => _Details();
}

class _Details extends State<Details> {
  late Future<PizzaData> _pizzaDetails;

  @override
  void initState() {
    super.initState();
    _pizzaDetails = fetchOnePizzaById(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pizza Napoli'),
        backgroundColor: const Color(0xFFE35169),
      ),
      body: FutureBuilder<PizzaData>(
        future: _pizzaDetails,
        builder: (BuildContext context, AsyncSnapshot<PizzaData> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (snapshot.hasData) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                FutureBuilder<List<int>>(
                  future: fetchPicture(snapshot.data!.image),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<int>> snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    } else if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    } else {
                      return SizedBox(
                        width: 150,
                        height: 150,
                        child: Image.memory(Uint8List.fromList(snapshot.data!)),
                      );
                    }
                  },
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(snapshot.data!.name,
                            style: Theme.of(context).textTheme.headlineSmall),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('${snapshot.data?.price.toString()} €',
                            style: Theme.of(context).textTheme.titleLarge),
                      ),
                    ],
                  ),
                ),
                Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Catégorie : ${snapshot.data?.category}',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('Base : ${snapshot.data?.base}',
                            style: Theme.of(context).textTheme.bodyMedium),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      'Ingrédient : ${(snapshot.data?.ingredients as List).join(', ')}',
                      style: Theme.of(context).textTheme.bodyMedium),
                ),
              ],
            );
          } else {
            return const Center(child: Text('No data available'));
          }
        },
      ),
    );
  }
}
