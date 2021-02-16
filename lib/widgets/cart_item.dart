import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';

class CartItem extends StatelessWidget {
  final double price;
  final String title;
  final int quentity;
  final String cartId;
  final String productId;

  CartItem({
    @required this.price,
    @required this.title,
    @required this.quentity,
    this.cartId,
    this.productId,
  });

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cartId),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (ctx) {
              return AlertDialog(
                title: Text('Are sure?'),
                content: Text('This will remove item if you click yes'),
                actions: [
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(true);
                    },
                    child: Text('Yes'),
                  ),
                  FlatButton(
                    onPressed: () {
                      Navigator.of(ctx).pop(false);
                    },
                    child: Text('No'),
                  ),
                ],
              );
            });
      },
      onDismissed: (_) {
        Provider.of<Cart>(context, listen: false).removeFromCart(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
        ),
        alignment: Alignment.centerRight,
        margin: EdgeInsets.only(
          top: 8,
          right: 8,
        ),
      ),
      child: Card(
        child: ListTile(
          leading: CircleAvatar(
            backgroundColor: Theme.of(context).primaryColor,
            child: Padding(
              padding: EdgeInsets.all(5),
              child: FittedBox(child: Text('\$$price')),
            ),
          ),
          title: Text(title),
          subtitle: Text('Total: \$$price'),
          trailing: Text('$quentity x'),
        ),
      ),
    );
  }
}
