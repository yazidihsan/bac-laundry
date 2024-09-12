import 'package:equatable/equatable.dart';

class Bluetooth extends Equatable {
  final String? name;
  final String? address;

  const Bluetooth({required this.name, required this.address});

  factory Bluetooth.fromJson(Map<String, dynamic> json) {
    return Bluetooth(name: json['name'], address: json['address']);
  }

  @override
  List<Object?> get props => [name, address];
}
