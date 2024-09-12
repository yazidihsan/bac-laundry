import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class Activities extends Equatable {
  final int? id;
  final String? name;
  final Widget? icon;

  const Activities({required this.id, required this.name, this.icon});

  factory Activities.fromJson(Map<String, dynamic> json) {
    return Activities(id: json['id'], name: json['name']);
  }

  @override
  List<Object?> get props => [id, name, icon];
}
