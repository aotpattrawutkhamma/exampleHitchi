part of 'treatment_bloc.dart';

abstract class TreatmentState extends Equatable {
  const TreatmentState();

  @override
  List<Object> get props => [];
}

class TreatmentInitial extends TreatmentState {}

class TreatmentStartSendLoadingState extends TreatmentState {
  const TreatmentStartSendLoadingState();
  @override
  List<Object> get props => [];
}

class TreatmentStartSendLoadedState extends TreatmentState {
  const TreatmentStartSendLoadedState(this.item);
  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class TreatmentStartSendErrorState extends TreatmentState {
  const TreatmentStartSendErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

//Finish

class TreatmentFinishSendLoadingState extends TreatmentState {
  const TreatmentFinishSendLoadingState();
  @override
  List<Object> get props => [];
}

class TreatmentFinishSendLoadedState extends TreatmentState {
  const TreatmentFinishSendLoadedState(this.item);
  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class TreatmentFinishSendErrorState extends TreatmentState {
  const TreatmentFinishSendErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
