part of 'pm_daily_bloc.dart';

// @immutable
abstract class PmDailyEvent extends Equatable {
  const PmDailyEvent();
  @override
  List<Object> get props => [];
}

class PMDailySendEvent extends PmDailyEvent {
  const PMDailySendEvent(this.items);

  final PMDailyOutputModel items;

  @override
  List<Object> get prop => [items];
}

class PMDailyGetSendEvent extends PmDailyEvent {
  const PMDailyGetSendEvent();

  // final String items;

  @override
  List<Object> get prop => [];
}
