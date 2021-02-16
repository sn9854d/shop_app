import 'dart:math';

import 'package:flutter/material.dart';
import 'package:shop/provider/orders.dart' as ord;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem({
    @required this.order,
  });

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            ListTile(
              title: Text('\$${widget.order.amount}'),
              subtitle: Text(
                // order.dateTime.toString(),
                DateFormat('dd/MM/yyyy-hh:mm:ss').format(widget.order.dateTime),
              ),
              trailing: IconButton(
                icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                onPressed: () {
                  setState(() {
                    _expanded = !_expanded;
                  });
                },
              ),
            ),
            if (_expanded)
              Container(
                height: min(widget.order.products.length * 20.0 + 10, 100.0),
                child: ListView(
                  children: widget.order.products
                      .map(
                        (product) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              product.title,
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text('${product.quentity}x\$${product.price}'),
                          ],
                        ),
                      )
                      .toList(),
                ),
              )
          ],
        ),
      ),
    );
  }
}
