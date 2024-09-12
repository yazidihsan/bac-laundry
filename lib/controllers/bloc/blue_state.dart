// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'blue_bloc.dart';

class BlueState extends Equatable {
  const BlueState({required this.bluetooths});

  final List<Bluetooth> bluetooths;

  factory BlueState.initial() {
    return BlueState(bluetooths: <Bluetooth>[]);
  }

  BlueState copyWith({required List<Bluetooth> bluetooths}) {
    return BlueState(bluetooths: bluetooths);
  }

  @override
  List<Object> get props => [bluetooths];
}
