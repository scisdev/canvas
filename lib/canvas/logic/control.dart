import 'package:flutter_bloc/flutter_bloc.dart';

enum ControlState {
  camera,
  draw,
}

class ControlCubit extends Cubit<ControlState> {
  ControlCubit() : super(ControlState.camera);

  void toggleState() {
    if (state == ControlState.camera) {
      emit(ControlState.draw);
    } else {
      emit(ControlState.camera);
    }
  }
}
