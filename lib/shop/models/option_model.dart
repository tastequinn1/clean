import 'package:get/get.dart';

import '../../app/models/media_model.dart';
import '../../app/models/parents/model.dart';

class Option extends Model {
  String? _optionGroupId;
  String? _productId;
  String? _name;
  double? _price;
  Media? _image;
  String? _description;
  var checked = false.obs;

  Option({String? id, String? optionGroupId, String? productId, String? name, double? price, Media? image, String? description}) {
    this.id = id;
    this._optionGroupId = optionGroupId;
    this._productId = productId;
    this._name = name;
    this._price = price;
    this._image = image;
    this._description = description;
  }

  Option.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _optionGroupId = stringFromJson(json, 'product_option_group_id', defaultValue: '0');
    _productId = stringFromJson(json, 'product_id', defaultValue: '0');
    _name = transStringFromJson(json, 'name');
    _price = doubleFromJson(json, 'price');
    _description = transStringFromJson(json, 'description');
    _image = mediaFromJson(json, 'image');
  }

  String get description => _description ?? '';

  set description(String? value) {
    _description = value;
  }

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ optionGroupId.hashCode ^ productId.hashCode ^ name.hashCode ^ price.hashCode ^ image.hashCode ^ description.hashCode ^ checked.hashCode;

  Media get image => _image ?? Media();

  set image(Media? value) {
    _image = value;
  }

  String get name => _name ?? '';

  set name(String? value) {
    _name = value;
  }

  String get optionGroupId => _optionGroupId ?? '';

  set optionGroupId(String? value) {
    _optionGroupId = value;
  }

  double get price => _price ?? 0;

  set price(double? value) {
    _price = value;
  }

  String get productId => _productId ?? '';

  set productId(String? value) {
    _productId = value;
  }

  @override
  bool operator ==(dynamic other) => other is Option && id == other.id && name == other.name && price == other.price;

  Map<String, dynamic> toJson() {
    var map = new Map<String, dynamic>();
    if (this.hasData) map["id"] = id;
    if (_name != null) map["name"] = name;
    if (_price != null) map["price"] = price;
    if (_description != null) map["description"] = description;
    map["checked"] = checked.value;
    if (_optionGroupId != null) map["product_option_group_id"] = optionGroupId;
    if (_productId != null) map["product_id"] = productId;
    if (this._image != null) {
      map['image'] = this.image.toJson();
    }
    return map;
  }
}
