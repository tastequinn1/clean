import 'package:get/get.dart';

import '../../../../common/ui.dart';
import '../../../models/product_model.dart';
import '../../../models/store_model.dart';
import '../../../repositories/store_repository.dart';

class StoreController extends GetxController {
  final store = Store().obs;
  final featuredProducts = <Product>[].obs;
  final currentSlide = 0.obs;
  String heroTag = "";
  late StoreRepository _storeRepository;

  StoreController() {
    _storeRepository = new StoreRepository();
  }

  @override
  void onInit() {
    var arguments = Get.arguments as Map<String, dynamic>;
    store.value = arguments['store'] as Store;
    heroTag = arguments['heroTag'] as String;
    super.onInit();
  }

  @override
  void onReady() async {
    await refreshStore();
    super.onReady();
  }

  Future refreshStore({bool showMessage = false}) async {
    await getStore();
    await getFeaturedProducts();
    if (showMessage) {
      Get.showSnackbar(Ui.SuccessSnackBar(message: store.value.name + " " + "page refreshed successfully".tr));
    }
  }

  Future getStore() async {
    try {
      store.value = await _storeRepository.get(store.value.id);
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }

  Future getFeaturedProducts() async {
    try {
      featuredProducts.assignAll(await _storeRepository.getFeaturedProducts(store.value.id, page: 1));
    } catch (e) {
      Get.showSnackbar(Ui.ErrorSnackBar(message: e.toString()));
    }
  }
}
