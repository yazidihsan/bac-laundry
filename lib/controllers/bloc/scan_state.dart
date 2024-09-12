part of 'scan_bloc.dart';

sealed class ScanState extends Equatable {
  const ScanState();

  @override
  List<Object> get props => [];
}

final class ScanInitial extends ScanState {}

final class ScanLoading extends ScanState {}

final class ScanSuccess extends ScanState {
  final List<Scan> scan;
  const ScanSuccess({required this.scan});
}

final class ScanFailure extends ScanState {
  final String errorMessage;

  const ScanFailure({required this.errorMessage});
}
