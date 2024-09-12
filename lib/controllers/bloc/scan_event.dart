part of 'scan_bloc.dart';

sealed class ScanEvent extends Equatable {
  const ScanEvent();

  @override
  List<Object> get props => [];
}

final class ScanFetchEvent extends ScanEvent {}
