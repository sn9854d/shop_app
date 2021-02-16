import 'package:flutter/material.dart';
import 'package:shop/screens/order_screen.dart';
import 'package:shop/screens/user_products_screen.dart';

class AppDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('App Drawer'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
          ),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Order'),
            onTap: () => Navigator.of(context).pushReplacementNamed(OrderScreen.routeName),
          ),

          ListTile(
            leading: Icon(Icons.edit),
            title: Text('Mangage Products'),
            onTap: () => Navigator.of(context).pushReplacementNamed(UserProductsScreen.routeName),
          ),
        ],
      ),
    );
  }
}
