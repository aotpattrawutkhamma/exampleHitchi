class ProcessFinishInputModel {
  const ProcessFinishInputModel({this.MESSAGE, this.RESULT, this.BATCHNO});

  final String? BATCHNO;
  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [RESULT!, MESSAGE!];

  static ProcessFinishInputModel fromJson(dynamic json) {
    return ProcessFinishInputModel(
      BATCHNO: json['batchNo'],
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}
