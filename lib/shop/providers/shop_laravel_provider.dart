import 'package:get/get.dart';

import '../../app/models/payment_method_model.dart';
import '../../app/models/user_model.dart';
import '../../app/models/wallet_model.dart';
import '../../app/providers/api_provider.dart';
import '../../app/services/settings_service.dart';
import '../models/cart_model.dart';
import '../models/category_model.dart';
import '../models/option_group_model.dart';
import '../models/order_model.dart';
import '../models/order_status_model.dart';
import '../models/product_model.dart';
import '../models/store_model.dart';

class ShopLaravelApiClient with ApiClient {
  ShopLaravelApiClient() {
    this.baseUrl = this.globalService.global.value.laravelBaseUrl ?? '';
  }

  Future<ShopLaravelApiClient> init() async {
    super.init();
    return this;
  }

  Future<List<Product>> getRecommendedProducts() async {
    if (!Get.find<SettingsService>().isModuleActivated("Shop")) {
      return [];
    }
    final _address = Get.find<SettingsService>().address.value;
    // TODO get Only Recommended
    var _queryParameters = {
      'only': 'id;name;price;discount_price;quantity_unit;has_media;media',
      'with': 'store',
      'limit': '6',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("shop/products").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Product>((obj) => Product.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Product>> getAllProductsWithPagination(String? categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'store;store.addresses;shopCategories',
      'search': 'shopCategories.id:$categoryId',
      'searchFields': 'shopCategories.id:=',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("shop/products").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Product>((obj) => Product.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Product>> searchProducts(String? keywords, List<String> categories, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    // TODO Pagination
    var _queryParameters = {
      'with': 'store;store.addresses;shopCategories',
      'search': 'shopCategories.id:${categories.join(',')};name:$keywords',
      'searchFields': 'shopCategories.id:in;name:like',
      'searchJoin': 'and',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("shop/products").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Product>((obj) => Product.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Product> getProduct(String? id) async {
    var _queryParameters = {
      'with': 'store;store.taxes;shopCategories',
    };
    if (authService.isAuth) {
      _queryParameters['api_token'] = authService.apiToken;
    }
    Uri _uri = getApiBaseUri("shop/products/$id").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return Product.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Store> getStore(String? storeId) async {
    const _queryParameters = {
      'with': 'storeType;users;addresses',
    };
    Uri _uri = getApiBaseUri("shop/stores/$storeId").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return Store.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<User>> getStoreEmployees(String storeId) async {
    var _queryParameters = {'with': 'users', 'only': 'users;users.id;users.name;users.email;users.phone_number;users.device_token'};
    Uri _uri = getApiBaseUri("shop/stores/$storeId").replace(queryParameters: _queryParameters);
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data']['users'].map<User>((obj) => User.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Product>> getStoreFeaturedProducts(String? storeId, int page) async {
    var _queryParameters = {
      'with': 'store;store.addresses;shopCategories',
      'search': 'store_id:$storeId;featured:1',
      'searchFields': 'store_id:=;featured:=',
      'searchJoin': 'and',
      'limit': '5',
      'offset': ((page - 1) * 5).toString()
    };
    Uri _uri = getApiBaseUri("shop/products").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Product>((obj) => Product.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Product>> getStorePopularProducts(String? storeId, int page) async {
    // TODO popular products
    var _queryParameters = {
      'with': 'store;store.addresses;shopCategories',
      'search': 'store_id:$storeId',
      'searchFields': 'store_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("shop/products").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Product>((obj) => Product.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Product>> getStoreAvailableProducts(String? storeId, int page) async {
    var _queryParameters = {
      'with': 'store;store.addresses;shopCategories',
      'search': 'store_id:$storeId',
      'searchFields': 'store_id:=',
      'available_store': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("shop/products").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Product>((obj) => Product.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Product>> getStoreMostRatedProducts(String? storeId, int page) async {
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'store;store.addresses;shopCategories',
      'search': 'store_id:$storeId',
      'searchFields': 'store_id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("shop/products").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Product>((obj) => Product.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Product>> getStoreProducts(String? storeId, int page) async {
    var _queryParameters = {
      'with': 'store;store.addresses;shopCategories',
      'search': 'store_id:$storeId',
      'searchFields': 'store_id:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("shop/products").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Product>((obj) => Product.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OptionGroup>> getProductOptionGroups(String? productId) async {
    var _queryParameters = {
      'with': 'productOptions;productOptions.media',
      'only': 'id;name;allow_multiple;productOptions.id;productOptions.name;productOptions.description;productOptions.price;productOptions.product_option_group_id;productOptions'
          '.product_id;productOptions.media',
      'search': "productOptions.product_id:$productId",
      'searchFields': 'productOptions.product_id:=',
      'orderBy': 'name',
      'sortBy': 'desc'
    };
    Uri _uri = getApiBaseUri("shop/product_option_groups").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<OptionGroup>((obj) => OptionGroup.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Product>> getFeaturedProducts(String? categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'store;store.addresses;shopCategories',
      'search': 'shopCategories.id:$categoryId;featured:1',
      'searchFields': 'shopCategories.id:=;featured:=',
      'searchJoin': 'and',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("shop/products").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Product>((obj) => Product.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Product>> getPopularProducts(String? categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'store;store.addresses;shopCategories',
      'search': 'shopCategories.id:$categoryId',
      'searchFields': 'shopCategories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("shop/products").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Product>((obj) => Product.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Product>> getMostRatedProducts(String? categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      //'only': 'id;name;price;discount_price;price_unit;duration;has_media;total_reviews;rate',
      'with': 'store;store.addresses;shopCategories',
      'search': 'shopCategories.id:$categoryId',
      'searchFields': 'shopCategories.id:=',
      'rating': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("shop/products").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Product>((obj) => Product.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Product>> getAvailableProducts(String? categoryId, int page) async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'store;store.addresses;shopCategories',
      'search': 'shopCategories.id:$categoryId',
      'searchFields': 'shopCategories.id:=',
      'available_store': 'true',
      'limit': '4',
      'offset': ((page - 1) * 4).toString()
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("shop/products").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Product>((obj) => Product.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllCategories() async {
    const _queryParameters = {
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("shop/shop_categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllParentCategories() async {
    const _queryParameters = {
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("shop/shop_categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getSubCategories(String? categoryId) async {
    final _queryParameters = {
      'search': "parent_id:$categoryId",
      'searchFields': "parent_id:=",
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("shop/shop_categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getAllWithSubCategories() async {
    const _queryParameters = {
      'with': 'subCategories',
      'parent': 'true',
      'orderBy': 'order',
      'sortBy': 'asc',
    };
    Uri _uri = getApiBaseUri("shop/shop_categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Category>> getFeaturedCategories() async {
    final _address = Get.find<SettingsService>().address.value;
    var _queryParameters = {
      'with': 'featuredProducts',
      'parent': 'true',
      'search': 'featured:1',
      'searchFields': 'featured:=',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    if (!_address.isUnknown()) {
      _queryParameters['myLat'] = _address.latitude.toString();
      _queryParameters['myLon'] = _address.longitude.toString();
    }
    Uri _uri = getApiBaseUri("shop/shop_categories").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<Category>((obj) => Category.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Cart>> getCart() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getCarts() ]");
    }
    var _queryParameters = {
      'with': 'product;product.store;product.store.taxes;productOptions',
      'api_token': authService.apiToken,
      'search': 'user_id:${authService.user.value.id}',
      'orderBy': 'created_at',
      'sortedBy': 'desc',
    };
    Uri _uri = getApiBaseUri("shop/carts").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Cart>((obj) => Cart.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Cart> addToCart(Cart cart) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addToCart() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("shop/carts").replace(queryParameters: _queryParameters);
    var response = await httpClient.postUri(_uri, data: cart.toJson(), options: optionsNetwork);
    if (response.data['success'] == true) {
      return Cart.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Cart> updateCart(Cart cart) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateCart() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("shop/carts/${cart.id}").replace(queryParameters: _queryParameters);
    var response = await httpClient.putUri(_uri, data: cart.toJson(), options: optionsNetwork);
    if (response.data['success'] == true) {
      return Cart.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Cart> removeFromCart(Cart cart) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ removeCart() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("shop/carts/${cart.id}").replace(queryParameters: _queryParameters);
    var response = await httpClient.deleteUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return Cart.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<int> getCartsCount() async {
    if (!authService.isAuth) {
      return 0;
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("shop/carts/count").replace(queryParameters: _queryParameters);
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'];
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Order>> getOrders(String? statusId, int page) async {
    var _queryParameters = {
      'with': 'orderStatus;payment;payment.paymentStatus', 'api_token': authService.apiToken, // 'search': 'user_id:${authService.user.value.id}',
      'search': 'order_status_id:${statusId}', 'orderBy': 'created_at', 'sortedBy': 'desc', 'limit': '4', 'offset': ((page - 1) * 4).toString()
    };
    Uri _uri = getApiBaseUri("shop/orders").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Order>((obj) => Order.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<OrderStatus>> getOrderStatuses() async {
    var _queryParameters = {
      'only': 'id;status;order',
      'orderBy': 'order',
      'sortedBy': 'asc',
    };
    Uri _uri = getApiBaseUri("shop/order_statuses").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<OrderStatus>((obj) => OrderStatus.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Order> getOrder(String? orderId) async {
    var _queryParameters = {
      'with': 'orderStatus;user;payment;payment.paymentMethod;payment.paymentStatus',
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("shop/orders/${orderId}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsNetwork);
    if (response.data['success'] == true) {
      return Order.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<Order> updateOrder(Order order) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ updateOrder() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("shop/orders/${order.id}").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.putUri(_uri, data: order.toJson(), options: optionsNetwork);
    if (response.data['success'] == true) {
      return Order.fromJson(response.data['data']);
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<Order>> addOrder(List<Order> orders) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ addOrder() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("shop/orders").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.postUri(_uri, data: orders.map((e) => e.toJson()).toList(), options: optionsNetwork);
    if (response.data['success'] == true) {
      return response.data['data'].map<Order>((obj) => Order.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> createPayment(List<Order> orders) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("shop/payments/cash").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.postUri(_uri, data: orders.map((e) => e.toJson()).toList(), options: optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<List<PaymentMethod>> getPaymentMethods() async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPaymentMethods() ]");
    }
    var _queryParameters = {
      'with': 'media', 'search': 'enabled:1;id:5,6,7,11', // cash, paypal, stripe, wallet
      'searchFields': 'enabled:=;id:in', 'searchJoin': 'and', 'orderBy': 'order', 'sortBy': 'asc', 'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("payment_methods").replace(queryParameters: _queryParameters);
    Get.log(_uri.toString());
    var response = await httpClient.getUri(_uri, options: optionsCache);
    if (response.data['success'] == true) {
      return response.data['data'].map<PaymentMethod>((obj) => PaymentMethod.fromJson(obj)).toList();
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Future<bool> createWalletPayment(List<Order> orders, Wallet _wallet) async {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ createPayment() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
    };
    Uri _uri = getApiBaseUri("shop/payments/wallets/${_wallet.id}").replace(queryParameters: _queryParameters);
    var response = await httpClient.postUri(_uri, data: orders.map((e) => e.toJson()).toList(), options: optionsNetwork);
    if (response.data['success'] == true) {
      return true;
    } else {
      throw new Exception(response.data['message']);
    }
  }

  Uri getPayPalUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayPalUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("shop/payments/paypal/express-checkout").replace(queryParameters: _queryParameters);
    return _uri;
  }

  Uri getRazorPayUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getRazorPayUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("shop/payments/razorpay/checkout").replace(queryParameters: _queryParameters);
    return _uri;
  }

  Uri getStripeUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getStripeUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("shop/payments/stripe/checkout").replace(queryParameters: _queryParameters);
    return _uri;
  }

  Uri getPayStackUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayStackUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("shop/payments/paystack/checkout").replace(queryParameters: _queryParameters);
    return _uri;
  }

  Uri getPayMongoUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getPayMongoUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("shop/payments/paymongo/checkout").replace(queryParameters: _queryParameters);
    return _uri;
  }

  Uri getFlutterWaveUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getFlutterWaveUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("shop/payments/flutterwave/checkout").replace(queryParameters: _queryParameters);
    return _uri;
  }

  Uri getStripeFPXUrl(List<Order> _orders) {
    if (!authService.isAuth) {
      throw new Exception("You don't have the permission to access to this area!".tr + "[ getStripeFPXUrl() ]");
    }
    var _queryParameters = {
      'api_token': authService.apiToken,
      'orders_id[]': _orders.map((e) => e.id).toList(),
    };
    Uri _uri = getBaseUri("shop/payments/stripe-fpx/checkout").replace(queryParameters: _queryParameters);
    return _uri;
  }
}
