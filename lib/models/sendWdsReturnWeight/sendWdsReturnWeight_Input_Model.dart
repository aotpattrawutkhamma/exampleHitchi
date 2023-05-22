class sendWdsReturnWeightInputModel {
  const sendWdsReturnWeightInputModel({this.MESSAGE, this.WEIGHT, this.RESULT});
  final num? WEIGHT;
  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [WEIGHT!, RESULT!, MESSAGE!];

  static sendWdsReturnWeightInputModel fromJson(dynamic json) {
    return sendWdsReturnWeightInputModel(
      WEIGHT: json['weight'],
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}
