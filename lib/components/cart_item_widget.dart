import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/providers/cart_item.dart';

class CartItemWidget extends StatelessWidget {
  const CartItemWidget({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(cart.id),
      direction: DismissDirection.endToStart,
      background: Container(
        color: Theme.of(context).errorColor,
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(right: 20),
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: const Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
      ),
      confirmDismiss: (_) {
        // Mostrar o Dioalog
        return showDialog<bool>(
          context: context,
          builder: (ctx) => AlertDialog(
            title: Text("Tem Certeza?"),
            content: Text("Quer remover o item do carrinho?"),
            actions: [
              TextButton(
                onPressed: () {
                  // Não exclui o item
                  Navigator.of(context).pop(false);
                },
                child: Text("Não"),
              ),
              TextButton(
                onPressed: () {
                  // Exclui o item
                  Navigator.of(context).pop(true);
                },
                child: Text("Sim"),
              ),
            ],
          ),
        );
      },
      onDismissed: (direction) {
        Provider.of<CartItem>(
          context,
          listen: false,
        ).removeItem(cart.productId);
      },
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 4),
        child: ListTile(
          leading: CircleAvatar(
            child: Padding(
              padding: const EdgeInsets.all(5),
              child: FittedBox(
                child: Text("${cart.price}"),
              ),
            ),
          ),
          title: Text(cart.title),
          subtitle: Text("Total: R\$${cart.price * cart.quatity}"),
          trailing: Text("${cart.quatity}x"),
        ),
      ),
    );
  }
}
