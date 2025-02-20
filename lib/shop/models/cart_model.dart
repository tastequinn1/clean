import 'package:get/get.dart';

import '../../app/models/parents/model.dart';
import '../../app/models/tax_model.dart';
import '../../app/models/user_model.dart';
import 'option_model.dart';
import 'product_model.dart';
import 'store_model.dart';

class Cart extends Model {
  Rx<int>? _quantity;
  Product? _product;
  Store? _store;
  List<Tax>? _taxes;
  List<Option>? _options;
  User? _user;

  Cart({
    String? id,
    Product? product,
    List<Option>? options,
    Store? store,
    List<Tax>? taxes,
    User? user,
    Rx<int>? quantity,
  }) {
    this.id = id;
    _user = user;
    _options = options;
    _taxes = taxes;
    _store = store;
    _product = product;
    _quantity = quantity;
  }

  Cart.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    quantity.value = intFromJson(json, 'quantity', defaultValue: 1);
    _product = objectFromJson(json, 'product', (v) => Product.fromJson(v));
    _options = listFromJson(json, 'product_options', (v) => Option.fromJson(v));
    _user = objectFromJson(json, 'user', (v) => User.fromJson(v));
    _store = _product?.store;
    _taxes = _product?.store.taxes;
  }

  @override
  int get hashCode => super.hashCode ^ id.hashCode ^ quantity.hashCode ^ user.hashCode ^ product.hashCode ^ options.hashCode & store.hashCode ^ taxes.hashCode;

  List<Option> get options => _options ?? [];

  set options(List<Option>? value) {
    _options = value;
  }

  Product get product => _product ?? Product();

  set product(Product? value) {
    _product = value;
  }

  Rx<int> get quantity => _quantity ?? Rx<int>(1);

  set quantity(Rx<int>? value) {
    _quantity = value;
  }

  Store get store => _store ?? Store();

  set store(Store? value) {
    _store = value;
  }

  List<Tax> get taxes => _taxes ?? [];

  set taxes(List<Tax>? value) {
    _taxes = value;
  }

  User get user => _user ?? User();

  set user(User? value) {
    _user = value;
  }

  @override
  bool operator ==(dynamic other) => other is Cart && product.id == other.product.id && options.every((element) => other.options.contains(element));

  double getSubtotal() {
    double total = 0.0;
    total = product.getPrice * (quantity.value >= 1 ? quantity.value : 1);
    options.forEach((element) {
      total += element.price * (quantity.value >= 1 ? quantity.value : 1);
    });

    return total;
  }

  double getTaxesValue() {
    double total = getSubtotal();
    double taxValue = 0.0;
    taxes.forEach((element) {
      if (element.type == 'percent') {
        taxValue += (total * element.value / 100);
      } else {
        taxValue += element.value;
      }
    });
    return taxValue;
  }

  double getTotal() {
    double total = getSubtotal();
    total += getTaxesValue();
    return total;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.hasData) {
      data['id'] = this.id;
    }
    if (this._quantity != null) {
      data['quantity'] = this.quantity.value;
    }
    if (this._options != null && this.options.isNotEmpty) {
      data['productOptions'] = this.options.map((e) => e.id).toList();
    }
    if (this._product != null) {
      data['product_id'] = this.product.id;
    }
    return data;
  }

  @override
  String toString() {
    return 'Cart{id: $id, quantity: $quantity, product: $product, store: $store, taxes: $taxes, options: $options, user: $user}';
  }
}
