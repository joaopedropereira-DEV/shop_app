import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/models/product.dart';
import 'package:shop_app/providers/product_list.dart';

class ProductFormPage extends StatefulWidget {
  const ProductFormPage({Key? key}) : super(key: key);

  @override
  State<ProductFormPage> createState() => _ProductFormPageState();
}

class _ProductFormPageState extends State<ProductFormPage> {
  bool _isLoading = false;

  // Adicionar o foco
  final _priceFocus = FocusNode();
  final _descriptionFocus = FocusNode();
  final _imageUrlFocus = FocusNode();

  // Text Controller
  final _imageUrlController = TextEditingController();

  // Propriedades "Form"
  final _formKey = GlobalKey<FormState>();
  final _formData = Map<String, Object>();

  void updateImage() {
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    _imageUrlFocus.addListener(updateImage);
  }

  // Função para atualizar os dados da imagem da url

  bool isValidUrl(String url) {
    bool isValidUrl = Uri.tryParse(url)?.hasAbsolutePath ?? false;

    bool endsWithFileExtension = url.toLowerCase().endsWith('.png') ||
        url.toLowerCase().endsWith('.jpg') ||
        url.toLowerCase().endsWith('.jpeg');

    return isValidUrl && endsWithFileExtension;
  }

  Future<void> _submitForm() async {
    final bool _isValidate = _formKey.currentState?.validate() ?? false;

    if (!_isValidate) {
      return;
    }

    _formKey.currentState?.save();

    setState(() => _isLoading = true);

    try {
      await Provider.of<ProductList>(
        context,
        listen: false,
      ).saveProduct(_formData);

      Navigator.pop(context);
    } catch (error) {
      await showDialog(
        context: context,
        builder: (ctx) => AlertDialog(
          title: Row(
            children: const <Widget>[
              Text("Ocorreu um Erro"),
              Icon(
                Icons.error,
                color: Colors.red,
              ),
            ],
          ),
          content: const Text("Ocorreu um erro em salvar seu produto"),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Ok"),
            )
          ],
        ),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if (_formData.isEmpty) {
      final args = ModalRoute.of(context)?.settings.arguments;

      if (args != null) {
        final product = args as Product;

        _formData['id'] = product.id;
        _formData['name'] = product.title;
        _formData['price'] = product.price;
        _formData['description'] = product.description;
        _formData['urlImage'] = product.imageUrl;

        _imageUrlController.text = product.imageUrl;
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _priceFocus.dispose();
    _descriptionFocus.dispose();
    _imageUrlFocus.removeListener(updateImage);
    _imageUrlFocus.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Formulario de Produto"),
        actions: [
          IconButton(
            onPressed: _submitForm,
            icon: Icon(Icons.save),
          )
        ],
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator(color: Colors.purple))
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: <Widget>[
                    TextFormField(
                      initialValue: _formData['name']?.toString(),
                      decoration: InputDecoration(labelText: "Nome"),
                      textInputAction: TextInputAction.next,
                      onSaved: (name) => _formData['name'] = name ?? "",
                      onFieldSubmitted: (_) {
                        // Mudar para o foco selecionado
                        FocusScope.of(context).requestFocus(_priceFocus);
                      },
                      validator: (_name) {
                        final name = _name ?? "";

                        if (name.trim().isEmpty) {
                          return "Nome é obrigatorio!";
                        }

                        if (name.trim().length < 3) {
                          return "Nome precisa no minimo de 3 letra!";
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['price']?.toString(),
                      decoration: InputDecoration(labelText: "Preço"),
                      textInputAction: TextInputAction.next,
                      focusNode: _priceFocus,
                      onSaved: (price) =>
                          _formData['price'] = double.parse(price ?? '0'),
                      onFieldSubmitted: (_) {
                        // Mudar para o foco selecionado
                        FocusScope.of(context).requestFocus(_descriptionFocus);
                      },
                      // keyboard de numeros (decimais)
                      keyboardType: TextInputType.numberWithOptions(
                        decimal: true,
                      ),
                      validator: (_price) {
                        final price = double.tryParse(_price ?? "");

                        if (price! == 0) {
                          return "O valor do produto não pode ser R\$0";
                        }

                        if (price.isNegative) {
                          return "O valor do produto não pode ser negativo";
                        }

                        if (_price!.isEmpty) {
                          return "O valor do produto é obrigatorio!";
                        }

                        return null;
                      },
                    ),
                    TextFormField(
                      initialValue: _formData['description']?.toString(),
                      decoration: InputDecoration(labelText: "Descrição"),
                      textInputAction: TextInputAction.next,
                      focusNode: _descriptionFocus,
                      keyboardType: TextInputType.multiline,
                      maxLines: 3,
                      onSaved: (description) =>
                          _formData['description'] = description ?? "",
                      onFieldSubmitted: (_) {
                        FocusScope.of(context).requestFocus(_imageUrlFocus);
                      },
                      validator: (_description) {
                        final description = _description ?? "";

                        if (description.trim().isEmpty) {
                          return "Descrição é obrigatorio!";
                        }

                        if (description.trim().length < 20) {
                          return "Descrição precisa no minimo de 20 letra!";
                        }

                        return null;
                      },
                    ),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: <Widget>[
                        Expanded(
                          child: TextFormField(
                            decoration:
                                InputDecoration(labelText: "Url da Imagem"),
                            keyboardType: TextInputType.url,
                            focusNode: _imageUrlFocus,
                            textInputAction: TextInputAction.done,
                            controller: _imageUrlController,
                            onFieldSubmitted: (_) => _submitForm(),
                            onSaved: (imageUrl) =>
                                _formData['urlImage'] = imageUrl ?? "",
                            validator: (_url) {
                              final url = _url ?? "";

                              if (!isValidUrl(url)) {
                                return "Informe uma URL valida";
                              }

                              if (url.isEmpty) {
                                return "Informe a URL";
                              }

                              return null;
                            },
                          ),
                        ),
                        Container(
                          height: 100,
                          width: 100,
                          margin: EdgeInsets.only(top: 10, left: 10),
                          alignment: Alignment.center,
                          decoration: BoxDecoration(
                            border: Border.all(
                              width: 1,
                              color: Colors.grey,
                            ),
                          ),
                          child: _imageUrlController.text.isEmpty
                              ? Text("Informe a url")
                              : Image.network(
                                  _imageUrlController.text,
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
