import 'package:bloc/bloc.dart';
import 'package:bt_handheld/controllers/services/stock_opname_service.dart';
import 'package:equatable/equatable.dart';

part 'stock_state.dart';

class StockCubit extends Cubit<StockState> {
  final StockOpnameService service;
  StockCubit(this.service) : super(StockInitial());

  void stockResult(Map<String, dynamic> stock) async {
    emit(StockLoading());
    final result = await service.stockOpnameResult(stock);
    result.fold((errorMessage) => emit(StockFailed(message: errorMessage)),
        (message) => emit(StockSuccess(message: message)));
  }
}
