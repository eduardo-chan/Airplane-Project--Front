part of 'airplane_cubit.dart';

abstract class AirplaneState extends Equatable {
  const AirplaneState();

  @override
  List<Object> get props => [];
}

class AirplaneInitial extends AirplaneState {}

class AirplaneLoading extends AirplaneState {}

class AirplaneLoaded extends AirplaneState {
  final List<Airplane> airplanes;

  const AirplaneLoaded(this.airplanes);

  @override
  List<Object> get props => [airplanes];
}

class AirplaneError extends AirplaneState {
  final String message;

  const AirplaneError(this.message);

  @override
  List<Object> get props => [message];
}
