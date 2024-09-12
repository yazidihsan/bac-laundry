import 'package:bloc/bloc.dart';
import 'package:bt_handheld/models/bluetooth.dart';
import 'package:equatable/equatable.dart';

part 'blue_event.dart';
part 'blue_state.dart';

class BlueBloc extends Bloc<BlueEvent, BlueState> {
  BlueBloc() : super(BlueState.initial()) {
    on<AddBluetooth>((event, emit) {
      var bluetooths = state.bluetooths;
      var seen = <String>{};

      bluetooths.add(event.bluetooth);

      final fixBluetooths = bluetooths
          .where((element) => seen.add(element.address ?? ''))
          .toList();

      emit(state.copyWith(bluetooths: fixBluetooths));
    });
  }
}
