part of 'film_receive_bloc.dart';

abstract class FilmReceiveEvent extends Equatable {
  const FilmReceiveEvent();

  @override
  List<Object> get props => [];
}

class FilmReceiveSendEvent extends FilmReceiveEvent {
  const FilmReceiveSendEvent(this.items);

  final FilmReceiveOutputModel items;

  @override
  List<Object> get prop => [items];
}
