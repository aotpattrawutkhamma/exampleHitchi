class ProcessInputModel {
  const ProcessInputModel({this.MESSAGE, this.RESULT});

  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [RESULT!, MESSAGE!];

  static ProcessInputModel fromJson(dynamic json) {
    return ProcessInputModel(
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}
