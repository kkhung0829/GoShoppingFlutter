// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'coupon_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CouponState _$CouponStateFromJson(Map<String, dynamic> json) {
  return CouponState(
      coupons: (json['coupons'] as List)
          ?.map((e) =>
              e == null ? null : Coupon.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$CouponStateToJson(CouponState instance) =>
    <String, dynamic>{'coupons': instance.coupons};
