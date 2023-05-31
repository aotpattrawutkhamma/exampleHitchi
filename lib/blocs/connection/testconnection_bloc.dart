import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/config.dart';
import 'package:hitachi/models/ResponeDefault.dart';

part 'testconnection_event.dart';
part 'testconnection_state.dart';

class TestconnectionBloc
    extends Bloc<TestconnectionEvent, TestconnectionState> {
  Dio dio = Dio();
  TestconnectionBloc() : super(TestconnectionInitial()) {
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
    on<TestconnectionEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<Test_ConnectionEvent>(
      (event, emit) async {
        try {
          emit(TestconnectionLoadingState());
          final mlist = await fetchTestConnection();
          emit(TestconnectionLoadedState(mlist));
        } catch (e) {
          emit(TestconnectionErrorState(e.toString()));
        }
      },
    );
  }

  Future<ResponeDefault> fetchTestConnection() async {
    try {
      Response responese = await dio.get(
        TEMP_API_URL + 'Connection/TestConnection',
        options: Options(
            headers: ApiConfig.HEADER(),
            sendTimeout: Duration(seconds: 3),
            receiveTimeout: Duration(seconds: 3)),
      );

      ResponeDefault items = ResponeDefault.fromJson(responese.data);
      return items;
    } on Exception {
      throw Exception();
    }
  }
}
