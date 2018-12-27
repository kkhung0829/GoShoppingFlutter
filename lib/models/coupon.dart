import 'package:meta/meta.dart';
import 'package:uuid/uuid.dart';
import 'package:json_annotation/json_annotation.dart';

part 'coupon.g.dart';

@JsonSerializable()
@immutable
class Coupon {
  final String id;
  final String name;
  final int numUnit;
  final DateTime startDate;
  final DateTime endDate;

  Coupon({
    this.name = '',
    this.numUnit = 0,
    this.startDate,
    this.endDate,
    String id,
  }) : this.id = id ?? new Uuid().v4();

  Coupon copyWith({
    String id,
    String name,
    int numUnit,
    DateTime startDate,
    DateTime endDate,
  }) => Coupon(
    id: id ?? this.id,
    name: name ?? this.name,
    numUnit: numUnit ?? this.numUnit,
    startDate: startDate ?? this.startDate,
    endDate: endDate ?? this.endDate,
  );

  factory Coupon.fromJson(Map<String, dynamic> json) => _$CouponFromJson(json);
  Map<String, dynamic> toJson() => _$CouponToJson(this);
}