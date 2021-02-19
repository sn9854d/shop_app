import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/provider/auth.dart';
import 'package:shop/provider/cart.dart';
import 'package:shop/provider/orders.dart';
import 'package:shop/provider/products.dart';
import 'package:shop/screens/auth_screen.dart';
import 'package:shop/screens/cart_screen.dart';
import 'package:shop/screens/edit_product_screen.dart';
import 'package:shop/screens/order_screen.dart';
import 'package:shop/screens/product_detail_screen.dart';
import 'package:shop/screens/product_overview_screen.dart';
import 'package:shop/screens/splash_screen.dart';
import 'package:shop/screens/user_products_screen.dart';

void main(List<String> args) {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
        providers: [
          ChangeNotifierProvider<Auth>(
            create: (context) => Auth(),
          ),
          ChangeNotifierProxyProvider<Auth, Products>(
            create: (context) => Products(),
            update: (context, auth, previousProducts) => previousProducts
              ..setValue(auth.token, auth.userId, previousProducts.items),
          ),
          // ChangeNotifierProvider<Products>(
          //   create: (context) => Products(),
          // ),
          ChangeNotifierProvider<Cart>(
            create: (context) => Cart(),
          ),
          ChangeNotifierProxyProvider<Auth, Orders>(
              create: (context) => Orders(),
              update: (context, auth, previousOrders) => previousOrders
                ..setValue(auth.token, auth.userId, previousOrders.orders)),
          // ChangeNotifierProvider<Orders>(
          //   create: (context) => Orders(),
          // ),
        ],
        child: Consumer<Auth>(
          builder: (context, auth, _) {
            return MaterialApp(
              theme: ThemeData(
                primarySwatch: Colors.purple,
                accentColor: Colors.deepOrange,
                fontFamily: 'Lato',
              ),
              debugShowCheckedModeBanner: false,
              home: auth.isAuth
                  ? ProductOverViewScreen()
                  : FutureBuilder(
                      future: auth.tryAutoLogin(),
                      builder: (context, snapshot) =>
                          snapshot.connectionState == ConnectionState.waiting
                              ? SplashScreen()
                              : AuthScreen()),
              routes: {
                ProductDetailScreen.routName: (context) =>
                    ProductDetailScreen(),
                CartScreen.routName: (context) => CartScreen(),
                OrderScreen.routeName: (context) => OrderScreen(),
                UserProductsScreen.routeName: (context) => UserProductsScreen(),
                EditProductScreen.routeName: (context) => EditProductScreen(),
              },
            );
          },
        ));
  }
}
