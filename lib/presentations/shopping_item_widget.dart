import 'dart:io';
import 'package:flutter/material.dart';

import '../models/models.dart';
import 'hero_dialog_route.dart';
import 'shopping_item_detail_widget.dart';

typedef ShoppingItemWidget_OnIncNumUnit = void Function(ShoppingItem item);
typedef ShoppingItemWidget_OnDecNumUnit = void Function(ShoppingItem item);
typedef ShoppingItemWidget_OnUpdate = void Function(ShoppingItem item);

class ShoppingItemWidget extends StatelessWidget {
  final ShoppingItem item;
  final ShoppingItemWidget_OnIncNumUnit onIncNumUnit;
  final ShoppingItemWidget_OnDecNumUnit onDecNumUnit;
  final ShoppingItemWidget_OnUpdate onUpdate;

  ShoppingItemWidget({
    Key key,
    this.item,
    this.onIncNumUnit,
    this.onDecNumUnit,
    this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final totalPrice = item.unitPrice * item.numUnit;

    final details = ListTile(
      leading: Container(
        child: Hero(
          tag: item.id,
          child: Material(
            color: Colors.transparent,
            child: (item.imageFilePath != null && item.imageFilePath.isNotEmpty)
              // ? Image.file(File(item.imageFilePath))
              ? CircleAvatar(
                  backgroundImage: FileImage(
                    File(item.imageFilePath)
                  )
                )
              : const Icon(Icons.shopping_cart),
          ),
        ),
        width: 48,
        height: 48,
      ),
      title: Text('@${item.unitPrice}'),
      subtitle: Text('X${item.numUnit}'),
      trailing: Chip(
        label: Text('\$${totalPrice.toStringAsFixed(1)}'),
        backgroundColor: item.numUnit > 0
          ? Colors.lightBlueAccent
          : Colors.lightGreenAccent,
      ),
    );

    final buttonBar =
      ButtonTheme.bar(
        child: ButtonBar(
          alignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            IconButton(
              icon: Icon(Icons.add_circle),
              onPressed: () {
                onIncNumUnit(item);
              },
            ),
            IconButton(
              icon: Icon(Icons.remove_circle),
              onPressed: () {
                if (item.numUnit > 0) {
                  onDecNumUnit(item);
                }
              },
            ),
          ],
        ),
      );

    final output = GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        // showDialog<ShoppingItem>(
        //   context: context,
        //   barrierDismissible: false,
        //   builder: (BuildContext context) =>
        //       ShoppingItemDetailWidget(item: item),
        // ).then((ShoppingItem updatedItem) {
        //   if (updatedItem != null) {
        //     onUpdateItem(updatedItem);
        //   }
        // });
        Navigator.push<ShoppingItem>(
          context,
          HeroDialogRoute(
            barrierDismissible: false,
            builder: (BuildContext context) =>
              Center(
                child: ShoppingItemDetailWidget(item: item),
              ),
          ),
        ).then((ShoppingItem updatedItem) {
          if (updatedItem != null) {
            onUpdate(updatedItem);
          }
        });
      },
      child: Card(
        child: Column(
          children: <Widget>[
            details,
            buttonBar,
          ],
        ),
      ),
    );

    return output;
  }
}
