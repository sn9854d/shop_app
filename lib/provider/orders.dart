import 'package:flutter/material.dart';
import 'package:shop/provider/cart.dart';

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;

  OrderItem({
    @required this.id,
    @required this.amount,
    @required this.dateTime,
    @required this.products,
  });
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  List<OrderItem> get orders => [..._orders];

  void addOrder(List<CartItem> cartItems, double totalAmount) {
    _orders.insert(
      0,
      OrderItem(
        id: DateTime.now().toString(),
        amount: totalAmount,
        dateTime: DateTime.now(),
        products: cartItems,
      ),
    );

    notifyListeners();
  }
}
