import 'package:bloc/bloc.dart';
import 'package:bt_handheld/controllers/services/stock_opname_service.dart';
import 'package:bt_handheld/models/rack_model.dart';
import 'package:equatable/equatable.dart';

part 'rack_state.dart';

class RackCubit extends Cubit<RackState> {
  final StockOpnameService service;

  RackCubit(this.service) : super(RackInitial());

  void getAllRack() async {
    emit(RackLoading());
    final result = await service.getAllRack();
    result.fold((errorMessage) => emit(RackFailed(errorMessage: errorMessage)),
        (listRack) => emit(RackSuccess(listRack: listRack)));
  }
}
