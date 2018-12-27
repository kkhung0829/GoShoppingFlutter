import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';
import '../selectors/selectors.dart';
import '../actions/actions.dart';
import '../presentations/presentations.dart';

class CouponScreen extends StatefulWidget {
  CouponScreen({
    Key key,
  }) : super(key: key);

  _CouponScreenState createState() => _CouponScreenState();
}

class _CouponScreenState extends State<CouponScreen> {
  final _dateFormater = new DateFormat('yyyy-MM-dd');
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
        void _addCoupon() {
          showDialog<Coupon>(
            context: context,
            barrierDismissible: false,
            builder: (BuildContext context) => CouponDetailWidget(),
          ).then((Coupon newCoupon) {
            if (newCoupon != null) {
              viewModel.onAddCoupon(newCoupon);
            }
          });
        }

        final appBar = AppBar(
          title: Text('Today: ' + _dateFormater.format(DateTime.now())),
        );

        final body = ListView(
          controller: _scrollController,
          children: <Widget>[
            CouponListWidget(
              type: CouponType.expired,
              coupons: viewModel.expiredCoupons,
              onUpdate: (Coupon coupon) {
                viewModel.onUpdateCoupon(coupon.id, coupon);
              },
              onRemove: (Coupon coupon) {
                viewModel.onDelCoupon(coupon.id);
              },
              initiallyExpanded: viewModel.expiredCoupons.length > 0,
            ),
            CouponListWidget(
              type: CouponType.current,
              coupons: viewModel.currentCoupons,
              onUpdate: (Coupon coupon) {
                viewModel.onUpdateCoupon(coupon.id, coupon);
              },
              onRemove: (Coupon coupon) {
                viewModel.onDelCoupon(coupon.id);
              },
              initiallyExpanded: viewModel.currentCoupons.length > 0,
            ),
            CouponListWidget(
              type: CouponType.future,
              coupons: viewModel.futureCoupons,
              onUpdate: (Coupon coupon) {
                viewModel.onUpdateCoupon(coupon.id, coupon);
              },
              onRemove: (Coupon coupon) {
                viewModel.onDelCoupon(coupon.id);
              },
              initiallyExpanded: viewModel.futureCoupons.length > 0,
            ),
          ],
        );

        return Scaffold(
          appBar: appBar,
          body: body,
          floatingActionButton: _showFAB
              ? FloatingActionButton(
                  onPressed: _addCoupon,
                  child: Icon(Icons.add),
                )
              : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.endFloat,
        );
      },
    );
  }
}

class _ViewModel {
  final List<Coupon> expiredCoupons;
  final List<Coupon> currentCoupons;
  final List<Coupon> futureCoupons;
  final Function(Coupon) onAddCoupon;
  final Function(String) onDelCoupon;
  final Function(String, Coupon) onUpdateCoupon;
  final Function() onDelAllCoupon;

  _ViewModel({
    this.expiredCoupons,
    this.currentCoupons,
    this.futureCoupons,
    this.onAddCoupon,
    this.onDelCoupon,
    this.onUpdateCoupon,
    this.onDelAllCoupon,
  });

  static _ViewModel fromStore(Store<AppState> store) {
    return new _ViewModel(
        expiredCoupons: expiredCouponsSelector(store.state),
        currentCoupons: currentCouponsSelector(store.state),
        futureCoupons: futureCouponsSelector(store.state),
        onAddCoupon: (Coupon coupon) {
          store.dispatch(AddCouponAction(
            coupon: coupon,
          ));
        },
        onDelCoupon: (String id) {
          store.dispatch(DelCouponAction(
            id: id,
          ));
        },
        onUpdateCoupon: (String id, Coupon coupon) {
          store.dispatch(UpdateCouponAction(
            id: id,
            coupon: coupon,
          ));
        },
        onDelAllCoupon: () {
          store.dispatch(DelAllCouponsAction());
        });
  }
}
