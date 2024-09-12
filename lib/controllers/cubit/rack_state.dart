part of 'rack_cubit.dart';

sealed class RackState extends Equatable {
  const RackState();

  @override
  List<Object> get props => [];
}

final class RackInitial extends RackState {}

final class RackLoading extends RackState {}

final class RackSuccess extends RackState {
  final List<RackModel> listRack;

  const RackSuccess({required this.listRack});

  @override
  List<Object> get props => [listRack];
}

final class RackFailed extends RackState {
  final String errorMessage;

  const RackFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
