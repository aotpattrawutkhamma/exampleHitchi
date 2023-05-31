part of 'planwinding_bloc.dart';

abstract class PlanWindingEvent extends Equatable {
  const PlanWindingEvent();

  @override
  List<Object> get props => [];
}

class PlanWindingSendEvent extends PlanWindingEvent {
  const PlanWindingSendEvent();

  // final PlanWindingOutputModel items;
  // final String items;

  @override
  List<Object> get prop => [];
}
