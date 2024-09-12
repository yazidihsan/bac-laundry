part of 'box_cubit.dart';

sealed class BoxState extends Equatable {
  const BoxState();

  @override
  List<Object> get props => [];
}

final class BoxInitial extends BoxState {}

final class BoxLoading extends BoxState {}

final class BoxSuccess extends BoxState {
  final List<BoxModel> listBox;
  // final List<String> data;

  const BoxSuccess(
      {
      // required this.data,

      required this.listBox});

  @override
  List<Object> get props => [listBox];
}

final class BoxFailed extends BoxState {
  final String errorMessage;

  const BoxFailed({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
