import 'package:get/get.dart';

import '../models/order_model.dart';
import '../models/order_status_model.dart';
import '../providers/shop_laravel_provider.dart';

class OrderRepository {
  late ShopLaravelApiClient _laravelApiClient;

  OrderRepository() {
    this._laravelApiClient = Get.find<ShopLaravelApiClient>();
  }

  Future<List<Order>> all(String? statusId, {int page = 1}) {
    return _laravelApiClient.getOrders(statusId, page);
  }

  Future<List<OrderStatus>> getStatuses() {
    return _laravelApiClient.getOrderStatuses();
  }

  Future<Order> get(String? orderId) {
    return _laravelApiClient.getOrder(orderId);
  }

  Future<List<Order>> add(List<Order> orders) {
    return _laravelApiClient.addOrder(orders);
  }

  Future<Order> update(Order order) {
    return _laravelApiClient.updateOrder(order);
  }
}
