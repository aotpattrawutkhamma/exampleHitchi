class CheckPackNoModel {
  const CheckPackNoModel({this.MESSAGE, this.PACK_NO, this.RESULT});
  final String? PACK_NO;
  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [PACK_NO!, RESULT!, MESSAGE!];

  static CheckPackNoModel fromJson(dynamic json) {
    return CheckPackNoModel(
      PACK_NO: json['packNo'],
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}
