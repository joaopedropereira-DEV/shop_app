import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/app_drawer.dart';
import 'package:shop_app/components/order_item.dart';
import 'package:shop_app/providers/order_list.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({Key? key}) : super(key: key);

  @override
  State<OrdersPage> createState() => _OrdersPageState();
}

class _OrdersPageState extends State<OrdersPage> {
  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<OrderList>(context, listen: false);

    return Scaffold(
      appBar: AppBar(
        title: Text("Meus Pedidos"),
      ),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: provider.loadOrders(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          } else {
            return RefreshIndicator(
              onRefresh: () => provider.loadOrders(),
              child: Consumer<OrderList>(
                builder: (context, orders, child) => ListView.builder(
                  itemCount: orders.itemCount,
                  itemBuilder: (context, index) =>
                      OrderItem(order: orders.items[index]),
                ),
              ),
            );
          }
        },
      ),
    );
  }
}
