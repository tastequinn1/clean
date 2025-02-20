/*
 * Copyright (c) 2020 .
 */

import 'dart:core';

import 'parents/model.dart';

class AvailabilityHour extends Model {
  String? _day;
  String? _startAt;
  String? _endAt;
  String? _data;

  AvailabilityHour({String? id, String? day, String? startAt, String? endAt, String? data}) {
    _data = data;
    _endAt = endAt;
    _startAt = startAt;
    _day = day;
    this.id = id;
  }

  AvailabilityHour.fromJson(Map<String, dynamic>? json) {
    super.fromJson(json);
    _day = stringFromJson(json, 'day');
    _startAt = stringFromJson(json, 'start_at');
    _endAt = stringFromJson(json, 'end_at');
    _data = transStringFromJson(json, 'data');
  }

  String get data => _data ?? '';

  set data(String? value) {
    _data = value;
  }

  String get day => _day ?? '';

  set day(String? value) {
    _day = value;
  }

  String get endAt => _endAt ?? '';

  set endAt(String? value) {
    _endAt = value;
  }

  String get startAt => _startAt ?? '';

  set startAt(String? value) {
    _startAt = value;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['day'] = this._day;
    data['start_at'] = this._startAt;
    data['end_at'] = this._endAt;
    data['data'] = this._data;
    return data;
  }
}
