import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/user_product.dart';

class UserProductsScreen extends StatelessWidget {
  static const routeName = './user-products';

  Future<void> _refreseProducts(BuildContext context) async {
    await Provider.of<Products>(context, listen: false).fetchProducts(true);
  }

  @override
  Widget build(BuildContext context) {
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
        body: FutureBuilder(
          future: _refreseProducts(context),
          builder: (context, snapshot) => snapshot.connectionState ==
                  ConnectionState.waiting
              ? Center(
                  child: CircularProgressIndicator(),
                )
              : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RefreshIndicator(
                    onRefresh: () => _refreseProducts(context),
                    child: Consumer<Products>(
                      builder: (context, products, child) => ListView.builder(
                        itemCount: products.items.length,
                        itemBuilder: (context, i) {
                          return Column(
                            children: [
                              UserProduct(
                                title: products.items[i].title,
                                imageUrl: products.items[i].imageUrl,
                                productId: products.items[i].id,
                              ),
                              Divider(),
                            ],
                          );
                        },
                      ),
                    ),
                  ),
                ),
        ));
  }
}
