import 'package:equatable/equatable.dart';

class RackModel extends Equatable {
  final String? lokasi;

  const RackModel({
    required this.lokasi,
  });

  factory RackModel.fromJson(Map<String, dynamic> json) {
    return RackModel(lokasi: json['LOKASI'].toString());
  }

  Map<String, dynamic> toJson() {
    return {
      'LOKASI': lokasi,
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [lokasi];
}
