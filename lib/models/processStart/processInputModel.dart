class ProcessInputModel {
  const ProcessInputModel({this.MESSAGE, this.RESULT, this.BATCHNO});

  final String? BATCHNO;
  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [RESULT!, MESSAGE!];

  static ProcessInputModel fromJson(dynamic json) {
    return ProcessInputModel(
      BATCHNO: json['batchNo'],
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}
