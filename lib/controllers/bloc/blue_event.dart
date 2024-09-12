part of 'blue_bloc.dart';

abstract class BlueEvent extends Equatable {
  const BlueEvent();

  @override
  List<Object> get props => [];
}

class AddBluetooth extends BlueEvent {
  final Bluetooth bluetooth;

  const AddBluetooth({required this.bluetooth});

  @override
  List<Object> get props => [bluetooth];
}
