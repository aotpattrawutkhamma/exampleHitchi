import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/checkPackNo_Model.dart';
import 'package:hitachi/models/filmReceiveModel/filmreceiveOutputModel.dart';

part 'film_receive_event.dart';
part 'film_receive_state.dart';

class FilmReceiveBloc extends Bloc<FilmReceiveEvent, FilmReceiveState> {
  Dio dio = Dio();

  FilmReceiveBloc() : super(FilmReceiveInitial()) {
    dio.httpClientAdapter = IOHttpClientAdapter(
      onHttpClientCreate: (_) {
        // Don't trust any certificate just because their root cert is trusted.
        final HttpClient client =
            HttpClient(context: SecurityContext(withTrustedRoots: false));
        // You can test the intermediate / root cert here. We just ignore it.
        client.badCertificateCallback = (cert, host, port) => true;
        return client;
      },
    );
    on<FilmReceiveEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<FilmReceiveSendEvent>(
      (event, emit) async {
        try {
          emit(FilmReceiveLoadingState());
          final mlist = await fetchSendFilmReceive(event.items);
          emit(FilmReceiveLoadedState(mlist));
        } catch (e) {
          emit(FilmReceiveErrorState(e.toString()));
        }
      },
    );
    on<FilmReceiveCheckEvent>(
      (event, emit) async {
        try {
          emit(CheckFilmReceiveLoadingState());
          final mlist = await fetchCheckFilmReceive(event.items);
          emit(CheckFilmReceiveLoadedState(mlist));
        } catch (e) {
          emit(CheckFilmReceiveErrorState(e.toString()));
        }
      },
    );
  }
  Future<ResponeDefault> fetchSendFilmReceive(
      FilmReceiveOutputModel item) async {
    try {
      Response responese = await dio.post(ApiConfig.FILM_RECEIVE,
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(seconds: 60),
              receiveTimeout: Duration(seconds: 60)),
          data: jsonEncode(item));
      print(responese.data);
      ResponeDefault post = ResponeDefault.fromJson(responese.data);
      return post;
    } catch (e, s) {
      print("Exception occured: $e StackTrace: $s");
      return ResponeDefault();
    }
  }

  Future<CheckPackNoModel> fetchCheckFilmReceive(String item) async {
    try {
      Response responese = await dio.get(
        ApiConfig.CHECK_FILM_RECEIVE + item,
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 60),
            receiveTimeout: Duration(seconds: 60)),
      );
      print(responese.data);
      CheckPackNoModel post = CheckPackNoModel.fromJson(responese.data);
      return post;
    } on Exception {
      throw Exception();
    }
  }
}
