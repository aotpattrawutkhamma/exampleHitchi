part of 'film_receive_bloc.dart';

abstract class FilmReceiveState extends Equatable {
  const FilmReceiveState();

  @override
  List<Object> get props => [];
}

class FilmReceiveInitial extends FilmReceiveState {}

class FilmReceiveLoadingState extends FilmReceiveState {
  const FilmReceiveLoadingState();
  @override
  List<Object> get props => [];
}

class FilmReceiveLoadedState extends FilmReceiveState {
  const FilmReceiveLoadedState(this.item);
  final ResponeDefault item;

  @override
  List<Object> get props => [item];
}

class FilmReceiveErrorState extends FilmReceiveState {
  const FilmReceiveErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}

class CheckFilmReceiveLoadingState extends FilmReceiveState {
  const CheckFilmReceiveLoadingState();
  @override
  List<Object> get props => [];
}

class CheckFilmReceiveLoadedState extends FilmReceiveState {
  const CheckFilmReceiveLoadedState(this.item);
  final CheckPackNoModel item;

  @override
  List<Object> get props => [item];
}

class CheckFilmReceiveErrorState extends FilmReceiveState {
  const CheckFilmReceiveErrorState(this.error);
  final String error;

  @override
  List<Object> get props => [error];
}
