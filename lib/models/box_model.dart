import 'package:equatable/equatable.dart';

// ignore: must_be_immutable
class BoxModel extends Equatable {
  final String? lokasi;
  final String? lokasiRak;
  final String? nomkot;
  final String? epc;
  String? rfid;
  String? status;

  BoxModel({
    required this.lokasiRak,
    required this.nomkot,
    required this.epc,
    String rfid = '',
    this.status,
    required this.lokasi,
  });

  factory BoxModel.fromJson(Map<String, dynamic> json) {
    return BoxModel(
      lokasi: json['LOKASI'],
      lokasiRak: json['LOKASIRAK'],
      nomkot: json['NOMKOT'],
      epc: json['EPC'],
    );
    // status: json['STATUS']);
  }

  Map<String, dynamic> toJson() {
    return {
      'LOKASI': lokasi,
      'LOKASIRAK': lokasiRak,
      'NOMKOT': nomkot,
      'EPC': epc,
      'STATUS': status,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [lokasi];
}
