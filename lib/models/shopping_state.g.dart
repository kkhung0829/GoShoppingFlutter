// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_state.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingState _$ShoppingStateFromJson(Map<String, dynamic> json) {
  return ShoppingState(
      shoppingItems: (json['shoppingItems'] as List)
          ?.map((e) => e == null
              ? null
              : ShoppingItem.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$ShoppingStateToJson(ShoppingState instance) =>
    <String, dynamic>{'shoppingItems': instance.shoppingItems};
