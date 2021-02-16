import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/orders.dart' show Orders;
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = './order';
  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context).orders;
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: ordersData.length,
          itemBuilder: (ctx, i) => OrderItem(
            order: ordersData[i],
          ),
        ),
      ),
    );
  }
}
