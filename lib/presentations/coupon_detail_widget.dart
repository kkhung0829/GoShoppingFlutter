import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../models/models.dart';

final _now = DateTime.now();
final _nowDate = DateTime(_now.year, _now.month, _now.day);
final _tomorrowDate = _nowDate.add(Duration(days: 1));

class CouponDetailWidget extends StatefulWidget {
  final Coupon coupon;
  final bool isEdit;

  CouponDetailWidget({
    Key key,
    Coupon coupon,
  })  : this.isEdit = (coupon != null),
        this.coupon = coupon ??
            Coupon(
              startDate: _nowDate,
              endDate: _tomorrowDate,
            ),
        super(key: key);

  @override
  _CouponDetailWidgetState createState() => _CouponDetailWidgetState();
}

class _CouponDetailWidgetState extends State<CouponDetailWidget> {
  final dateFormater = new DateFormat('yyyy-MM-dd');

  TextEditingController _tcName;
  TextEditingController _tcNumUnit;
  DateTime _startDate;
  DateTime _endDate;

  @override
  void initState() {
    super.initState();

    _tcName = TextEditingController(
      text: widget.coupon.name.toString(),
    );
    _tcNumUnit = TextEditingController(
      text: widget.coupon.numUnit.toString(),
    );
    _startDate = widget.coupon.startDate;
    _endDate = widget.coupon.endDate;
  }

  @override
  void dispose() {
    super.dispose();

    _tcName.dispose();
    _tcNumUnit.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final title =
        Center(child: widget.isEdit ? Text('Edit Coupon') : Text('Add Coupon'));

    final content = Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        TextField(
          controller: _tcName,
          decoration: InputDecoration(labelText: 'Name'),
          keyboardType: TextInputType.text,
        ),
        TextField(
          controller: _tcNumUnit,
          decoration: InputDecoration(labelText: 'Num Unit'),
          keyboardType: TextInputType.number,
        ),
        FlatButton(
          child: Text('Start: ' + dateFormater.format(_startDate)),
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: _startDate,
              firstDate: DateTime.now().add(Duration(days: -3650)),
              lastDate: DateTime.now().add(Duration(days: 3650)),
            ).then((newDate) {
              if (newDate != null) {
                setState(() {
                  _startDate = newDate;
                });
              }
            });
          },
        ),
        FlatButton(
          child: Text('Expiry: ' + dateFormater.format(_endDate)),
          onPressed: () {
            showDatePicker(
              context: context,
              initialDate: _endDate,
              firstDate: DateTime.now().add(Duration(days: -3650)),
              lastDate: DateTime.now().add(Duration(days: 3650)),
            ).then((newDate) {
              if (newDate != null) {
                setState(() {
                  _endDate = newDate;
                });
              }
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            FlatButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.pop(context, null);
              },
            ),
            FlatButton(
              child: const Text('Save'),
              onPressed: () {
                Navigator.pop(
                  context,
                  widget.coupon.copyWith(
                    name: _tcName.text,
                    numUnit: int.parse(_tcNumUnit.text),
                    startDate: _startDate,
                    endDate: _endDate,
                  ),
                );
              },
            ),
          ],
        ),
      ],
    );

    return AlertDialog(
      title: title,
      content: content,
    );
  }
}
