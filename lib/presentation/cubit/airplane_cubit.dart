import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../data/models/airplane_model.dart';
import '../../data/repository/airplane_repository.dart';

part 'airplane_state.dart';

class AirplaneCubit extends Cubit<AirplaneState> {
  final AirplaneRepository _airplaneRepository;

  AirplaneCubit(this._airplaneRepository) : super(AirplaneInitial());

  Future<void> fetchAirplanes() async {
    try {
      emit(AirplaneLoading());
      final airplanes = await _airplaneRepository.getAirplanes();
      emit(AirplaneLoaded(airplanes));
    } catch (e) {
      emit(AirplaneError(e.toString()));
    }
  }

  Future<void> addAirplane(Airplane airplane) async {
    try {
      emit(AirplaneLoading());
      final airplaneWithoutId = Airplane(
        id: '',
        modelo: airplane.modelo,
        fabricante: airplane.fabricante,
        capacidad: airplane.capacidad,
        rango: airplane.rango,
      );
      await _airplaneRepository.createAirplane(airplaneWithoutId);
      await fetchAirplanes();
    } catch (e) {
      emit(AirplaneError(e.toString()));
    }
  }

  Future<void> removeAirplane(String id) async {
    try {
      emit(AirplaneLoading());
      await _airplaneRepository.deleteAirplane(id);
      await fetchAirplanes();
    } catch (e) {
      emit(AirplaneError(e.toString()));
    }
  }

  Future<void> updateAirplane(Airplane airplane) async {
    try {
      emit(AirplaneLoading());
      await _airplaneRepository.updateAirplane(airplane);
      await fetchAirplanes();
    } catch (e) {
      emit(AirplaneError(e.toString()));
    }
  }
}
