import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'shopping_state.dart';
import 'coupon_state.dart';

part 'app_state.g.dart';

@JsonSerializable()
@immutable
class AppState {
  final ShoppingState shoppingState;
  final CouponState couponState;

  AppState({
    ShoppingState shoppingState,
    CouponState couponState,
  })
    : this.shoppingState = shoppingState ?? ShoppingState(),
      this.couponState = couponState ?? CouponState();

  factory AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);
  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  static AppState serializeFromJson(dynamic json) {
    return json != null ? AppState.fromJson(json) : AppState();
  }
}