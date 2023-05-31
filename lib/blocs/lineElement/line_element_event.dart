part of 'line_element_bloc.dart';

abstract class LineElementEvent extends Equatable {
  const LineElementEvent();

  @override
  List<Object> get props => [];
}

class PostSendWindingStartEvent extends LineElementEvent {
  const PostSendWindingStartEvent(this.items);

  final SendWindingStartModelOutput items;

  @override
  List<Object> get prop => [items];
}

class PostSendWindingStartReturnWeightEvent extends LineElementEvent {
  const PostSendWindingStartReturnWeightEvent(this.items);

  final sendWdsReturnWeightOutputModel items;

  @override
  List<Object> get prop => [items];
}

class PostSendWindingFinishEvent extends LineElementEvent {
  const PostSendWindingFinishEvent(this.items);

  final SendWdsFinishOutputModel items;

  @override
  List<Object> get prop => [items];
}

class CheckWindingFinishEvent extends LineElementEvent {
  const CheckWindingFinishEvent(this.items);

  final String items;

  @override
  List<Object> get prop => [items];
}

//// Check Pack No /////////
class GetCheckPackNoEvent extends LineElementEvent {
  const GetCheckPackNoEvent(this.number);

  final int number;

  @override
  List<Object> get prop => [number];
}

///////////////////////-----Report Route Sheet Event-----//////////////////////////////
class ReportRouteSheetEvenet extends LineElementEvent {
  const ReportRouteSheetEvenet(this.items);

  final String items;

  @override
  List<Object> get prop => [items];
}

//////////////////------------MaterialEvent-----------///////////////
class MaterialInputEvent extends LineElementEvent {
  const MaterialInputEvent(this.items);

  final MaterialOutputModel items;

  @override
  List<Object> get prop => [items];
}

//////////////////------------ProcessStartEvent-----------///////////////
class ProcessStartEvent extends LineElementEvent {
  const ProcessStartEvent(this.items);

  final ProcessOutputModel items;
  @override
  List<Object> get prop => [items];
}

//////////////////------------ProcessFinishEvent-----------///////////////
class ProcessFinishInputEvent extends LineElementEvent {
  const ProcessFinishInputEvent(this.items);

  final ProcessFinishOutputModel items;
  @override
  List<Object> get prop => [items];
}

//////////////////------------MaterialEvent-----------///////////////
class CheckMaterialInputEvent extends LineElementEvent {
  const CheckMaterialInputEvent(this.items);

  final String items;
  @override
  List<Object> get prop => [items];
}

// //////////////////------------MaterialEvent-----------///////////////
// class PMDailySendEvent extends LineElementEvent {
//   const PMDailySendEvent(this.items);
//
//   final PMDailyOutputModel items;
//
//   @override
//   List<Object> get prop => [items];
// }
