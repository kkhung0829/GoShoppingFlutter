import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'shopping_state.dart';
import 'coupon_state.dart';
import 'dropbox_state.dart';

part 'app_state.g.dart';

@JsonSerializable()
@immutable
class AppState {
  final ShoppingState shoppingState;
  final CouponState couponState;
  final DropboxState dropboxState;

  AppState({
    ShoppingState shoppingState,
    CouponState couponState,
    DropboxState dropboxState,
  })
    : this.shoppingState = shoppingState ?? ShoppingState(),
      this.couponState = couponState ?? CouponState(),
      this.dropboxState = dropboxState ?? DropboxState();

  factory AppState.fromJson(Map<String, dynamic> json) => _$AppStateFromJson(json);
  Map<String, dynamic> toJson() => _$AppStateToJson(this);

  static AppState serializeFromJson(dynamic json) {
    return json != null ? AppState.fromJson(json) : AppState();
  }
}