import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';

import '../models/models.dart';
import '../selectors/selectors.dart';
import '../actions/actions.dart';
import '../presentations/presentations.dart';

class ShoppingScreen extends StatefulWidget {
  ShoppingScreen({
    Key key,
  }) : super(key: key);

  _ShoppingScreenState createState() => _ShoppingScreenState();
}

class _ShoppingScreenState extends State<ShoppingScreen> {
  ScrollController _scrollController = ScrollController();
  bool _showFAB = true;

  void _scrollListener() {
    if (_scrollController.position.userScrollDirection ==
        ScrollDirection.forward) {
      setState(() {
        _showFAB = false;
      });
    } else if (_scrollController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      setState(() {
        _showFAB = true;
      });
    }
  }

  @override
  void initState() {
    super.initState();

    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    super.dispose();

    _scrollController.removeListener(_scrollListener);
    _scrollController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StoreConnector<AppState, _ViewModel>(
      converter: _ViewModel.fromStore,
      builder: (context, viewModel) {
        void _addItem() {
          showDialog<ShoppingItem>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => ShoppingItemDetailWidget(),
          ).then((ShoppingItem newItem) {
            if (newItem != null) {
              viewModel.onAddShoppingItem(newItem);
            }
          });
        }

        double _totalPrice(List<ShoppingItem> items) {
          double total = 0.0;

          for (ShoppingItem item in items) {
            total += item.numUnit * item.unitPrice;
          }
          return total;
        }

        final appBar = AppBar(
          title: Text(
              'Total: \$${_totalPrice(viewModel.items).toStringAsFixed(1)}'),
          actions: <Widget>[
            IconButton(
              icon: Icon(Icons.delete),
              onPressed: viewModel.onDelAllShoppingItem,
            ),
          ],
        );

        final body = ShoppingItemListWidget(
          shoppingItems: viewModel.items,
          onIncNumUnit: (ShoppingItem item) {
            viewModel.onUpdateShoppingItem(
                item.id, item.copyWith(numUnit: item.numUnit + 1));
          },
          onDecNumUnit: (ShoppingItem item) {
            viewModel.onUpdateShoppingItem(
                item.id, item.copyWith(numUnit: item.numUnit - 1));
          },
          onUpdate: (ShoppingItem item) {
            viewModel.onUpdateShoppingItem(item.id, item.copyWith());
          },
          onRemove: (ShoppingItem item) {
            viewModel.onDelShoppingItem(item.id);
          },
          scrollController: _scrollController,
        );

        return Scaffold(
          appBar: appBar,
          body: body,
          floatingActionButton: _showFAB
              ? FloatingActionButton(
                  onPressed: _addItem,
                  child: Icon(Icons.add),
                )
              : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
        );
      },
    );
  }
}

class _ViewModel {
  final List<ShoppingItem> items;
  final Function(ShoppingItem) onAddShoppingItem;
  final Function(String) onDelShoppingItem;
  final Function(String, ShoppingItem) onUpdateShoppingItem;
  final Function() onDelAllShoppingItem;

  _ViewModel({
    this.items,
    this.onAddShoppingItem,
    this.onDelShoppingItem,
    this.onUpdateShoppingItem,
    this.onDelAllShoppingItem,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
      items: shoppingItemsSelector(store.state),
      onAddShoppingItem: (ShoppingItem item) {
        store.dispatch(AddShoppingItemAction(
          item: item,
        ));
      },
      onDelShoppingItem: (String id) {
        store.dispatch(DelShoppingItemAction(
          id: id,
        ));
      },
      onUpdateShoppingItem: (String id, ShoppingItem item) {
        store.dispatch(UpdateShoppingItemAction(
          id: id,
          item: item,
        ));
      },
      onDelAllShoppingItem: () {
        store.dispatch(DelAllShoppingItemsAction());
      },
    );
  }
}
