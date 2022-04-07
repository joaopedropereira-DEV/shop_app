import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:shop_app/models/cart.dart';
import 'package:shop_app/models/product.dart';

class CartItem with ChangeNotifier {
  Map<String, Cart> _items = {};

  Map<String, Cart> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    double total = 0.0;
    _items.forEach((key, cartItem) {
      total += cartItem.price * cartItem.quatity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (existingItem) => Cart(
          id: existingItem.id,
          price: existingItem.price,
          productId: existingItem.productId,
          quatity: existingItem.quatity + 1,
          title: existingItem.title,
        ),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => Cart(
          id: Random().nextDouble().toString(),
          productId: product.id,
          title: product.title,
          quatity: 1,
          price: product.price,
        ),
      );
    }
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (!_items.containsKey(productId)) {
      return;
    }

    if (_items[productId]?.quatity == 1) {
      _items.remove(productId);
    } else {
      _items.update(
        productId,
        (existingItem) => Cart(
          id: existingItem.id,
          price: existingItem.price,
          productId: existingItem.productId,
          quatity: existingItem.quatity - 1,
          title: existingItem.title,
        ),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
