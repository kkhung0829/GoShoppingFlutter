import '../models/models.dart';
import 'package:meta/meta.dart';

class AddShoppingItemAction {
  final ShoppingItem item;

  AddShoppingItemAction({
    @required this.item
  });
}

class DelShoppingItemAction {
  final String id;

  DelShoppingItemAction({
    @required this.id
  });
}

class UpdateShoppingItemAction {
  final String        id;
  final ShoppingItem  item;

  UpdateShoppingItemAction({
    @required this.id,
    @required this.item,
  });
}

class DelAllShoppingItemsAction {}