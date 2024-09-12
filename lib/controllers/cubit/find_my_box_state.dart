part of 'find_my_box_cubit.dart';

sealed class FindMyBoxState extends Equatable {
  const FindMyBoxState();

  @override
  List<Object> get props => [];
}

final class FindMyBoxInitial extends FindMyBoxState {}

final class FindMyBoxLoading extends FindMyBoxState {}

final class FindMyBoxSuccess extends FindMyBoxState {
  final List<FindBoxModel> foundEpc;

  const FindMyBoxSuccess({required this.foundEpc});
  @override
  List<Object> get props => [foundEpc];
}

final class FindMyBoxFailed extends FindMyBoxState {
  final String message;

  const FindMyBoxFailed({required this.message});
  @override
  List<Object> get props => [message];
}
