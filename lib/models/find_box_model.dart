import 'package:equatable/equatable.dart';

class FindBoxModel extends Equatable {
  final String? epc;
  final String? nomorKotak;

  const FindBoxModel({required this.epc, this.nomorKotak});

  factory FindBoxModel.fromJson(Map<String, dynamic> json) {
    return FindBoxModel(epc: json['EPC']);
  }

  Map<String, dynamic> toJson() {
    return {'nomkot': nomorKotak};
  }

  @override
  // TODO: implement props
  List<Object?> get props => [];
}
