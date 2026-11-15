import 'package:flutter_bloc/flutter_bloc.dart';
import '../models/hasil_deteksi.dart';
import 'deteksi_event.dart';
import 'deteksi_state.dart';

class DeteksiBloc extends Bloc<DeteksiEvent, DeteksiState> {
  DeteksiBloc() : super(const DeteksiState()) {
    on<TambahDeteksiEvent>(_onTambahDeteksi);
    on<HapusDeteksiEvent>(_onHapusDeteksi);
    on<FilterPetakEvent>(_onFilterPetak);
    on<MuatDataSimulasiEvent>(_onMuatDataSimulasi);
    on<HapusSemuaDataEvent>(_onHapusSemuaData);
    on<ToggleTemaEvent>(_onToggleTema);
  }

  void _onTambahDeteksi(TambahDeteksiEvent event, Emitter<DeteksiState> emit) {
    final updatedList = [event.data, ...state.semuaData];
    emit(state.copyWith(semuaData: updatedList));
  }

  void _onHapusDeteksi(HapusDeteksiEvent event, Emitter<DeteksiState> emit) {
    final updatedList =
        state.semuaData.where((item) => item.id != event.id).toList();
    emit(state.copyWith(semuaData: updatedList));
  }

  void _onFilterPetak(FilterPetakEvent event, Emitter<DeteksiState> emit) {
    emit(state.copyWith(filterPetak: event.petak));
  }

  void _onMuatDataSimulasi(
      MuatDataSimulasiEvent event, Emitter<DeteksiState> emit) {
    final dataBaru = buatDataSimulasi();
    final updatedList = [...dataBaru, ...state.semuaData];
    emit(state.copyWith(semuaData: updatedList));
  }

  void _onHapusSemuaData(
      HapusSemuaDataEvent event, Emitter<DeteksiState> emit) {
    emit(state.copyWith(semuaData: []));
  }

  void _onToggleTema(ToggleTemaEvent event, Emitter<DeteksiState> emit) {
    emit(state.copyWith(isDarkMode: event.isDarkMode));
  }
}
