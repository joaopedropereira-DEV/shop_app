import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/cart_item.dart';
import 'package:shop_app/providers/product_list.dart';
import 'package:shop_app/utils/app_routes.dart';

import '../providers/auth.dart';

class ProductGridItem extends StatelessWidget {
  const ProductGridItem({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context);
    final cart = Provider.of<CartItem>(context);
    final auth = Provider.of<Auth>(context);

    final messenger = ScaffoldMessenger.of(context);

    return Container(
      decoration: BoxDecoration(
        color: Colors.transparent,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          InkWell(
            onTap: () {
              Navigator.of(context).pushNamed(
                AppRoutes.PRODUCT_DETAIL,
                arguments: product,
              );
            },
            child: Container(
              height: 210,
              width: double.infinity,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(25),
              ),
              child: Stack(
                children: <Widget>[
                  Center(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(25),
                      child: Image.network(
                        product.imageUrl,
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    top: 10,
                    right: 10,
                    child: InkWell(
                      onTap: () async {
                        await Provider.of<ProductList>(
                          context,
                          listen: false,
                        ).patchFavorite(product, auth.userId ?? "");

                        if (product.isFavorite == true) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                  "${product.title} adicionado como favorito"),
                            ),
                          );
                        } else if (product.isFavorite == false) {
                          messenger.showSnackBar(
                            SnackBar(
                              content: Text(
                                  "${product.title} desmarcado como favorito"),
                            ),
                          );
                        }
                      },
                      child: Container(
                        padding: EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: Colors.grey.withOpacity(0.3),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(
                          product.isFavorite
                              ? Icons.favorite
                              : Icons.favorite_border_rounded,
                          color: Colors.white.withOpacity(0.6),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      product.title,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 17,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    Text(
                      "R\$${product.price}",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              ),
              GestureDetector(
                onTap: () {
                  // Esconder o SnackBar anterior
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();

                  // Mostrar e acessar o SnackBar
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("Produto foi adicionado"),
                      duration: Duration(seconds: 2),
                      action: SnackBarAction(
                        label: "Desfazer",
                        onPressed: () {
                          cart.removeSingleItem(product.id);
                        },
                      ),
                    ),
                  );
                  cart.addItem(product);
                },
                child: Icon(Icons.shopping_cart),
              ),
              SizedBox(width: 0),
            ],
          ),
        ],
      ),
    );
  }
}
