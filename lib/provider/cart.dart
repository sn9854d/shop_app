import 'package:flutter/foundation.dart';

class CartItem {
  final String id;
  final String title;
  final double price;
  final int quentity;

  CartItem({
    @required this.id,
    @required this.price,
    @required this.title,
    @required this.quentity,
  });
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount => _items.length;

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quentity;
    });
    return total;
  }

  void addTocart(String productId, double price, String title) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (value) => CartItem(
          id: value.id,
          price: value.price,
          title: value.title,
          quentity: value.quentity + 1,
        ),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          id: DateTime.now().toString(),
          price: price,
          title: title,
          quentity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void removeOneItem(String id) {
    if (!_items.containsKey(id)) {
      return;
    }
    if (_items[id].quentity > 1) {
      _items.update(
        id,
        (existingProduct) => CartItem(
            id: existingProduct.id,
            price: existingProduct.price,
            title: existingProduct.title,
            quentity: existingProduct.quentity - 1),
      );
    }else{
      _items.remove(id);
    }
    notifyListeners();
  }

  void removeFromCart(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clearCart() {
    _items = {};
    notifyListeners();
  }
}
