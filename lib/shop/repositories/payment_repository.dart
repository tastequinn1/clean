import 'package:get/get.dart';

import '../../app/models/payment_method_model.dart';
import '../../app/models/wallet_model.dart';
import '../../app/providers/laravel_provider.dart';
import '../models/order_model.dart';
import '../providers/shop_laravel_provider.dart';

class PaymentRepository {
  late ShopLaravelApiClient _shopLaravelApiClient;
  late LaravelApiClient _laravelApiClient;

  PaymentRepository() {
    _shopLaravelApiClient = Get.find<ShopLaravelApiClient>();
    _laravelApiClient = Get.find<LaravelApiClient>();
  }

  Future<List<PaymentMethod>> getMethods() {
    return _shopLaravelApiClient.getPaymentMethods();
  }

  Future<List<Wallet>> getWallets() {
    return _laravelApiClient.getWallets();
  }

  Future<bool> create(List<Order> orders) {
    return _shopLaravelApiClient.createPayment(orders);
  }

  Future<bool> createWalletPayment(List<Order> orders, Wallet wallet) {
    return _shopLaravelApiClient.createWalletPayment(orders, wallet);
  }

  Uri getPayPalUrl(List<Order> orders) {
    return _shopLaravelApiClient.getPayPalUrl(orders);
  }

  Uri getRazorPayUrl(List<Order> orders) {
    return _shopLaravelApiClient.getRazorPayUrl(orders);
  }

  Uri getStripeUrl(List<Order> orders) {
    return _shopLaravelApiClient.getStripeUrl(orders);
  }

  Uri getPayStackUrl(List<Order> orders) {
    return _shopLaravelApiClient.getPayStackUrl(orders);
  }

  Uri getPayMongoUrl(List<Order> orders) {
    return _shopLaravelApiClient.getPayMongoUrl(orders);
  }

  Uri getFlutterWaveUrl(List<Order> orders) {
    return _shopLaravelApiClient.getFlutterWaveUrl(orders);
  }

  Uri getStripeFPXUrl(List<Order> orders) {
    return _shopLaravelApiClient.getStripeFPXUrl(orders);
  }
}
