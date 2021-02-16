import 'package:flutter/material.dart';
import 'package:shop/provider/product.dart';
import 'package:shop/provider/products.dart';
import 'package:provider/provider.dart';
import 'package:shop/widgets/product_item.dart';

class ProductGrid extends StatelessWidget {
  final bool showFav;
  ProductGrid(this.showFav);
  @override
  Widget build(BuildContext context) {
    final productsProvider = Provider.of<Products>(context);
    final products =
        showFav ? productsProvider.favoirateItems : productsProvider.items;
    return GridView.builder(
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider<Product>.value(
          value: products[index],
          // create: (context) => products[index],
          child: ProductItem(),
        );
      },
    );
  }
}
