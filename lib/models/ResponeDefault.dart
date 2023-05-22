class ResponeDefault {
  const ResponeDefault({this.MESSAGE, this.RESULT});

  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [RESULT!, MESSAGE!];

  static ResponeDefault fromJson(dynamic json) {
    return ResponeDefault(
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}
