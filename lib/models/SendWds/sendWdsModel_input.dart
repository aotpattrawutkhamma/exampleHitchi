class SendWindingStartModelInput {
  const SendWindingStartModelInput({this.MESSAGE, this.PACK_NO, this.RESULT});
  final String? PACK_NO;
  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [PACK_NO!, RESULT!, MESSAGE!];

  static SendWindingStartModelInput fromJson(dynamic json) {
    return SendWindingStartModelInput(
      PACK_NO: json['packNo'],
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}
