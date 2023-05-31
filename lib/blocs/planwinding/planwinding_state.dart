part of 'planwinding_bloc.dart';

abstract class PlanWindingState extends Equatable {
  const PlanWindingState();

  @override
  List<Object> get props => [];
}

class PlanWindingInitial extends PlanWindingState {}

class PlanWindingLoadingState extends PlanWindingState {
  const PlanWindingLoadingState();
  @override
  List<Object> get props => [];
}

class PlanWindingLoadedState extends PlanWindingState {
  const PlanWindingLoadedState(this.item);
  final PlanWindingOutputModel item;

  @override
  List<Object> get props => [item];
}

class PlanWindingErrorState extends PlanWindingState {
  const PlanWindingErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
