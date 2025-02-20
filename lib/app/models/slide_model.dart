import 'package:flutter/material.dart';

import 'e_provider_model.dart';
import 'e_service_model.dart';
import 'media_model.dart';
import 'parents/model.dart';

class Slide extends Model {
  int? _order;

  int get order => _order ?? 0;

  set order(int? value) {
    _order = value;
  }

  String? _text;

  String get text => _text ?? '';

  set text(String? value) {
    _text = value;
  }

  String? _button;

  String get button => _button ?? '';

  set button(String? value) {
    _button = value;
  }

  String? _textPosition;

  String get textPosition => _textPosition ?? '';

  set textPosition(String? value) {
    _textPosition = value;
  }

  Color? _textColor;

  Color get textColor => _textColor ?? Colors.white24;

  set textColor(Color? value) {
    _textColor = value;
  }

  Color? _buttonColor;

  Color get buttonColor => _buttonColor ?? Colors.white24;

  set buttonColor(Color? value) {
    _buttonColor = value;
  }

  Color? _backgroundColor;

  Color get backgroundColor => _backgroundColor ?? Colors.white24;

  set backgroundColor(Color? value) {
    _backgroundColor = value;
  }

  Color? _indicatorColor;

  Color get indicatorColor => _indicatorColor ?? Colors.white24;

  set indicatorColor(Color? value) {
    _indicatorColor = value;
  }

  Media? _image;

  Media get image => _image ?? Media();

  set image(Media value) {
    _image = value;
  }

  String? _imageFit;

  String get imageFit => _imageFit ?? '';

  set imageFit(String? value) {
    _imageFit = value;
  }

  EService? _eService;

  EService get eService => _eService ?? EService();

  set eService(EService? value) {
    _eService = value;
  }

  EProvider? _eProvider;

  EProvider get eProvider => _eProvider ?? EProvider();

  set eProvider(EProvider? value) {
    _eProvider = value;
  }

  bool? _enabled;

  bool get enabled => _enabled ?? false;

  set enabled(bool? value) {
    _enabled = value;
  }

  Slide({
    String? id,
    int? order,
    String? text,
    String? button,
    String? textPosition,
    Color? textColor,
    Color? buttonColor,
    Color? backgroundColor,
    Color? indicatorColor,
    String? imageFit,
    EService? eService,
    EProvider? eProvider,
    bool? enabled,
  }) {
    _enabled = enabled;
    _eProvider = eProvider;
    _eService = eService;
    _imageFit = imageFit;
    _indicatorColor = indicatorColor;
    _backgroundColor = backgroundColor;
    _buttonColor = buttonColor;
    _textColor = textColor;
    _textPosition = textPosition;
    _button = button;
    _text = text;
    _order = order;
    this.id = id;
  }

  Slide.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _order = intFromJson(json, 'order');
    _text = transStringFromJson(json, 'text');
    _button = transStringFromJson(json, 'button');
    _textPosition = stringFromJson(json, 'text_position');
    _textColor = colorFromJson(json, 'text_color');
    _buttonColor = colorFromJson(json, 'button_color');
    _backgroundColor = colorFromJson(json, 'background_color');
    _indicatorColor = colorFromJson(json, 'indicator_color');
    _image = mediaFromJson(json, 'image');
    _imageFit = stringFromJson(json, 'image_fit');
    _eService = json?['e_service_id'] != null ? EService(id: json?['e_service_id'].toString()) : null;
    _eProvider = json?['e_provider_id'] != null ? EProvider(id: json?['e_provider_id'].toString()) : null;
    _enabled = boolFromJson(json, 'enabled');
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['text'] = this.text;
    return data;
  }
}
