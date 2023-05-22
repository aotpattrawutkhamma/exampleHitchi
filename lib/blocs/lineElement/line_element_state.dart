part of 'line_element_bloc.dart';

abstract class LineElementState extends Equatable {
  const LineElementState();

  @override
  List<Object> get props => [];
}

class LineElementInitial extends LineElementState {}

//WindingHold
class PostSendWindingStartLoadingState extends LineElementState {
  const PostSendWindingStartLoadingState();
  @override
  List<Object> get props => [];
}

class PostSendWindingStartLoadedState extends LineElementState {
  const PostSendWindingStartLoadedState(this.item);
  final SendWindingStartModelInput item;

  @override
  List<Object> get props => [item];
}

class PostSendWindingStartErrorState extends LineElementState {
  const PostSendWindingStartErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

//WindingReturnWeight
class PostSendWindingStartReturnWeightLoadingState extends LineElementState {
  const PostSendWindingStartReturnWeightLoadingState();
  @override
  List<Object> get props => [];
}

class PostSendWindingStartReturnWeightLoadedState extends LineElementState {
  const PostSendWindingStartReturnWeightLoadedState(this.item);
  final sendWdsReturnWeightInputModel item;

  @override
  List<Object> get props => [item];
}

class PostSendWindingStartReturnWeightErrorState extends LineElementState {
  const PostSendWindingStartReturnWeightErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

///  WindingFinish
class PostSendWindingFinishLoadingState extends LineElementState {
  const PostSendWindingFinishLoadingState();
  @override
  List<Object> get props => [];
}

class PostSendWindingFinishLoadedState extends LineElementState {
  const PostSendWindingFinishLoadedState(this.item);
  final SendWdsFinishInputModel item;

  @override
  List<Object> get props => [item];
}

class PostSendWindingFinishErrorState extends LineElementState {
  const PostSendWindingFinishErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

///  CheckWindingFinish
class CheckWindingFinishLoadingState extends LineElementState {
  const CheckWindingFinishLoadingState();
  @override
  List<Object> get props => [];
}

class CheckWindingFinishLoadedState extends LineElementState {
  const CheckWindingFinishLoadedState(this.item);
  final CheckWdsFinishInputModel item;

  @override
  List<Object> get props => [item];
}

class CheckWindingFinishErrorState extends LineElementState {
  const CheckWindingFinishErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

// Check PACK NO
class GetCheckPackLoadingState extends LineElementState {
  const GetCheckPackLoadingState();
  @override
  List<Object> get props => [];
}

class GetCheckPackLoadedState extends LineElementState {
  const GetCheckPackLoadedState(this.item);
  final CheckPackNoModel item;

  @override
  List<Object> get props => [item];
}

class GetCheckPackErrorState extends LineElementState {
  const GetCheckPackErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

///  Report Route Sheet State
class GetReportRuteSheetLoadingState extends LineElementState {
  const GetReportRuteSheetLoadingState();
  @override
  List<Object> get props => [];
}

class GetReportRuteSheetLoadedState extends LineElementState {
  const GetReportRuteSheetLoadedState(this.item);
  final ReportRouteSheetModel item;

  @override
  List<Object> get props => [item];
}

class GetReportRuteSheetErrorState extends LineElementState {
  const GetReportRuteSheetErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

///  Post MaterialInput//////
class MaterialInputLoadingState extends LineElementState {
  const MaterialInputLoadingState();
  @override
  List<Object> get props => [];
}

class MaterialInputLoadedState extends LineElementState {
  const MaterialInputLoadedState(this.item);
  final MaterialInputModel item;

  @override
  List<Object> get props => [item];
}

class MaterialInputErrorState extends LineElementState {
  const MaterialInputErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

///  Post processInput//////
class ProcessStartLoadingState extends LineElementState {
  const ProcessStartLoadingState();
  @override
  List<Object> get props => [];
}

class ProcessStartLoadedState extends LineElementState {
  const ProcessStartLoadedState(this.item);
  final ProcessInputModel item;
  @override
  List<Object> get props => [item];
}

class ProcessStartErrorState extends LineElementState {
  const ProcessStartErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

///  Post processFinishInput//////
class ProcessFinishLoadingState extends LineElementState {
  const ProcessFinishLoadingState();
  @override
  List<Object> get props => [];
}

class ProcessFinishLoadedState extends LineElementState {
  const ProcessFinishLoadedState(this.item);
  final ProcessInputModel item;
  @override
  List<Object> get props => [item];
}

class ProcessFinishErrorState extends LineElementState {
  const ProcessFinishErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

///  GET MaterialInput//////
class CheckMaterialInputLoadingState extends LineElementState {
  const CheckMaterialInputLoadingState();

  @override
  List<Object> get props => [];
}

class CheckMaterialInputLoadedState extends LineElementState {
  const CheckMaterialInputLoadedState(this.item);
  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class CheckMaterialInputErrorState extends LineElementState {
  const CheckMaterialInputErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
