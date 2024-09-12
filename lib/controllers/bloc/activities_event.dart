part of 'activities_bloc.dart';

@immutable
sealed class ActivitiesEvent {}

final class ActivitiesFetchEvent extends ActivitiesEvent {}
// abstract class ActivitiesEvent extends Equatable {
//   const ActivitiesEvent();

//   @override
//   List<Object> get props => [];
// }

// class ActivitiesRequested extends ActivitiesEvent {}
