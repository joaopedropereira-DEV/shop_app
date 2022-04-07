import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/badge.dart';
import 'package:shop_app/pages/products_overview_pages.dart';
import 'package:shop_app/providers/cart_item.dart';
import 'package:shop_app/providers/product_list.dart';
import 'package:shop_app/utils/app_routes.dart';

class HomeAppBar extends StatelessWidget {
  const HomeAppBar({
    Key? key,
    required this.provider,
  }) : super(key: key);

  final ProductList provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        InkWell(
          onTap: () {
            Scaffold.of(context).openDrawer();
          },
          borderRadius: BorderRadius.circular(30),
          child: Container(
            padding: EdgeInsets.all(5),
            decoration: BoxDecoration(
              color: Colors.grey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  padding: EdgeInsets.all(11.5),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.menu_rounded,
                    color: Colors.grey,
                    size: 23,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 7),
                  child: Text(
                    "Menu",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        Container(
          padding: EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.grey.withOpacity(0.2),
            borderRadius: BorderRadius.circular(30),
          ),
          child: Row(
            children: <Widget>[
              Consumer<CartItem>(
                builder: ((context, cartItem, child) => Badge(
                      value: cartItem.itemCount.toString(),
                      child: child!,
                    )),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).pushNamed(AppRoutes.CART);
                  },
                  borderRadius: BorderRadius.circular(30),
                  child: Container(
                    padding: EdgeInsets.all(11.5),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.shopping_bag,
                      color: Colors.grey,
                      size: 23,
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 12,
              ),
              Container(
                padding: EdgeInsets.all(0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: PopupMenuButton(
                  icon: const Icon(
                    Icons.filter_alt,
                    color: Colors.grey,
                  ),
                  onSelected: (FilterOptions _selectedValue) {
                    if (_selectedValue == FilterOptions.Favorite) {
                      provider.showFavoriteOnly();
                    } else {
                      provider.showAll();
                    }
                  },
                  itemBuilder: (context) => [
                    const PopupMenuItem(
                      child: Text("Somente Favoritos"),
                      value: FilterOptions.Favorite,
                    ),
                    const PopupMenuItem(
                      child: Text("Todos"),
                      value: FilterOptions.All,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
