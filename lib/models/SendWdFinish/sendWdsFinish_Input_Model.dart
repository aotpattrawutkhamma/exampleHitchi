class SendWdsFinishInputModel {
  const SendWdsFinishInputModel({this.MESSAGE, this.RESULT});

  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [RESULT!, MESSAGE!];

  static SendWdsFinishInputModel fromJson(dynamic json) {
    return SendWdsFinishInputModel(
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}
