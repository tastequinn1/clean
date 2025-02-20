import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/category_model.dart';
import '../../../models/product_model.dart';
import '../../../repositories/product_repository.dart';

enum CategoryFilter { ALL, AVAILABILITY, FEATURED, POPULAR }

class CategoryController extends GetxController {
  final category = new Category().obs;
  final selected = Rx<CategoryFilter>(CategoryFilter.ALL);
  final products = <Product>[].obs;
  final page = 0.obs;
  final isLoading = true.obs;
  final isDone = false.obs;
  late ProductRepository _productRepository;
  ScrollController scrollController = ScrollController();

  CategoryController() {
    _productRepository = new ProductRepository();
  }

  @override
  Future<void> onInit() async {
    category.value = Get.arguments as Category;
    scrollController.addListener(() {
      if (scrollController.position.pixels == scrollController.position.maxScrollExtent && !isDone.value) {
        loadProductsOfCategory(category.value.id, filter: selected.value);
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
    await loadProductsOfCategory(category.value.id, filter: selected.value);
    if (showMessage == true) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: "List of services refreshed successfully".tr));
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

  Future loadProductsOfCategory(String? categoryId, {CategoryFilter? filter}) async {
    try {
      isLoading.value = true;
      isDone.value = false;
      this.page.value++;
      List<Product> _products = [];
      switch (filter) {
        case CategoryFilter.ALL:
          _products = await _productRepository.getAllWithPagination(categoryId, page: this.page.value);
          break;
        case CategoryFilter.FEATURED:
          _products = await _productRepository.getFeatured(categoryId, page: this.page.value);
          break;
        case CategoryFilter.POPULAR:
          _products = await _productRepository.getPopular(categoryId, page: this.page.value);
          break;
        // case CategoryFilter.RATING:
        //   _products = await _productRepository.getMostRated(categoryId, page: this.page.value);
        //   break;
        case CategoryFilter.AVAILABILITY:
          _products = await _productRepository.getAvailable(categoryId, page: this.page.value);
          break;
        default:
          _products = await _productRepository.getAllWithPagination(categoryId, page: this.page.value);
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
