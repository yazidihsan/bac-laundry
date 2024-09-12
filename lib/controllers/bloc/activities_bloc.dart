import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:bt_handheld/models/activities.dart';
import 'package:bt_handheld/controllers/services/dio_client.dart';
import 'package:flutter/material.dart';

part 'activities_event.dart';
part 'activities_state.dart';

class ActivitiesBloc extends Bloc<ActivitiesEvent, ActivitiesState> {
  ActivitiesBloc() : super(ActivitiesInitial()) {
    on<ActivitiesFetchEvent>(onActivitiesFetchEvent);
  }
  FutureOr<void> onActivitiesFetchEvent(
      ActivitiesFetchEvent event, Emitter<ActivitiesState> emit) async {
    emit(ActivitiesLoading());
    try {
      var client = DioClient();
      await client.dio.get('api/v1/activities').then((value) {
        List<Activities> activities = (value.data["data"] as List<dynamic>)
            .map((x) => Activities.fromJson(x))
            .toList();
        emit(ActivitiesSuccess(activities: activities));
      }).catchError((error) {
        emit(ActivitiesFailure(errorMessage: error.toString()));
      });
    } catch (e) {
      emit(ActivitiesFailure(errorMessage: e.toString()));
    }
  }

  // @override
  // Stream<ActivitiesState> mapEventToState(ActivitiesEvent event) async* {
  //   if (event is ActivitiesRequested) {
  //     yield ActivitiesLoading();
  //     try {
  //       final response =
  //           await dio.get('${ValueManager.baseUrl}/api/v1/activities');
  //       yield ActivitiesSuccess(List<Activities>.from(
  //           response.data.map((x) => Activities.fromJson(x))));
  //     } catch (_) {
  //       yield ActivitiesFailure();
  //     }
  //   }
  // }
}
