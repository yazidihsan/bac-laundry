import 'package:bloc/bloc.dart';
import 'package:bt_handheld/controllers/services/find_my_box_service.dart';
import 'package:bt_handheld/models/find_box_model.dart';
import 'package:equatable/equatable.dart';

part 'find_my_box_state.dart';

class FindMyBoxCubit extends Cubit<FindMyBoxState> {
  final FindMyBoxService service;
  FindMyBoxCubit(this.service) : super(FindMyBoxInitial());

  void myDesiredEpc(String nomkot) async {
    emit(FindMyBoxLoading());

    final result = await service.desiredEpc(nomkot);

    result.fold((errorMessage) => emit(FindMyBoxFailed(message: errorMessage)),
        (desiredEpc) => emit(FindMyBoxSuccess(foundEpc: desiredEpc)));
  }
}
