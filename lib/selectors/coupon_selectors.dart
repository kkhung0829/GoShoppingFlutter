import 'package:reselect/reselect.dart';
import '../models/models.dart';

final couponStateSelector = (AppState state) => state.couponState;

final couponsSelector = createSelector1(
  couponStateSelector,
  (couponState) => couponState.coupons,
);

final _now = DateTime.now();
final _nowDate = DateTime(_now.year, _now.month, _now.day);

final expiredCouponsSelector = createSelector1(
  couponsSelector,
  (coupons) =>
    coupons.where((Coupon coupon) =>
      coupon.endDate.isBefore(_nowDate)
    ).toList()
      ..sort((Coupon a, Coupon b) =>
        a.endDate.compareTo(b.endDate)
      ),
);

final futureCouponsSelector = createSelector1(
  couponsSelector,
  (coupons) =>
    coupons.where((Coupon coupon) =>
      coupon.startDate.isAfter(_nowDate)
    ).toList()
      ..sort((Coupon a, Coupon b) =>
        a.startDate.compareTo(b.startDate)
      ),
);

final currentCouponsSelector = createSelector1(
  couponsSelector,
  (coupons) =>
    coupons.where((Coupon coupon) =>
      !coupon.startDate.isAfter(_nowDate) && !coupon.endDate.isBefore(_nowDate)
    ).toList()
      ..sort((Coupon a, Coupon b) =>
        a.endDate.compareTo(b.endDate)
      ),
);
