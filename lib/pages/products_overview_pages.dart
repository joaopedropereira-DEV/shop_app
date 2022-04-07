import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/components/app_drawer.dart';
import 'package:shop_app/components/home_app_bar.dart';
import 'package:shop_app/components/product_grid.dart';
import 'package:shop_app/providers/product_list.dart';

enum FilterOptions { Favorite, All }

class ProductOverviewPage extends StatefulWidget {
  const ProductOverviewPage({Key? key}) : super(key: key);

  @override
  State<ProductOverviewPage> createState() => _ProductOverviewPageState();
}

class _ProductOverviewPageState extends State<ProductOverviewPage> {
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    Provider.of<ProductList>(
      context,
      listen: false,
    ).loadProducts().then((value) {
      setState(() => _isLoading = false);
    });
  }

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<ProductList>(context);

    // bool _showFavoriteOnly = false;

    double height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(
        body: Builder(builder: (context) {
          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5, horizontal: 8),
                child: HomeAppBar(provider: provider),
              ),
              SizedBox(
                height: height * 0.8,
                child: _isLoading
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : const ProductGrid(),
              ),
            ],
          );
        }),
        drawer: AppDrawer(),
      ),
    );
  }
}
