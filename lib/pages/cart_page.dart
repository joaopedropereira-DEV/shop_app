import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/cart_item_widget.dart';
import 'package:shop_app/providers/cart_item.dart';
import 'package:shop_app/providers/order_list.dart';

class CartPage extends StatelessWidget {
  const CartPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final CartItem cartItem = Provider.of(context);
    final itemsCount = cartItem.items.values.toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Carrinho"),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: const EdgeInsets.all(25),
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    "Total",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 15,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Chip(
                    backgroundColor: Colors.purple,
                    label: Text(
                      "R\$${cartItem.totalAmount.toStringAsFixed(2)}",
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                  const Spacer(),
                  CartButton(cartItem: cartItem),
                ],
              ),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: itemsCount.length,
              itemBuilder: (context, index) => CartItemWidget(
                cart: itemsCount[index],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class CartButton extends StatefulWidget {
  const CartButton({
    Key? key,
    required this.cartItem,
  }) : super(key: key);

  final CartItem cartItem;

  @override
  State<CartButton> createState() => _CartButtonState();
}

class _CartButtonState extends State<CartButton> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: widget.cartItem.itemCount == 0
          ? null
          : () async {
              setState(() => isLoading = true);

              await Provider.of<OrderList>(
                context,
                listen: false,
              ).addOrder(widget.cartItem);

              widget.cartItem.clear();

              setState(() => isLoading = false);
            },
      child: const Text(
        "COMPRAR",
        style: TextStyle(
          color: Colors.purple,
          fontSize: 15,
        ),
      ),
    );
  }
}
