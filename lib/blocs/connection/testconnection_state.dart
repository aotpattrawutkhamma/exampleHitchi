part of 'testconnection_bloc.dart';

abstract class TestconnectionState extends Equatable {
  const TestconnectionState();

  @override
  List<Object> get props => [];
}

class TestconnectionInitial extends TestconnectionState {}

class TestconnectionLoadingState extends TestconnectionState {
  const TestconnectionLoadingState();
  @override
  List<Object> get props => [];
}

class TestconnectionLoadedState extends TestconnectionState {
  const TestconnectionLoadedState(this.item);
  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class TestconnectionErrorState extends TestconnectionState {
  const TestconnectionErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
