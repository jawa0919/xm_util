import 'dart:math' as math;

import 'package:flutter/widgets.dart';

extension TrueBool on bool? {
  bool get isTrue => this ?? false;
}

extension RoundDouble on double {
  double roundTo(num value) => (this * value).round() / value;
  double roundToPrecision(int precision) {
    final factor = math.pow(10, precision);
    return (this * factor).round() / factor;
  }
}

extension TrueString on String? {
  bool get isEmpty => this?.isEmpty ?? this == null;
  bool get isNotEmpty => !isEmpty;
  bool toBool([bool defaultValue = false]) => switch (this) {
    'true' => true,
    'false' => false,
    _ => defaultValue,
  };
}

extension NumString on String? {
  double toDouble([double defaultValue = 0.0]) =>
      double.tryParse(this ?? '$defaultValue') ?? defaultValue;
  int toInt([int defaultValue = 0]) =>
      int.tryParse(this ?? '$defaultValue') ?? defaultValue;
}

extension OnTapContainer on Container {
  Widget onTap(GestureTapCallback? onTap) {
    return GestureDetector(onTap: onTap, child: this);
  }
}

extension OnTapText on Text {
  Widget onTap(GestureTapCallback? onTap) {
    return GestureDetector(onTap: onTap, child: this);
  }
}

void main(List<String> args) {}
