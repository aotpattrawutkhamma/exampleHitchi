import 'dart:convert';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:dio/dio.dart';
import 'package:dio/io.dart';
import 'package:equatable/equatable.dart';
import 'package:hitachi/api.dart';
import 'package:hitachi/models/ResponeDefault.dart';
import 'package:hitachi/models/machineBreakdown/machinebreakdownOutputMode.dart';

part 'machine_break_down_event.dart';
part 'machine_break_down_state.dart';

class MachineBreakDownBloc
    extends Bloc<MachineBreakDownEvent, MachineBreakDownState> {
  Dio dio = Dio();
  MachineBreakDownBloc() : super(MachineBreakDownInitial()) {
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
    on<MachineBreakDownEvent>((event, emit) {
      // TODO: implement event handler
    });
    on<MachineBreakDownSendEvent>(
      (event, emit) async {
        try {
          emit(PostMachineBreakdownLoadingState());
          final mlist = await fetchSendMachineBreakDown(event.items);
          emit(PostMachineBreakdownLoadedState(mlist));
        } catch (e) {
          emit(PostMachineBreakdownErrorState(e.toString()));
        }
      },
    );
  }

  Future<ResponeDefault> fetchSendMachineBreakDown(
      MachineBreakDownOutputModel item) async {
    try {
      Response responese = await dio.post(ApiConfig.MACHINE_BREAKDOWN,
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
}
