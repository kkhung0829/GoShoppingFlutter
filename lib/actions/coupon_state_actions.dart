import '../models/models.dart';
import 'package:meta/meta.dart';

class AddCouponAction {
  final Coupon coupon;

  AddCouponAction({
    @required this.coupon,
  });
}

class DelCouponAction {
  final String id;

  DelCouponAction({
    @required this.id,
  });
}

class UpdateCouponAction {
  final String id;
  final Coupon coupon;

  UpdateCouponAction({
    @required this.id,
    @required this.coupon,
  });
}

class DelAllCouponsAction {}