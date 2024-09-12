import 'package:equatable/equatable.dart';

class Scan extends Equatable {
  final String? date;
  final String? rfid;
  final String? activity;
  final int? activityId;

  const Scan(
      {required this.activityId,
      required this.date,
      required this.rfid,
      required this.activity});

  factory Scan.fromJson(Map<String, dynamic> json) {
    return Scan(
        date: json['date'],
        rfid: json['rfid'],
        activity: json['activity'],
        activityId: json['activity_id']);
  }

  Map<String, dynamic> toJson() {
    return {
      'activity_id': activityId,
      'rfid': rfid,
    };
  }

  @override
  List<Object?> get props => [date, rfid, activity];
}
