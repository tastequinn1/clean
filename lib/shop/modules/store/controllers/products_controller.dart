import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/product_model.dart';
import '../../../models/store_model.dart';
import '../../../repositories/store_repository.dart';

enum CategoryFilter { ALL, AVAILABILITY, FEATURED, POPULAR }

class ProductsController extends GetxController {
  final store = new Store().obs;
  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final products = <Product>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  late StoreRepository _storeRepository;
  ScrollController scrollController = ScrollController();

  ProductsController() {
    _storeRepository = new StoreRepository();
  }

  @override
  Future<void> onInit() async {
    store.value = Get.arguments as Store;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadProductsOfCategory(filter: selected.value);
      }
    });
    await refreshProducts();
    super.onInit();
  }

  @override
  void onClose() {
    scrollController.dispose();
  }

  Future refreshProducts({bool? showMessage}) async {
    toggleSelected(selected.value);
    await loadProductsOfCategory(filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of products refreshed successfully".tr));
    }
  }

  bool isSelected(CategoryFilter filter) => selected == filter;

  void toggleSelected(CategoryFilter filter) {
    this.products.clear();
    this.page.value = 0;
    if (isSelected(filter)) {
      selected.value = CategoryFilter.ALL;
    } else {
      selected.value = filter;
    }
  }

  Future loadProductsOfCategory({CategoryFilter? filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<Product> _products = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _products = await _storeRepository.getProducts(store.value.id, page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _products = await _storeRepository.getFeaturedProducts(store.value.id, page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _products = await _storeRepository.getPopularProducts(store.value.id, page: this.page.value);
          break;
/*        case CategoryFilter.RATING:
          _products = await _storeRepository.getMostRatedProducts(store.value.id, page: this.page.value);
          break;*/
        case CategoryFilter.AVAILABILITY:
          _products = await _storeRepository.getAvailableProducts(store.value.id, page: this.page.value);
          break;
        default:
          _products = await _storeRepository.getProducts(store.value.id, page: this.page.value);
      }
      if (_products.isNotEmpty) {
        this.products.addAll(_products);
      } else {
        isDone.value = true;
      }
    } catch (e) {
      this.isDone.value = true;
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    } finally {
      isLoading.value = false;
    }
  }
}
