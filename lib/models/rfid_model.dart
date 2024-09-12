import 'package:equatable/equatable.dart';

class RfidModel extends Equatable {
  final String? epc;
  final String? nomorKotak;
  final String? kodePelanggan;
  final String? nomorSuratJalan;
  final String? status;
  final String? kodeKotak;
  final String? kontainer;

  const RfidModel(
      {this.epc,
      this.nomorKotak,
      this.kodePelanggan,
      this.nomorSuratJalan,
      this.status,
      this.kodeKotak,
      this.kontainer});

  factory RfidModel.fromJson(Map<String, dynamic> json) {
    return RfidModel(
        epc: json['EPC'].toString(),
        nomorKotak: json['NOMKOT'].toString(),
        kodePelanggan: json['KODPLG'].toString(),
        nomorSuratJalan: json['NO_SJTT'].toString(),
        status: json['status'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'EPC': [epc],
      'NOMKOT': [nomorKotak],
      // 'KODPLG': [kodePelanggan],
      // 'NO_SJTT': [nomorSuratJalan],
      // 'KODKOT': [kodeKotak],
      'KONTAINER': kontainer
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props =>
      [epc, nomorKotak, kodePelanggan, nomorSuratJalan, status];
}
