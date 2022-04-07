import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/Error/http_exceptions.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/product_list.dart';
import 'package:shop_app/utils/app_routes.dart';

class ProductItem extends StatelessWidget {
  const ProductItem({Key? key, required this.product}) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context, listen: false);
    final msg = ScaffoldMessenger.of(context);
    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),
      title: Text(product.title),
      trailing: Container(
        width: 100,
        child: Row(
          children: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(
                  AppRoutes.PRODUCT_FORM,
                  arguments: product,
                );
              },
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
            ),
            IconButton(
              onPressed: () => showDialog(
                context: context,
                builder: (ctx) => AlertDialog(
                  title: Text("Você tem certeza?"),
                  content: Text("Gostaria de remover esse produto?"),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () => Navigator.of(context).pop(),
                      child: Text('Não'),
                    ),
                    TextButton(
                      onPressed: () {
                        provider.removeProduct(product);
                        Navigator.of(context).pop();
                      },
                      child: Text('Sim'),
                    ),
                  ],
                ),
              ).then((value) async {
                if (value ?? false) {
                  try {
                    await Provider.of<ProductList>(
                      context,
                      listen: false,
                    ).removeProduct(product);
                  } on HttpExceptions catch (error) {
                    msg.showSnackBar(
                      SnackBar(
                        content: Text(error.toString()),
                      ),
                    );
                  }
                }
              }),
              icon: Icon(
                Icons.delete,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
