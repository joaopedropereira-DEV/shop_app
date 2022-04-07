import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/product_grid_item.dart';

import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/product_list.dart';

class ProductGrid extends StatelessWidget {
  const ProductGrid({
    Key? key,
    //required this.showFavoriteOnly,
  }) : super(key: key);

  // final bool showFavoriteOnly;

  @override
  Widget build(BuildContext context) {
    // Provider
    final provider = Provider.of<ProductList>(context);
    final List<Product> loadedProducts = provider.items;

    return GridView.builder(
      padding: const EdgeInsets.all(10),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.70,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: loadedProducts.length,
      itemBuilder: (context, index) => ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: ProductGridItem(),
      ),
    );
  }
}
