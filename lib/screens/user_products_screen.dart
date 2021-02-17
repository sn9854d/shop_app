import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = './user-products';

  Future<void> _refreseProducts(BuildContext context) async {
    await Provider.of<Products>(context,listen: false).fetchProducts();
  }

  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final products = productsProvider.items;

    return Scaffold(
      appBar: AppBar(
        title: Text('Your Products'),
        actions: [
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              print('clicked');
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: RefreshIndicator(
          onRefresh: () => _refreseProducts(context),
          child: ListView.builder(
            itemCount: products.length,
            itemBuilder: (context, i) {
              return Column(
                children: [
                  UserProduct(
                    title: products[i].title,
                    imageUrl: products[i].imageUrl,
                    productId: products[i].id,
                  ),
                  Divider(),
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}
