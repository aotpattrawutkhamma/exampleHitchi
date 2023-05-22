part of 'machine_break_down_bloc.dart';

abstract class MachineBreakDownEvent extends Equatable {
  const MachineBreakDownEvent();

  @override
  List<Object> get props => [];
}

class MachineBreakDownSendEvent extends MachineBreakDownEvent {
  const MachineBreakDownSendEvent(this.items);

  final MachineBreakDownOutputModel items;

  @override
  List<Object> get prop => [items];
}
