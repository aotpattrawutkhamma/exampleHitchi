part of 'zinc_thickness_bloc.dart';

abstract class ZincThicknessState extends Equatable {
  const ZincThicknessState();

  @override
  List<Object> get props => [];
}

class ZincThicknessInitial extends ZincThicknessState {}

class ZincThicknessLoadingState extends ZincThicknessState {
  const ZincThicknessLoadingState();
  @override
  List<Object> get props => [];
}

class ZincThicknessLoadedState extends ZincThicknessState {
  const ZincThicknessLoadedState(this.item);
  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class ZincThicknessErrorState extends ZincThicknessState {
  const ZincThicknessErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
