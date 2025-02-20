import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:get/get.dart';

import '../../../providers/shop_laravel_provider.dart';
import '../controllers/category_controller.dart';
import 'products_empty_list_widget.dart';
import 'products_list_item_widget.dart';
import 'products_list_loader_widget.dart';

class ProductsListWidget extends GetView<CategoryController> {
  ProductsListWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (Get.find<ShopLaravelApiClient>().isLoading(tasks: [
            'getAllProductsWithPagination',
            'getFeaturedProducts',
            'getPopularProducts',
            'getMostRatedProducts',
            'getAvailableProducts',
          ]) &&
          controller.page == 1) {
        return ProductsListLoaderWidget();
      } else if (controller.products.isEmpty) {
        return ProductsEmptyListWidget();
      } else {
        return MasonryGridView.count(
          primary: false,
          shrinkWrap: true,
          crossAxisCount: MediaQuery.of(context).orientation == Orientation.portrait ? 2 : 4,
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
          itemCount: controller.products.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.products.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _product = controller.products.elementAt(index);
              return ProductsListItemWidget(product: _product);
            }
          }),
          mainAxisSpacing: 15.0,
          crossAxisSpacing: 15.0,
        );
/*        return ListView.builder(
          padding: EdgeInsets.only(bottom: 10, top: 10),
          primary: false,
          shrinkWrap: true,
          itemCount: controller.products.length + 1,
          itemBuilder: ((_, index) {
            if (index == controller.products.length) {
              return Obx(() {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: new Center(
                    child: new Opacity(
                      opacity: controller.isLoading.value ? 1 : 0,
                      child: new CircularProgressIndicator(),
                    ),
                  ),
                );
              });
            } else {
              var _product = controller.products.elementAt(index);
              return ProductsListItemWidget(product: _product);
            }
          }),
        );*/
      }
    });
  }
}
