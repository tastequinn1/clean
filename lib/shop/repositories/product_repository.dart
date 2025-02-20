import 'package:get/get.dart';

import '../models/option_group_model.dart';
import '../models/product_model.dart';
import '../providers/shop_laravel_provider.dart';

class ProductRepository {
  late ShopLaravelApiClient _laravelApiClient;

  ProductRepository() {
    this._laravelApiClient = Get.find<ShopLaravelApiClient>();
  }

  Future<List<Product>> getAllWithPagination(String? categoryId, {int page = 1}) {
    return _laravelApiClient.getAllProductsWithPagination(categoryId, page);
  }

  Future<List<Product>> search(String? keywords, List<String> categories, {int page = 1}) {
    return _laravelApiClient.searchProducts(keywords, categories, page);
  }

  Future<List<Product>> getRecommended() {
    return _laravelApiClient.getRecommendedProducts();
  }

  Future<List<Product>> getFeatured(String? categoryId, {int page = 1}) {
    return _laravelApiClient.getFeaturedProducts(categoryId, page);
  }

  Future<List<Product>> getPopular(String? categoryId, {int page = 1}) {
    return _laravelApiClient.getPopularProducts(categoryId, page);
  }

  Future<List<Product>> getMostRated(String? categoryId, {int page = 1}) {
    return _laravelApiClient.getMostRatedProducts(categoryId, page);
  }

  Future<List<Product>> getAvailable(String? categoryId, {int page = 1}) {
    return _laravelApiClient.getAvailableProducts(categoryId, page);
  }

  Future<Product> get(String? id) {
    return _laravelApiClient.getProduct(id);
  }

  Future<List<OptionGroup>> getOptionGroups(String? productId) {
    return _laravelApiClient.getProductOptionGroups(productId);
  }
}
