part of 'rfid_bloc.dart';

abstract class RfidEvent extends Equatable {
  const RfidEvent();

  @override
  List<Object> get props => [];
}

class AddRfid extends RfidEvent {
  final String rfid;

  const AddRfid({required this.rfid});

  @override
  List<Object> get props => [rfid];
}
