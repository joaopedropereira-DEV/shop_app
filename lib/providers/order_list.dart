import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/order.dart';
import 'package:shop_app/providers/cart_item.dart';
import 'package:shop_app/utils/constants.dart';

class OrderList with ChangeNotifier {
  final String _token;
  String _userId;
  List<Order> _items = [];

  OrderList([
    this._items = const [],
    this._userId = '',
    this._token = '',
  ]);

  List<Order> get items {
    return [..._items];
  }

  int get itemCount {
    return _items.length;
  }

  // Adicionar Pedidos (post)
  Future<void> addOrder(CartItem cartItem) async {
    final date = DateTime.now();

    final response = await http.post(
      Uri.parse("${Constants.urlOrder}/$_userId.json?auth=$_token"),
      body: jsonEncode({
        'total': cartItem.totalAmount,
        'date': date.toIso8601String(),
        'products': cartItem.items.values
            .map((cart) => {
                  'id': cart.id,
                  'productId': cart.productId,
                  'title': cart.title,
                  'quatity': cart.quatity,
                  'price': cart.price,
                })
            .toList()
      }),
    );

    final id = jsonDecode(response.body)["name"];

    _items.insert(
      0,
      Order(
        id: id,
        total: cartItem.totalAmount,
        products: cartItem.items.values.toList(),
        date: date,
      ),
    );
    notifyListeners();
  }

  // Carregar Pedidos (get)
  Future<void> loadOrders() async {
    List<Order> items = [];

    final response = await http.get(
      Uri.parse("${Constants.urlOrder}/$_userId.json?auth=$_token"),
    );

    if (response.body == "null") return;

    Map<String, dynamic> data = jsonDecode(response.body);

    data.forEach((orderId, orderData) {
      items.add(
        Order(
          id: orderId,
          total: orderData['total'],
          products: (orderData['products'] as List<dynamic>).map((item) {
            return Cart(
              id: item['id'],
              productId: item['productId'],
              title: item['title'],
              quatity: item['quatity'],
              price: item['price'],
            );
          }).toList(),
          date: DateTime.parse(orderData['date']),
        ),
      );
    });

    // Lista de pedidos recentes na ordem
    _items = items.reversed.toList();
    notifyListeners();
  }
}
