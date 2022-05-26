import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Error/http_exceptions.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/utils/constants.dart';

class ProductList with ChangeNotifier {
  // ==== Atributos e variaveis ====
  final String _token;
  final String _userId;
  List<Product> _items = [];

  bool _showFavoriteOnly = false;

  List<Product> get items {
    if (_showFavoriteOnly) {
      return _items.where((prod) => prod.isFavorite).toList();
    }
    return [..._items];
  }

  // "this._items" -> para não perder os items, qunado o token for alterado
  ProductList([
    this._token = '',
    this._userId = '',
    this._items = const [],
  ]);

  // ==== Metodos ====

  int get itemsCount {
    return _items.length;
  }

  void showFavoriteOnly() {
    _showFavoriteOnly = true;
    notifyListeners();
  }

  void showAll() {
    _showFavoriteOnly = false;
    notifyListeners();
  }

  // Atualizar Favorito (put)
  Future<void> patchFavorite(Product product, String userId) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      bool isFavorite = product.isFavorite = !product.isFavorite;
      notifyListeners();

      final response = await http.put(
        Uri.parse(
            "${Constants.urlUserFavorite}/$userId/${product.id}.json?auth=$_token"),
        body: jsonEncode(isFavorite),
      );

      if (response.statusCode >= 400) {
        isFavorite = product.isFavorite = !product.isFavorite;
      }

      _items[index].isFavorite = isFavorite;
      notifyListeners();
    }
  }

  // Carregar Produto (get)
  Future<void> loadProducts() async {
    _items.clear();

    // Resposta equivalente aos Products
    final response = await http.get(
      Uri.parse("${Constants.urlProduct}.json?auth=$_token"),
    );

    if (response.body == "null") return;

    // Resposta equivalente aos Favorite Products
    final favResponse = await http.put(
      Uri.parse("${Constants.urlUserFavorite}/$_userId.json?auth=$_token"),
    );

    Map<String, dynamic> favData =
        favResponse == 'null' ? {} : jsonDecode(favResponse.body);

    Map<String, dynamic> prodData = jsonDecode(response.body);

    prodData.forEach((productId, productData) {
      final isFavorite = favData[productId] ?? false;
      _items.add(
        Product(
          id: productId,
          title: productData["title"],
          description: productData["description"],
          price: productData["price"],
          imageUrl: productData["imageUrl"],
          isFavorite: isFavorite,
        ),
      );
    });
    notifyListeners();
  }

  // Salvar Produto
  Future<void> saveProduct(Map<String, Object> data) {
    bool hasId = data["id"] != null;

    final product = Product(
      id: hasId ? data["id"] as String : Random().nextDouble().toString(),
      title: data['name'] as String,
      description: data['description'] as String,
      price: data['price'] as double,
      imageUrl: data['urlImage'] as String,
    );

    if (hasId) {
      return updateProduct(product);
    } else {
      return addProduct(product);
    }
  }

  // Atualizar Produto (patch)
  Future<void> updateProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      await http.patch(
        Uri.parse("${Constants.urlProduct}/${product.id}.json?auth=$_token"),
        body: jsonEncode(
          {
            "title": product.title,
            "description": product.description,
            "price": product.price,
            "imageUrl": product.imageUrl,
          },
        ),
      );

      _items[index] = product;
      notifyListeners();
    }
  }

  // Remover Produto (delete)
  Future<void> removeProduct(Product product) async {
    int index = _items.indexWhere((p) => p.id == product.id);

    if (index >= 0) {
      final product = _items[index];
      _items.remove(product);
      notifyListeners();

      final response = await http.delete(
        Uri.parse("${Constants.urlProduct}/${product.id}.json?auth=$_token"),
      );

      if (response.statusCode >= 400) {
        _items.insert(index, product);

        notifyListeners();

        throw HttpExceptions(
          message: "Não foi possível excluir o produto",
          statusCode: response.statusCode,
        );
      }
    }
  }

  // Adicionar Produto (post)
  Future<void> addProduct(Product product) async {
    final response = await http.post(
      Uri.parse("${Constants.urlProduct}.json?auth=$_token"),
      body: jsonEncode(
        {
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
        },
      ),
    );

    final id = jsonDecode(response.body)["name"];
    _items.add(
      Product(
        id: id,
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
      ),
    );
    notifyListeners();
  }
}
