import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'shopping_item.g.dart';

@JsonSerializable()
@immutable
class ShoppingItem {
  final String id;
  final String imageFilePath;
  final double unitPrice;
  final int numUnit;

  ShoppingItem({
    this.imageFilePath,
    this.unitPrice = 0.0,
    this.numUnit = 0,
    String id,
  }) : this.id = id ?? new Uuid().v4();

  ShoppingItem copyWith({
    String id,
    String imageFilePath,
    double unitPrice,
    int numUnit,
  }) => ShoppingItem(
    id: id ?? this.id,
    imageFilePath: imageFilePath ?? this.imageFilePath,
    unitPrice: unitPrice ?? this.unitPrice,
    numUnit: numUnit ?? this.numUnit,
  );

  factory ShoppingItem.fromJson(Map<String, dynamic> json) => _$ShoppingItemFromJson(json);
  Map<String, dynamic> toJson() => _$ShoppingItemToJson(this);
}