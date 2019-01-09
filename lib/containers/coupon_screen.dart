import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:intl/intl.dart';
import 'package:unicorndial/unicorndial.dart';

import 'package:flutter/services.dart';
import 'package:flutter_calendar_util/flutter_calendar_util.dart' as FlutterCalendarUtil;

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

const CALENDAR_NAME = "GoShopping";

class _CouponScreenState extends State<CouponScreen> {
  final _dateFormater = new DateFormat('yyyy-MM-dd');
  ScrollController _scrollController = ScrollController();
  bool _showFAB = true;
  FlutterCalendarUtil.FlutterCalendarUtil _flutterCalendarUtil = new FlutterCalendarUtil.FlutterCalendarUtil();

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

        void _deleteCalendar() async {
          try {
            var permissionsGranted = await _flutterCalendarUtil.hasPermissions();
            if (permissionsGranted.isSuccess && !permissionsGranted.data) {
              permissionsGranted = await _flutterCalendarUtil.requestPermissions();
              if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
                return;
              }
            }

            var deleteResult = await _flutterCalendarUtil.deleteCalendar(CALENDAR_NAME);
            print('Delete calendar result: ${deleteResult.data}');

          } on PlatformException catch (e) {
            print(e);
          }
        }

        Future _addExpireEvent4Coupon(String calendarId, List<Coupon> coupons) async {
          try {
            await Future.forEach(coupons, (coupon) async {
              var event = FlutterCalendarUtil.Event(
                calendarId,
                title: coupon.name + ' Expire !!!',
                start: coupon.endDate,
                end: coupon.endDate,
              );
              var createResult = await _flutterCalendarUtil.createOrUpdateEvent(event);
              print('Expirer Event[${createResult.data}] for coupon ${coupon.name} added');
            });
          } on PlatformException catch (e) {
            print(e);
          }
        }

        Future _addStartEvent4Coupon(String calendarId, List<Coupon> coupons) async {
          try {
            await Future.forEach(coupons, (coupon) async {
              var event = FlutterCalendarUtil.Event(
                calendarId,
                title: coupon.name + ' Start !!!',
                start: coupon.startDate,
                end: coupon.startDate,
              );
              var createResult = await _flutterCalendarUtil.createOrUpdateEvent(event);
              print('Start Event[${createResult.data}] for coupon ${coupon.name} added');
            });
          } on PlatformException catch (e) {
            print(e);
          }
        }

        Future _refreshCalendarEvent() async {
          try {
            var permissionsGranted = await _flutterCalendarUtil.hasPermissions();
            if (permissionsGranted.isSuccess && !permissionsGranted.data) {
              permissionsGranted = await _flutterCalendarUtil.requestPermissions();
              if (!permissionsGranted.isSuccess || !permissionsGranted.data) {
                return;
              }
            }

            var deleteResult = await _flutterCalendarUtil.deleteCalendar(CALENDAR_NAME);
            print('Delete calendar result: ${deleteResult.data}');

            var calendarIdResult = await _flutterCalendarUtil.createCalendar(CALENDAR_NAME);
            print('New Calendar id: [${calendarIdResult.data}]');

            print('Create events for ${viewModel.currentCoupons.length} current coupons');
            await _addExpireEvent4Coupon(calendarIdResult.data, viewModel.currentCoupons);

            print('Create events for ${viewModel.futureCoupons.length} future coupons');
            await _addStartEvent4Coupon(calendarIdResult.data, viewModel.futureCoupons);
          } on PlatformException catch (e) {
            print(e);
          }

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

        final fabAdd = FloatingActionButton(
          heroTag: null,
          onPressed: _addCoupon,
          child: Icon(Icons.add),
        );

        final fabCalendar = UnicornDialer(
          parentButton: Icon(Icons.calendar_today),
          childButtons: <UnicornButton>[
            UnicornButton(
              currentButton: FloatingActionButton(
                heroTag: null,
                mini: true,
                child: Icon(Icons.delete),
                onPressed: () {
                  _deleteCalendar();
                },
              ),
            ),
            UnicornButton(
              currentButton: FloatingActionButton(
                heroTag: null,
                mini: true,
                child: Icon(Icons.refresh),
                onPressed: () async {
                  Scaffold.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: <Widget>[
                          CircularProgressIndicator(),
                          Text("Updating device calendar..."),
                        ],
                      ),
                    )
                  );

                  await _refreshCalendarEvent();

                  await Future.delayed(Duration(seconds: 3));
                  Scaffold.of(context).removeCurrentSnackBar();
                },
              ),
            ),
          ],
        );

        final fab = Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: <Widget>[
            fabAdd,
            fabCalendar,
          ],
        );

        return Scaffold(
          appBar: appBar,
          body: body,
          floatingActionButton: _showFAB ? fab : Container(),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
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
