import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/badge.dart';
import 'package:shop/widgets/product_grid.dart';

enum FilterOption { Favoirates, All }

class ProductOverViewScreen extends StatefulWidget {
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductOverViewScreen> {
  var _showFav = false;
  bool _isLoading = false;
  bool _isInit = true;
  void initState() {
    super.initState();
  }

  void didChangeDependencies() {
    if (_isInit) {
      setState(() {
        _isLoading = true;
      });
      Provider.of<Products>(context).fetchProducts().then((value) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _isInit = false;

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('MyShop'),
        actions: [
          PopupMenuButton(
            itemBuilder: (context) {
              return [
                PopupMenuItem(
                  child: Text('only fav'),
                  value: FilterOption.Favoirates,
                ),
                PopupMenuItem(
                  child: Text('Show all'),
                  value: FilterOption.All,
                ),
              ];
            },
            onSelected: (value) {
              setState(() {
                if (value == FilterOption.Favoirates) {
                  _showFav = true;
                } else {
                  _showFav = false;
                }
              });
            },
          ),
          Consumer<Cart>(
            builder: (context, cart, child) {
              return Badge(
                child: child,
                value: cart.itemCount.toString(),
              );
            },
            child: IconButton(
              icon: Icon(Icons.shopping_cart_outlined),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routName);
              },
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Container(
        padding: EdgeInsets.all(10.0),
        child: _isLoading
            ? Center(
                child: CircularProgressIndicator(),
              )
            : ProductGrid(_showFav),
      ),
    );
  }
}
