import 'package:bt_handheld/models/box_model.dart';
import 'package:equatable/equatable.dart';

class StockResultModel extends Equatable {
  final List<BoxModel> boxes;
  final String? status;
  final String? data;

  const StockResultModel({this.status, required this.boxes, this.data});

  // factory StockResultModel.fromJson(Map<String, dynamic> json) {
  //   return StockResultModel(
  //     data: json['data'].toString(),
  //   );
  // }

  Map<String, dynamic> toJson() {
    return {
      'data': boxes.map((e) => e.toJson()).toList(),
    };
  }

  @override
  // TODO: implement props
  List<Object?> get props => [boxes, status, data];
}

class RequestBody {
  List<BoxModel> data;

  RequestBody({required this.data});

  // Convert the RequestBody object into a JSON map
  Map<String, dynamic> toJson() {
    return {
      'data': data.map((item) => item.toJson()).toList(),
    };
  }
}
