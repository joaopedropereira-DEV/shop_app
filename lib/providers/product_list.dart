import 'dart:convert';
import 'dart:math';

import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:shop_app/Error/http_exceptions.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/utils/constants.dart';

class ProductList with ChangeNotifier {
  // ==== Atributos e variaveis ====

  final List<Product> _items = [];

  bool _showFavoriteOnly = false;

  List<Product> get items {
    if (_showFavoriteOnly) {
      return _items.where((prod) => prod.isFavorite).toList();
    }
    return [..._items];
  }

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

  // Atualizar Favorito (patch)
  Future<void> patchFavorite(Product product) async {
    int index = _items.indexWhere((prod) => prod.id == product.id);

    if (index >= 0) {
      bool isFavorite = product.isFavorite = !product.isFavorite;
      notifyListeners();

      final response = await http.patch(
        Uri.parse("${Constants.urlProduct}/${product.id}.json"),
        body: jsonEncode({
          "isFavorite": isFavorite,
        }),
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

    final response = await http.get(Uri.parse("${Constants.urlProduct}.json"));

    if (response.body == "null") return;

    Map<String, dynamic> data = jsonDecode(response.body);

    print(data);

    data.forEach((productId, productData) {
      _items.add(
        Product(
          id: productId,
          title: productData["title"],
          description: productData["description"],
          price: productData["price"],
          imageUrl: productData["imageUrl"],
          isFavorite: productData["isFavorite"],
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
        Uri.parse("${Constants.urlProduct}/${product.id}.json"),
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
        Uri.parse("${Constants.urlProduct}/${product.id}.json"),
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
      Uri.parse("${Constants.urlProduct}.json"),
      body: jsonEncode(
        {
          "title": product.title,
          "description": product.description,
          "price": product.price,
          "imageUrl": product.imageUrl,
          "isFavorite": product.isFavorite,
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
