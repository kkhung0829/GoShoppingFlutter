import 'package:meta/meta.dart';
import 'package:json_annotation/json_annotation.dart';

import 'shopping_item.dart';

part 'shopping_state.g.dart';

@JsonSerializable()
@immutable
class ShoppingState {
  final List<ShoppingItem> shoppingItems;

  ShoppingState({
    this.shoppingItems = const [],
  });

  ShoppingState copyWith({
    List<ShoppingItem> shoppingItems,
  }) => ShoppingState(
    shoppingItems: shoppingItems ?? this.shoppingItems,
  );

  factory ShoppingState.fromJson(Map<String, dynamic> json) => _$ShoppingStateFromJson(json);
  Map<String, dynamic> toJson() => _$ShoppingStateToJson(this);
}