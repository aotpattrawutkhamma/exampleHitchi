part of 'pm_daily_bloc.dart';

@immutable
abstract class PmDailyState {
  const PmDailyState();

  @override
  List<Object> get props => [];
}

class PmDailyInitial extends PmDailyState {}

//post

class PMDailyLoadingState extends PmDailyState {
  const PMDailyLoadingState();

  @override
  List<Object> get props => [];
}

class PMDailyLoadedState extends PmDailyState {
  const PMDailyLoadedState(this.item);
  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class PMDailyErrorState extends PmDailyState {
  const PMDailyErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
//Get Status

class PMDailyGetLoadingState extends PmDailyState {
  const PMDailyGetLoadingState();
  @override
  List<Object> get props => [];
}

class PMDailyGetLoadedState extends PmDailyState {
  const PMDailyGetLoadedState(this.item);
  final CPPMDailyOutputModel item;

  @override
  List<Object> get props => [item];
}

class PMDailyGetErrorState extends PmDailyState {
  const PMDailyGetErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
