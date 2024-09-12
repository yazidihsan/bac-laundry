// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

part of 'rfid_bloc.dart';

class RfidState extends Equatable {
  const RfidState({required this.rfids});

  final List<String> rfids;

  factory RfidState.initial() {
    return RfidState(rfids: <String>[]);
  }

  RfidState copyWith({required List<String> rfids}) {
    return RfidState(rfids: rfids);
  }

  @override
  List<Object> get props => [rfids];
}
