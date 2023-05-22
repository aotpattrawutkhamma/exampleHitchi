part of 'zinc_thickness_bloc.dart';

abstract class ZincThicknessEvent extends Equatable {
  const ZincThicknessEvent();

  @override
  List<Object> get props => [];
}

class ZincThickNessSendEvent extends ZincThicknessEvent {
  const ZincThickNessSendEvent(this.items);

  final ZincThicknessOutputModel items;

  @override
  List<Object> get prop => [items];
}
