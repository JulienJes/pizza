import 'package:flutter/material.dart';
import 'package:pizza/details.dart';
import 'package:pizza/models/pizza_data_model.dart';
import 'package:pizza/services/pizza_service.dart';

class Master extends StatefulWidget {
  const Master({super.key});

  @override
  State<Master> createState() => _Master();

  void setState(Null Function() param0) {}
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
        appBar: AppBar(
          title: const Text('Pizza Napoli'),
          backgroundColor: const Color(0xFFE35169),
        ),
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
                  return InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                Details(id: snapshot.data![index].id),
                          ),
                        );
                      },
                      child: ListTile(
                        title: Text(snapshot.data![index].name),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text('${snapshot.data?[index].price.toString()} €'),
                            Text(
                                '${snapshot.data?[index].base}, ${(snapshot.data?[index].ingredients as List).join(', ')}'),
                          ],
                        ),
                      ));
                },
              );
            }
          },
        ),
      ),
    );
  }
}
