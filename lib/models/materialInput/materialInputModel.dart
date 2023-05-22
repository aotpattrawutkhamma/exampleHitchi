class MaterialInputModel {
  const MaterialInputModel({this.MESSAGE, this.RESULT});

  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [RESULT!, MESSAGE!];

  static MaterialInputModel fromJson(dynamic json) {
    return MaterialInputModel(
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}
