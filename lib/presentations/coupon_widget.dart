import 'package:flutter/material.dart';
import 'package:simple_moment/simple_moment.dart';
import 'package:intl/intl.dart';
import 'package:auto_size_text/auto_size_text.dart';

import '../models/models.dart';
import 'coupon_detail_widget.dart';

enum CouponType { expired, current, future }
typedef CouponWidget_OnUpdate = void Function(Coupon coupon);

final _now = DateTime.now();
final _nowDate = DateTime(_now.year, _now.month, _now.day);

class CouponWidget extends StatelessWidget {
  final dateFormater = new DateFormat('yyyy-MM-dd');

  final Coupon coupon;
  final CouponType type;
  final CouponWidget_OnUpdate onUpdate;

  CouponWidget({
    Key key,
    this.coupon,
    this.type,
    this.onUpdate,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String subTitleStr;

    switch (type) {
      case CouponType.expired:
        subTitleStr =
            'Expiried ' + Moment.fromDate(coupon.endDate).from(_nowDate) + ' - ' + dateFormater.format(coupon.endDate);
        break;

      case CouponType.current:
        if (coupon.endDate == _nowDate) {
          subTitleStr = 'Expire Today ' + ' - ' + dateFormater.format(coupon.endDate);
        } else {
        subTitleStr = 'Expiry ' + Moment.fromDate(_nowDate).from(coupon.endDate) + ' - ' + dateFormater.format(coupon.endDate);
        }
        break;

      case CouponType.future:
        subTitleStr =
            'Start ' + Moment.fromDate(_nowDate).from(coupon.startDate) + ' - ' + dateFormater.format(coupon.startDate);
        break;

      default:
        subTitleStr = 'Unknown';
    }

    final details = ListTile(
      title: AutoSizeText(coupon.name, maxLines: 1, overflow: TextOverflow.ellipsis),
      subtitle: Text(subTitleStr),
    );

    final output = GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      onTap: () {
        showDialog<Coupon>(
          context: context,
          barrierDismissible: false,
          builder: (BuildContext context) =>
            CouponDetailWidget(coupon: coupon),
        ).then((Coupon updatedCoupon) {
          if (updatedCoupon != null) {
            onUpdate(updatedCoupon);
          }
        });
      },
      child: Card(
        child: Column(
          children: <Widget>[
            details,
          ],
        ),
      ),
    );

    return output;
  }
}
