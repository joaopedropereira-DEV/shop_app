import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/pages/auth/auth_sign_page.dart';
import 'package:shop_app/pages/auth_or_home.dart';
import 'package:shop_app/pages/cart_page.dart';
import 'package:shop_app/pages/orders_page.dart';
import 'package:shop_app/pages/product_detail_page.dart';
import 'package:shop_app/pages/product_form_page.dart';
import 'package:shop_app/pages/product_page.dart';
import 'package:shop_app/pages/products_overview_pages.dart';
import 'package:shop_app/providers/auth.dart';
import 'package:shop_app/providers/cart_item.dart';
import 'package:shop_app/providers/order_list.dart';
import 'package:shop_app/providers/product_list.dart';
import 'package:shop_app/utils/app_routes.dart';

void main() => runApp(const ShopApp());

class ShopApp extends StatelessWidget {
  const ShopApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductList>(
          create: (_) => ProductList('', []),
          update: (context, auth, previous) {
            return ProductList(
              auth.token ?? '',
              previous?.items ?? [],
            );
          },
        ),
        ChangeNotifierProvider(
          create: (_) => CartItem(),
        ),
        ChangeNotifierProvider(
          create: (_) => OrderList(),
        ),
      ],
      child: MaterialApp(
        title: 'Shop App',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primarySwatch: Colors.deepOrange,
          primaryColor: Colors.deepOrange,
        ),
        initialRoute: AppRoutes.AUTH_OR_HOME,
        routes: {
          AppRoutes.AUTH_OR_HOME: (context) => AuthOrHome(),
          AppRoutes.AUTH_SIGNUP: (context) => AuthSignPage(),
          AppRoutes.HOME: (context) => ProductOverviewPage(),
          AppRoutes.PRODUCT_DETAIL: (context) => const ProductDetailPage(),
          AppRoutes.CART: (context) => const CartPage(),
          AppRoutes.ORDERS: (context) => const OrdersPage(),
          AppRoutes.PRODUCT: (context) => const ProductPage(),
          AppRoutes.PRODUCT_FORM: (context) => const ProductFormPage(),
        },
      ),
    );
  }
}
