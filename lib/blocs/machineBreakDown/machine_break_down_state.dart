part of 'machine_break_down_bloc.dart';

abstract class MachineBreakDownState extends Equatable {
  const MachineBreakDownState();

  @override
  List<Object> get props => [];
}

class MachineBreakDownInitial extends MachineBreakDownState {}

class PostMachineBreakdownLoadingState extends MachineBreakDownState {
  const PostMachineBreakdownLoadingState();
  @override
  List<Object> get props => [];
}

class PostMachineBreakdownLoadedState extends MachineBreakDownState {
  const PostMachineBreakdownLoadedState(this.item);
  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class PostMachineBreakdownErrorState extends MachineBreakDownState {
  const PostMachineBreakdownErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
