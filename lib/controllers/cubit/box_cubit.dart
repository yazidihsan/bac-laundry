import 'package:bloc/bloc.dart';
import 'package:bt_handheld/controllers/services/dio_client.dart';
import 'package:bt_handheld/controllers/services/stock_opname_service.dart';
import 'package:bt_handheld/models/box_model.dart';
import 'package:equatable/equatable.dart';

part 'box_state.dart';

class BoxCubit extends Cubit<BoxState> {
  final StockOpnameService service;
  // List<String> _rfids = [];
  BoxCubit(this.service) : super(BoxInitial());

  // List<String> get rfids => List.castFrom(_rfids);

  void locationBoxes(Map<String, dynamic> bodyReq) async {
    emit(BoxLoading());
    // _rfids.add(rfid);
    // _rfids = _rfids.toSet().toList();

    final result = await service.locationBoxes(bodyReq);
    result.fold((errorMessage) => emit(BoxFailed(errorMessage: errorMessage)),
        (listBox) => emit(BoxSuccess(listBox: listBox)));
  }

  // void addRfid(String rfid) {
  //   try {
  //     // Add the RFID to the list and remove duplicates
  //     //
  //     _rfids.add(rfid);
  //     _rfids = _rfids.toSet().toList(); // Remove duplicates

  //     // Emit success state with updated RFID list
  //     emit(BoxSuccess(listBox: const [], data: _rfids));
  //   } catch (e) {
  //     emit(BoxFailed(errorMessage: e.toString()));
  //   }
  // }
}
