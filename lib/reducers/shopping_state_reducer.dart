import 'package:redux/redux.dart';
import '../actions/actions.dart';
import '../models/models.dart';

final shoppingStateReducer = combineReducers<ShoppingState>([
  TypedReducer<ShoppingState, AddShoppingItemAction>(_addShoppingItem),
  TypedReducer<ShoppingState, DelShoppingItemAction>(_delShoppingItem),
  TypedReducer<ShoppingState, UpdateShoppingItemAction>(_updateShoppingItem),
  TypedReducer<ShoppingState, DelAllShoppingItemsAction>(_delAllShoppingItems),
]);

ShoppingState _addShoppingItem(ShoppingState state, AddShoppingItemAction action) =>
  state.copyWith(
    shoppingItems: List.from(state.shoppingItems)
                      ..insert(0, action.item.copyWith()),
  );

ShoppingState _delShoppingItem(ShoppingState state, DelShoppingItemAction action) =>
  state.copyWith(
    shoppingItems: state.shoppingItems.where(
      (item) => item.id != action.id
    ).toList(),
  );

ShoppingState _updateShoppingItem(ShoppingState state, UpdateShoppingItemAction action) =>
  state.copyWith(
    shoppingItems: state.shoppingItems.map(
      (item) => item.id == action.id ? action.item.copyWith() : item
    ).toList(),
  );

ShoppingState _delAllShoppingItems(ShoppingState state, DelAllShoppingItemsAction action) =>
  state.copyWith(
    shoppingItems: const [],
  );