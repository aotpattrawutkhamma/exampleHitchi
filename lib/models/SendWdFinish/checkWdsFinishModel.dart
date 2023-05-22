class CheckWdsFinishInputModel {
  const CheckWdsFinishInputModel({this.MESSAGE, this.RESULT, this.BATCHNO});
  final String? BATCHNO;
  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [RESULT!, MESSAGE!, BATCHNO!];

  static CheckWdsFinishInputModel fromJson(dynamic json) {
    return CheckWdsFinishInputModel(
      BATCHNO: json['batchNo'],
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}
