import 'package:flutter/material.dart';

import '../models/models.dart';
import 'shopping_item_widget.dart';

typedef ShoppingItemListWidget_OnRemove = Function(ShoppingItem);

class ShoppingItemListWidget extends StatefulWidget {
  final List<ShoppingItem> shoppingItems;
  final ShoppingItemWidget_OnIncNumUnit onIncNumUnit;
  final ShoppingItemWidget_OnDecNumUnit onDecNumUnit;
  final ShoppingItemWidget_OnUpdate onUpdate;
  final ShoppingItemListWidget_OnRemove onRemove;
  final ScrollController scrollController;

  ShoppingItemListWidget({
    Key key,
    this.shoppingItems,
    this.onIncNumUnit,
    this.onDecNumUnit,
    this.onUpdate,
    this.onRemove,
    this.scrollController,
  }) : super(key: key);

  _ShoppingItemListWidgetState createState() => _ShoppingItemListWidgetState();
}

class _ShoppingItemListWidgetState extends State<ShoppingItemListWidget> {
  final GlobalKey<AnimatedListState> _listKey = GlobalKey<AnimatedListState>();
  final List<Tween<Offset>> _offsetAnimationList = [
    Tween<Offset>(begin: const Offset(0, 1), end: const Offset(0, 0)),
    Tween<Offset>(begin: const Offset(1, 1), end: const Offset(0, 0)),
    Tween<Offset>(begin: const Offset(1, 0), end: const Offset(0, 0)),
    Tween<Offset>(begin: const Offset(1, -1), end: const Offset(0, 0)),
    Tween<Offset>(begin: const Offset(0, -1), end: const Offset(0, 0)),
    Tween<Offset>(begin: const Offset(-1, -1), end: const Offset(0, 0)),
    Tween<Offset>(begin: const Offset(-1, 0), end: const Offset(0, 0)),
    Tween<Offset>(begin: const Offset(-1, 1), end: const Offset(0, 0)),
  ];
  int _offsetAnimationIndex = 0;

  int _getAddedItemIndex(List<ShoppingItem> oldList, List<ShoppingItem> newList) {
    int i;

    for (i = 0; i < oldList.length; i++) {
      if (oldList[i].id != newList[i].id) {
        break;
      }
    }
    return i;
  }

  int _getRemovedItemIndex(List<ShoppingItem> oldList, List<ShoppingItem> newList) {
    int i;

    for (i = 0; i < newList.length; i++) {
      if (oldList[i].id != newList[i].id) {
        break;
      }
    }
    return i;
  }

  Widget _buildItemWidgetWithAnimation(
    BuildContext context,
    Animation<double> animation,
    ShoppingItem item) =>
    Dismissible(
      key: Key(item.toString()),
      onDismissed: (direction) => widget.onRemove(item),
      child: SlideTransition(
        position: _offsetAnimationList[_offsetAnimationIndex++ % 8].animate(animation),
        child: ShoppingItemWidget(
          item: item,
          onIncNumUnit: widget.onIncNumUnit,
          onDecNumUnit: widget.onDecNumUnit,
          onUpdate: widget.onUpdate,
        ),
      ),
    );

  Widget _buildItemWidget4Removal(
    BuildContext context,
    Animation<double> animation,
    ShoppingItem item) => Container(
      height: 0,
    );

  @override
    void didUpdateWidget(ShoppingItemListWidget oldWidget) {
      super.didUpdateWidget(oldWidget);

      int updatedIndex;

      if (oldWidget.shoppingItems.length != widget.shoppingItems.length) {
        if (widget.shoppingItems.length == 0) {
          // Handel remove all items
          for (int i = oldWidget.shoppingItems.length - 1; i >= 0; i--) {
            _listKey.currentState.removeItem(
              i,
              (BuildContext context, Animation<double> animation) =>
                _buildItemWidgetWithAnimation(context, animation, oldWidget.shoppingItems[i]),
            );
          }
        } else if (oldWidget.shoppingItems.length < widget.shoppingItems.length) {
          // item added
          updatedIndex = _getAddedItemIndex(oldWidget.shoppingItems, widget.shoppingItems);
          _listKey.currentState.insertItem(updatedIndex);
        } else if (oldWidget.shoppingItems.length > widget.shoppingItems.length) {
          // item removed
          updatedIndex = _getRemovedItemIndex(oldWidget.shoppingItems, widget.shoppingItems);
          _listKey.currentState.removeItem(
            updatedIndex,
            (BuildContext context, Animation<double> animation) =>
              _buildItemWidget4Removal(context, animation, oldWidget.shoppingItems[updatedIndex]),
          );
        }
      }
    }

  @override
  Widget build(BuildContext context) {
    final itemList =
      AnimatedList(
        controller: widget.scrollController,
        key: _listKey,
        initialItemCount: widget.shoppingItems.length,
        itemBuilder: (BuildContext context, int index, Animation<double> animation)
          => _buildItemWidgetWithAnimation(context, animation, widget.shoppingItems[index]),
      );

    return itemList;
  }
}