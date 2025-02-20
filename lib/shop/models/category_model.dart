import 'package:flutter/material.dart';

import '../../app/models/media_model.dart';
import '../../app/models/parents/model.dart';
import 'product_model.dart';

class Category extends Model {
  String? _name;

  String get name => _name ?? '';

  set name(String? value) {
    _name = value;
  }

  String? _description;

  String get description => _description ?? '';

  set description(String? value) {
    _description = value;
  }

  Color? _color;

  Color get color => _color ?? Colors.white24;

  set color(Color? value) {
    _color = value;
  }

  Media? _image;

  Media get image => _image ?? Media();

  set image(Media? value) {
    _image = value;
  }

  bool? _featured;

  bool get featured => _featured ?? false;

  set featured(bool? value) {
    _featured = value;
  }

  List<Category>? _subCategories;

  List<Category> get subCategories => _subCategories ?? [];

  set subCategories(List<Category>? value) {
    _subCategories = value;
  }

  List<Product>? _products;

  List<Product> get products => _products ?? [];

  set products(List<Product>? value) {
    _products = value;
  }

  Category({String? id, String? name, String? description, Color? color, Media? image, bool? featured, List<Category>? subCategories, List<Product>? products}) {
    this.id = id;
    _products = products;
    _subCategories = subCategories;
    _featured = featured;
    _image = image;
    _color = color;
    _description = description;
    _name = name;
  }

  Category.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    name = transStringFromJson(json, 'name');
    color = colorFromJson(json, 'color');
    description = transStringFromJson(json, 'description');
    image = mediaFromJson(json, 'image');
    featured = boolFromJson(json, 'featured');
    products = listFromJsonArray(json, ['products', 'featured_products'], (v) => Product.fromJson(v));
    subCategories = listFromJson(json, 'sub_categories', (v) => Category.fromJson(v));
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['color'] = '#${this.color.value.toRadixString(16)}';
    return data;
  }

  @override
  bool operator ==(dynamic other) =>
      identical(this, other) ||
      super == other &&
          other is Category &&
          runtimeType == other.runtimeType &&
          id == other.id &&
          name == other.name &&
          description == other.description &&
          color == other.color &&
          image == other.image &&
          featured == other.featured &&
          subCategories == other.subCategories &&
          products == other.products;

  @override
  int get hashCode =>
      super.hashCode ^ id.hashCode ^ name.hashCode ^ description.hashCode ^ color.hashCode ^ image.hashCode ^ featured.hashCode ^ subCategories.hashCode ^ products.hashCode;
}
