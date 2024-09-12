import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'rfid_event.dart';
part 'rfid_state.dart';

class RfidBloc extends Bloc<RfidEvent, RfidState> {
  RfidBloc() : super(RfidState.initial()) {
    on<AddRfid>((event, emit) {
      final rfids = state.rfids;

      rfids.add(event.rfid);

      final fixRfids = rfids.toSet().toList();

      emit(state.copyWith(rfids: fixRfids));
    });
  }
}
