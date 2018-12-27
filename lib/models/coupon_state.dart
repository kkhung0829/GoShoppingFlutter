import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'coupon.dart';

part 'coupon_state.g.dart';

@JsonSerializable()
@immutable
class CouponState {
  final List<Coupon> coupons;

  CouponState({
    this.coupons = const [],
  });

  CouponState copyWith({
    List<Coupon> coupons,
  }) => CouponState(
    coupons: coupons ?? this.coupons,
  );

  factory CouponState.fromJson(Map<String, dynamic> json) => _$CouponStateFromJson(json);
  Map<String, dynamic> toJson() => _$CouponStateToJson(this);
}
