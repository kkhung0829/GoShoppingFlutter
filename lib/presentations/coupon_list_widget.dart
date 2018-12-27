import 'package:flutter/material.dart';

import '../models/models.dart';
import 'coupon_widget.dart';

typedef CouponListWidget_OnRemove = Function(Coupon);

class CouponListWidget extends StatelessWidget {
  final CouponType type;
  final List<Coupon> coupons;
  final CouponWidget_OnUpdate onUpdate;
  final CouponListWidget_OnRemove onRemove;
  final bool initiallyExpanded;

  CouponListWidget({
    Key key,
    this.type,
    this.coupons,
    this.onUpdate,
    this.onRemove,
    this.initiallyExpanded,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String titleStr;

    switch (type) {
      case CouponType.current:
        titleStr = coupons.length.toString() + ' Current';
        break;

      case CouponType.expired:
        titleStr = coupons.length.toString() + ' Expired';
        break;

      case CouponType.future:
        titleStr = coupons.length.toString() + ' Future';
        break;

      default:
        titleStr = 'Unknown';
    }

    final title = Text(titleStr);

    final children = coupons
        .map(
          (coupon) => Dismissible(
            key: Key(coupon.id),
            onDismissed: (direction) => onRemove(coupon),
            child: CouponWidget(
              coupon: coupon,
              type: type,
              onUpdate: onUpdate,
            ),
          ),
        )
        .toList();

    final output = ExpansionTile(
      title: title,
      children: children,
      initiallyExpanded: initiallyExpanded,
    );

    return output;
  }
}
