part of 'activities_bloc.dart';

// abstract class ActivitiesState extends Equatable {
//   const ActivitiesState();

//   @override
//   List<Object> get props => [];
// }

@immutable
sealed class ActivitiesState {}

final class ActivitiesInitial extends ActivitiesState {}

final class ActivitiesLoading extends ActivitiesState {}

final class ActivitiesSuccess extends ActivitiesState {
  final List<Activities> activities;
  ActivitiesSuccess({required this.activities});

  // @override
  // List<Object> get props => [activities];
}

final class ActivitiesFailure extends ActivitiesState {
  final String errorMessage;

  ActivitiesFailure({
    required this.errorMessage,
  });
  // @override
  // List<Object> get props => [errorMessage];
}
