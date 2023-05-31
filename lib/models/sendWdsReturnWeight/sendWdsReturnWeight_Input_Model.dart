class sendWdsReturnWeightInputModel {
  const sendWdsReturnWeightInputModel({this.MESSAGE, this.TARGET, this.RESULT});
  final num? TARGET;
  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [TARGET!, RESULT!, MESSAGE!];

  static sendWdsReturnWeightInputModel fromJson(dynamic json) {
    return sendWdsReturnWeightInputModel(
      TARGET: json['target'],
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}
