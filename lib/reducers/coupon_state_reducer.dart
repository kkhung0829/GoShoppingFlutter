import 'package:redux/redux.dart';
import '../actions/actions.dart';
import '../models/models.dart';

final couponStateReducer = combineReducers<CouponState>([
  TypedReducer<CouponState, AddCouponAction>(_addCoupon),
  TypedReducer<CouponState, DelCouponAction>(_delCoupon),
  TypedReducer<CouponState, UpdateCouponAction>(_updateCoupon),
  TypedReducer<CouponState, DelAllCouponsAction>(_delAllCoupon),
  TypedReducer<CouponState, SyncCouponStateFromCloudAction>(_syncCouponStateFromCloud),
]);

CouponState _addCoupon(CouponState state, AddCouponAction action) =>
  state.copyWith(
    coupons: List.from(state.coupons)
              ..add(action.coupon.copyWith()),
  );

CouponState _delCoupon(CouponState state, DelCouponAction action) =>
  state.copyWith(
    coupons: state.coupons.where(
      (coupon) => coupon.id != action.id
    ).toList(),
  );

CouponState _updateCoupon(CouponState state, UpdateCouponAction action) =>
  state.copyWith(
    coupons: state.coupons.map(
      (coupon) => coupon.id == action.id ? action.coupon.copyWith() : coupon
    ).toList(),
  );

CouponState _delAllCoupon(CouponState state, DelAllCouponsAction action) =>
  state.copyWith(
    coupons: const [],
  );

CouponState _syncCouponStateFromCloud(CouponState state, SyncCouponStateFromCloudAction action) =>
  action.state;