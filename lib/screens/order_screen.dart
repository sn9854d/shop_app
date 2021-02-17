import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/orders.dart' show Orders;
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const routeName = './order';

  @override
  Widget build(BuildContext context) {

    return Scaffold(
        appBar: AppBar(
          title: Text('Orders'),
        ),
        drawer: AppDrawer(),
        body: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchOrders(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshot.error != null) {
              return Center(child: Text('Something is wrong'));
            } else {
              return Consumer<Orders>(
                builder: (ctx, ordersData, child) {
                  return ListView.builder(
                    itemCount: ordersData.orders.length,
                    itemBuilder: (ctx, i) => OrderItem(
                      order: ordersData.orders[i],
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
