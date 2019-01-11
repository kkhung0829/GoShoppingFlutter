// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AppState _$AppStateFromJson(Map<String, dynamic> json) {
  return AppState(
      shoppingState: json['shoppingState'] == null
          ? null
          : ShoppingState.fromJson(
              json['shoppingState'] as Map<String, dynamic>),
      couponState: json['couponState'] == null
          ? null
          : CouponState.fromJson(json['couponState'] as Map<String, dynamic>),
      dropboxState: json['dropboxState'] == null
          ? null
          : DropboxState.fromJson(
              json['dropboxState'] as Map<String, dynamic>));
}

Map<String, dynamic> _$AppStateToJson(AppState instance) => <String, dynamic>{
      'shoppingState': instance.shoppingState,
      'couponState': instance.couponState,
      'dropboxState': instance.dropboxState
    };
