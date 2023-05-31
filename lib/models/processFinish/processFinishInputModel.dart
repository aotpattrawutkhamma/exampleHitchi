class ProcessFinishInputModel {
  const ProcessFinishInputModel({this.MESSAGE, this.RESULT});

  final bool? RESULT;
  final String? MESSAGE;

  List<Object> get props => [RESULT!, MESSAGE!];

  static ProcessFinishInputModel fromJson(dynamic json) {
    return ProcessFinishInputModel(
      RESULT: json['result'],
      MESSAGE: json['message'],
    );
  }
}

// class ProcessInputModel {
//   const ProcessInputModel({this.MESSAGE, this.RESULT});
//
//   final bool? RESULT;
//   final String? MESSAGE;
//
//   List<Object> get props => [RESULT!, MESSAGE!];
//
//   static ProcessInputModel fromJson(dynamic json) {
//     return ProcessInputModel(
//       RESULT: json['result'],
//       MESSAGE: json['message'],
//     );
//   }
// }
