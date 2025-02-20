import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/option_group_model.dart';
import '../../../models/option_model.dart';
import '../../../models/product_model.dart';
import '../../../repositories/product_repository.dart';

class ProductController extends GetxController {
  final product = Product().obs;
  final optionGroups = <OptionGroup>[].obs;
  final currentSlide = 0.obs;
  final Rx<int> quantity = 1.obs;
  final heroTag = ''.obs;
  late ProductRepository _productRepository;

  ProductController() {
    _productRepository = new ProductRepository();
  }

  @override
  void onInit() async {
    var arguments = Get.arguments as Map<String, dynamic>;
    product.value = arguments['product'] as Product;
    heroTag.value = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshProduct();
    super.onReady();
  }

  Future refreshProduct({bool showMessage = false}) async {
    await getProduct();
    await getOptionGroups();
    quantity.value = 1;
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: product.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getProduct() async {
    try {
      product.value = await _productRepository.get(product.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getOptionGroups() async {
    try {
      var _optionGroups = await _productRepository.getOptionGroups(product.value.id);
      optionGroups.assignAll(_optionGroups.map((element) {
        element.options.removeWhere((option) => option.productId != product.value.id);
        return element;
      }));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  void selectOption(OptionGroup optionGroup, Option option) {
    optionGroup.options.forEach((e) {
      if (!optionGroup.allowMultiple && option != e) {
        e.checked.value = false;
      }
    });
    option.checked.value = !option.checked.value;
  }

  List<Option> getCheckedOptions() {
    if (optionGroups.isNotEmpty) {
      return optionGroups.map((element) => element.options).expand((element) => element).toList().where((option) => option.checked.value).toList();
    }
    return [];
  }

  TextStyle getTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.bodyMedium!.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.bodyMedium!;
  }

  TextStyle getSubTitleTheme(Option option) {
    if (option.checked.value) {
      return Get.textTheme.bodySmall!.merge(TextStyle(color: Get.theme.colorScheme.secondary));
    }
    return Get.textTheme.bodySmall!;
  }

  Color? getColor(Option option) {
    if (option.checked.value) {
      return Get.theme.colorScheme.secondary.withOpacity(0.1);
    }
    return null;
  }

  void incrementQuantity() {
    quantity.value < 1000 ? quantity.value++ : null;
  }

  void decrementQuantity() {
    quantity.value > 1 ? quantity.value-- : null;
  }
}
