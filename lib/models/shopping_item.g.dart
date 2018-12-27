// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ShoppingItem _$ShoppingItemFromJson(Map<String, dynamic> json) {
  return ShoppingItem(
      imageFilePath: json['imageFilePath'] as String,
      unitPrice: (json['unitPrice'] as num)?.toDouble(),
      numUnit: json['numUnit'] as int,
      id: json['id'] as String);
}

Map<String, dynamic> _$ShoppingItemToJson(ShoppingItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'imageFilePath': instance.imageFilePath,
      'unitPrice': instance.unitPrice,
      'numUnit': instance.numUnit
    };
