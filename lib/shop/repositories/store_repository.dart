import 'package:get/get.dart';

import '../../app/models/user_model.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';
import '../providers/shop_laravel_provider.dart';

class StoreRepository {
  late ShopLaravelApiClient _laravelApiClient;

  StoreRepository() {
    this._laravelApiClient = Get.find<ShopLaravelApiClient>();
  }

  Future<Store> get(String? storeId) {
    return _laravelApiClient.getStore(storeId);
  }

  Future<List<Product>> getProducts(String? storeId, {int page = 1}) {
    return _laravelApiClient.getStoreProducts(storeId, page);
  }

  Future<List<User>> getEmployees(String storeId) {
    return _laravelApiClient.getStoreEmployees(storeId);
  }

  Future<List<Product>> getPopularProducts(String? storeId, {int page = 1}) {
    return _laravelApiClient.getStorePopularProducts(storeId, page);
  }

  Future<List<Product>> getMostRatedProducts(String? storeId, {int page = 1}) {
    return _laravelApiClient.getStoreMostRatedProducts(storeId, page);
  }

  Future<List<Product>> getAvailableProducts(String? storeId, {int page = 1}) {
    return _laravelApiClient.getStoreAvailableProducts(storeId, page);
  }

  Future<List<Product>> getFeaturedProducts(String? storeId, {int page = 1}) {
    return _laravelApiClient.getStoreFeaturedProducts(storeId, page);
  }
}
