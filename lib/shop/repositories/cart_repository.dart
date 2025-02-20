import 'package:get/get.dart';

import '../models/cart_model.dart';
import '../providers/shop_laravel_provider.dart';

class CartRepository {
  late ShopLaravelApiClient _shopLaravelApiClient;

  CartRepository() {
    this._shopLaravelApiClient = Get.find<ShopLaravelApiClient>();
  }

  Future<List<Cart>> getCart() {
    return _shopLaravelApiClient.getCart();
  }

  Future<Cart> addToCart(Cart cart) {
    return _shopLaravelApiClient.addToCart(cart);
  }

  Future<Cart> removeFromCart(Cart cart) {
    return _shopLaravelApiClient.removeFromCart(cart);
  }

  Future<Cart> updateCart(Cart cart) {
    return _shopLaravelApiClient.updateCart(cart);
  }
}
