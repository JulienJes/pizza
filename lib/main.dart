import 'package:flutter/material.dart';
import 'package:pizza/stores/cart_store.dart';
import 'package:provider/provider.dart';
import 'package:pizza/screens/master.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => CartStore()),
      ],
      child: const Master(),
    ),
  );
}
