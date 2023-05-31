class PMDailyModel {
  const PMDailyModel({
    this.ID,
    this.OPERATOR_NAME,
    this.CHECKPOINT,
    this.STATUS,
    this.DATEPM,
  });
  final int? ID;
  final String? OPERATOR_NAME;
  final String? CHECKPOINT;
  final String? STATUS;
  final String? DATEPM;

  List<Object> get props => [
        ID!,
        OPERATOR_NAME!,
        CHECKPOINT!,
        STATUS!,
        DATEPM!,
      ];
  PMDailyModel.fromMap(Map<String, dynamic> map)
      : ID = map['ID'],
        OPERATOR_NAME = map['OperatorName'],
        CHECKPOINT = map['CheckPointPM'],
        STATUS = map['Status'],
        DATEPM = map['DatePM'];
}
