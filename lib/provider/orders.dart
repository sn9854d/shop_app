import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shop/provider/cart.dart';
import 'package:http/http.dart' as http;

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
  String _authToken;
  String _userId;

  List<OrderItem> get orders => [..._orders];

  void setValue(String token,String userID, List<OrderItem> orderItem){
    _authToken = token;
    _userId = userID;
    _orders = orderItem;
  }

  Future<void> fetchOrders() async {
    final url = 'https://shop-e1d9f-default-rtdb.firebaseio.com//orders/$_userId.json?auth=$_authToken';
    final response = await http.get(url);
    final fetchedData = json.decode(response.body) as Map<String, dynamic>;
    final List<OrderItem> fetchedOrders = [];
    if(fetchedData == null){
      return ;
    }
    fetchedData.forEach((orderId, orders) {
      fetchedOrders.add(OrderItem(
        id: orderId,
        amount: orders['amount'],
        dateTime: DateTime.parse(orders['dateTime']),
        products: (orders['products'] as List<dynamic>)
            .map((item) => CartItem(
                price: item['price'],
                title: item['title'],
                quentity: item['quentity'],
                id: item['id']))
            .toList(),
      ));
    });
    _orders = fetchedOrders;
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartItems, double totalAmount) async {
    final url = 'https://shop-e1d9f-default-rtdb.firebaseio.com//orders/$_userId.json?auth=$_authToken';
    try {
      final response = await http.post(url,
          body: json.encode({
            'amount': totalAmount,
            'dateTime': DateTime.now().toIso8601String(),
            'products': cartItems
                .map((cp) => {
                      'price': cp.price,
                      'quentity': cp.quentity,
                      'title': cp.title,
                      'id': cp.id
                    })
                .toList(),
          }));
      _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: totalAmount,
          dateTime: DateTime.now(),
          products: cartItems,
        ),
      );
      notifyListeners();
    } catch (e) {}
  }
}
