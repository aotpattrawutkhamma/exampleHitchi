import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/zincthickness/zincOutputModel.dart';

part 'zinc_thickness_event.dart';
part 'zinc_thickness_state.dart';

class ZincThicknessBloc extends Bloc<ZincThicknessEvent, ZincThicknessState> {
  Dio dio = Dio();
  ZincThicknessBloc() : super(ZincThicknessInitial()) {
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
    on<ZincThicknessEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<ZincThickNessSendEvent>(
      (event, emit) async {
        try {
          emit(ZincThicknessLoadingState());
          final mlist = await fetchSendZinc(event.items);
          emit(ZincThicknessLoadedState(mlist));
        } catch (e) {
          emit(ZincThicknessErrorState(e.toString()));
        }
      },
    );
  }

  Future<ResponeDefault> fetchSendZinc(ZincThicknessOutputModel item) async {
    try {
      Response responese = await dio.post(ApiConfig.ZINC_THICKNESS,
          options: Options(
              headers: ApiConfig.HEADER(),
              sendTimeout: Duration(minutes: 60),
              receiveTimeout: Duration(minutes: 60)),
          data: jsonEncode(item));
      print(responese.data);
      ResponeDefault post = ResponeDefault.fromJson(responese.data);
      return post;
    } on Exception {
      throw Exception();
    }
  }
}
