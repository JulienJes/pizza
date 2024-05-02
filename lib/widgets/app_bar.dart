import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:pizza/screens/cart.dart';
import 'package:pizza/stores/cart_store.dart';
import 'package:provider/provider.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CustomAppBar({super.key});

  @override
  Widget build(BuildContext context) {
    final cartStore = Provider.of<CartStore>(context);
    int itemCount = cartStore.totalItems;
    return AppBar(
      title: const Text("Pizza Napoli"),
      backgroundColor: const Color(0xFFE35169),
      actions: [
        Padding(
          padding: const EdgeInsets.only(right: 40),
          child: badges.Badge(
            position: badges.BadgePosition.topEnd(top: -3, end: 0),
            badgeContent: Text(
              itemCount.toString(),
              style: const TextStyle(color: Colors.white),
            ),
            child: IconButton(
              icon: const Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const Cart()),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}
