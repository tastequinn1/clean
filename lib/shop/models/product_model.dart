import '../../app/models/media_model.dart';
import '../../app/models/parents/model.dart';
import 'category_model.dart';
import 'store_model.dart';

class Product extends Model {
  String? _name;
  String? _description;
  List<Media>? _images;
  double? _price;
  double? _discountPrice;
  String? _quantityUnit;
  bool? _featured;
  List<Category>? _categories;
  List<Category>? _subCategories;
  Store? _store;

  Product(
      {String? id,
      String? name,
      String? description,
      List<Media>? images,
      double? price,
      double? discountPrice,
      String? quantityUnit,
      bool? featured,
      List<Category>? categories,
      List<Category>? subCategories,
      Store? store})
      : _store = store,
        _subCategories = subCategories,
        _categories = categories,
        _featured = featured,
        _quantityUnit = quantityUnit,
        _discountPrice = discountPrice,
        _price = price,
        _images = images,
        _description = description,
        _name = name {
    this.id = id;
  }

  Product.fromJson(Map<String, dynamic>? json) {
    name = transStringFromJson(json, 'name');
    description = transStringFromJson(json, 'description');
    images = mediaListFromJson(json, 'images');
    price = doubleFromJson(json, 'price');
    discountPrice = doubleFromJson(json, 'discount_price');
    quantityUnit = transStringFromJson(json, 'quantity_unit');
    featured = boolFromJson(json, 'featured');
    categories = listFromJson<Category>(json, 'shop_categories', (value) => Category.fromJson(value));
    subCategories = listFromJson<Category>(json, 'sub_categories', (value) => Category.fromJson(value));
    store = objectFromJson(json, 'store', (value) => Store.fromJson(value));
    super.fromJson(json);
  }

  List<Category> get categories => _categories ?? [];

  set categories(List<Category>? value) {
    _categories = value;
  }

  String get description => _description ?? '';

  set description(String? value) {
    _description = value;
  }

  double get discountPrice => _discountPrice ?? 0;

  set discountPrice(double? value) {
    _discountPrice = value;
  }

  bool get featured => _featured ?? false;

  set featured(bool? value) {
    _featured = value;
  }

  String get firstImageIcon => this.images.first.icon;

  String get firstImageThumb => this.images.first.thumb;

  String get firstImageUrl => this.images.first.url;

  /*
  * Get discount price
  * */
  double get getOldPrice {
    return (_discountPrice ?? 0) > 0 ? price : 0;
  }

  /*
  * Get the real price of the service
  * when the discount not set, then it return the price
  * otherwise it return the discount price instead
  * */
  double get getPrice {
    return (_discountPrice ?? 0) > 0 ? discountPrice : price;
  }

  @override
  bool get hasData {
    return super.hasData && _name != null && _description != null;
  }

  @override
  int get hashCode => super.hashCode ^ id.hashCode ^ name.hashCode ^ description.hashCode ^ store.hashCode ^ categories.hashCode ^ subCategories.hashCode;

  List<Media> get images => _images ?? [];

  set images(List<Media>? value) {
    _images = value;
  }

  String get name => _name ?? '';

  set name(String? value) {
    _name = value;
  }

  double get price => _price ?? 0;

  set price(double? value) {
    _price = value;
  }

  String get quantityUnit => _quantityUnit ?? '';

  set quantityUnit(String? value) {
    _quantityUnit = value;
  }

  Store get store => _store ?? Store();

  set store(Store? value) {
    _store = value;
  }

  List<Category> get subCategories => _subCategories ?? [];

  set subCategories(List<Category>? value) {
    _subCategories = value;
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is Product &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          categories == other.categories &&
          subCategories == other.subCategories &&
          store == other.store;

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    if (this.hasData) data['id'] = this.id;
    if (_name != null) data['name'] = this.name;
    if (_description != null) data['description'] = this.description;
    if (_price != null) data['price'] = this.price;
    if (_discountPrice != null) data['discount_price'] = this.discountPrice;
    if (_quantityUnit != null && quantityUnit != 'null') data['quantity_unit'] = this.quantityUnit;
    if (_featured != null) data['featured'] = this.featured;
    if (_categories != null) {
      data['shop_categories'] = this.categories.map((v) => v.id).toList();
    }
    if (_images != null) {
      data['image'] = this.images.map((v) => v.toJson()).toList();
    }
    if (_subCategories != null) {
      data['sub_categories'] = this.subCategories.map((v) => v.toJson()).toList();
    }
    if (_store != null && this.store.hasData) {
      data['store_id'] = this.store.id;
    }
    return data;
  }
}
